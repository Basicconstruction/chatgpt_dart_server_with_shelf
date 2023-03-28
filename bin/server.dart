import 'dart:io' show Cookie;

import 'package:chatgpt_dart_server_with_shelf/api_handler/chat_handle.dart';
import 'package:chatgpt_dart_server_with_shelf/login_handle/check_access.dart';
import 'package:chatgpt_dart_server_with_shelf/login_handle/login_handle.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_session/cookies_middleware.dart';
import 'package:shelf_session/session_middleware.dart';
import 'package:shelf_static/shelf_static.dart';

void main(List<String> args) async {
  await serveAt();
}
serveAt() async{
  final router = Router();
  // router.get('/v1/chat/completions',chatHandle);
  // router.post('/v1/chat/completions',chatHandle);
  router.all('/v1/chat/completions',(Request request){
    var response = checkAccess(request);
    if(response!=null){
      return response;
    }
    return chatHandle(request);
  });
  router.post('/app/login',loginHandle);
  final handler = Cascade().add(router).handler;
  final pipeline = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(cookiesMiddleware())
      .addMiddleware(sessionMiddleware())
      .addHandler(handler);
  const address = '0.0.0.0';
  const port = 8082;
  final server = await io.serve(pipeline,address,port);
  print("Serving at http://${server.address.host}:${server.port}");
}