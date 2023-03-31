import 'dart:convert';
import 'dart:math';
import 'package:chatgpt_dart_server_with_shelf/user_mapper/user_mapper.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/database/userService.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/key/KeyHandler.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/staticProperty/staticProperty.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/user/KeyRequestTimes.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/user/KeyUserTable.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/user/RequestHandler.dart';
import 'package:shelf/shelf.dart';
import '../user_mapper/user.dart';

Future<Response> loginHandle (Request request)async{
  final body = await request.readAsString(Encoding.getByName('utf-8'));
  String username='';
  String password='';
  try{
    var msgs = jsonDecode(body);//首先使用json进行解码
    username = msgs['username']??''..trim();
    password = msgs['password']??''..trim();
  }catch(e){
    //json解码失败,使用默认的x-ww-from-urlencoded解码
    print('json解码失败,使用默认的x-ww-from-urlencoded解码');
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
  if(u.userId<0){
    return Response.unauthorized(jsonEncode({'message':'不正确或不在记录的的用户信息'}));
  }
  int? max_key_token = int.tryParse(Property.config['temporary_default_token']!);
  max_key_token ??= 100000;
  int bt = u.totalToken;
  int bc = u.key_token;
  if(u.key_token<max_key_token){
    //尝试在每一次登录时，把key_token充满.
    int total = u.key_token+u.totalToken;
    int allocate = min(total,max_key_token);
    total = total - allocate;
    u.totalToken = total;
    u.key_token = allocate;
    if(!await UserService.updateUser(u)){
      u.key_token = bc;
      u.totalToken = bt;//回退
      print("程序负载较大，数据库更新失败。重要失败！");
    }
  }
  final userMapper = UserMapper();
  userMapper.setUser(request, u);//填入session
  KeyHandler.quickMap.putIfAbsent(u.current_key, () => u.key_token);
  KeyRequestTimes.times.putIfAbsent(u.current_key, () => 0);
  KeyUserTable.k_u.putIfAbsent(u.current_key, () => u.userId);
  return Response.ok(jsonEncode({'message':'登录成功','temporary_key':''}));
}
// final queryParameters = Uri(query:body).queryParameters;
// print(body);//username=key&password=word
// print(queryParameters);//{username: key, password: word}
// print(jsonDecode(body));
// final username = queryParameters['username']??''..trim();
// final password = queryParameters['password']??''..trim();
//return Response.unauthorized(jsonEncode({'message':'不正确或不在记录的的用户信息'}));