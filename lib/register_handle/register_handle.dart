import 'dart:convert';

import 'package:chatgpt_dart_server_with_shelf/tool/key_generater.dart';
import 'package:shelf/shelf.dart';

import '../user_mapper/user.dart';
import '../workflow/database/userService.dart';
import '../workflow/staticProperty/staticProperty.dart';

Future<Response> registerHandle(Request request)async{
  // 使用utf8解码
  final body = await request.readAsString(Encoding.getByName('utf-8'));
  String username='';
  String password='';
  try{
    var msgs = jsonDecode(body);//首先使用json进行解码
    username = msgs['username']??''..trim();
    password = msgs['password']??''..trim();
  }catch(e){
    //json解码失败,使用默认的x-ww-from-urlencoded解码
    //print('json解码失败,使用默认的x-ww-from-urlencoded解码');
  }finally{
    if(username.isEmpty||password.isEmpty){
      final queryParameters = Uri(query:body).queryParameters;
      username = queryParameters['username']??''..trim();
      password = queryParameters['password']??''..trim();
    }
  }
  if(username.isEmpty||password.isEmpty)
  {
    return Response.unauthorized(jsonEncode({'message':'请求数据不完整,请输入用户名以及密码'}));
  }
  User u = await UserService.getUserByUsername(username);
  if(u.userId>=0){
    return Response.forbidden(jsonEncode({
      'code': 299,
      'message':'用户名已经存在,请选择其他用户名'
    }));
  }
  User user = User.fromLogin(username, password);
  String key = generateRandomString();
  user.current_key = key;
  user.key_token = int.tryParse(Property.config['reward_for_register']??'0')??0;
  UserService.insertUser(user);
  return Response(200,body:{//没有检查供应商设置
    'code':200,
    'message':'注册成功',
    'data':{
      'id': u.userId,
      'token':u.key_token,
      'username':u.username,
      'password':u.password,
      'supplier':Property.config['supplier']
    }
  });
}