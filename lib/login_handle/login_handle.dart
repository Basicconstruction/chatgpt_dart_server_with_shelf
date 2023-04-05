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

//主要流程 首先检查请求参数，如果参数不全，则返回错误信息
// 参数全的时候查看数据库，检查信息是否正确，如果正确则返回登录信息，包含秘钥以及用户信息
// 为了安全，需要保证https请求，而不能使用http
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
  if(u.userId<0||u.password!=password){
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
  return Response.ok(jsonEncode({
    'message':'登录成功',
    'code':Property.config['supplier']==null?'299':'200',
    'temporary_key':'',
    'data':{
      'id': u.userId,
      'token':u.key_token,
      'username':u.username,
      'password':u.password,
      'supplier':Property.config['supplier']
    },
  }));
}
// final queryParameters = Uri(query:body).queryParameters;
// print(body);//username=key&password=word
// print(queryParameters);//{username: key, password: word}
// print(jsonDecode(body));
// final username = queryParameters['username']??''..trim();
// final password = queryParameters['password']??''..trim();
//return Response.unauthorized(jsonEncode({'message':'不正确或不在记录的的用户信息'}));