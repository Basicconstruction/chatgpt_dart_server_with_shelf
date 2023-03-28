import 'dart:convert';
import 'package:chatgpt_dart_server_with_shelf/user_mapper/user_mapper.dart';
import 'package:shelf/shelf.dart';

import '../user_mapper/user.dart';


Future<Response> loginHandle (Request request)async{
  final body = await request.readAsString(Encoding.getByName('utf-8'));
  final queryParameters = Uri(query:body).queryParameters;
  final username = queryParameters['username']??''..trim();
  final password = queryParameters['password']??''..trim();
  if(username.isEmpty||password.isEmpty){
    return Response.unauthorized({'message':'不正确或不在记录的的用户信息'});
  }
  final user = User(username,password);
  final userMapper = UserMapper();
  userMapper.setUser(request, user);
  return Response.ok({'message':'登录成功','temporary_key':''});
}