import 'dart:io' show Cookie, File, ProcessSignal, exit;

import 'package:chatgpt_dart_server_with_shelf/api_handler/chat_handle.dart';
import 'package:chatgpt_dart_server_with_shelf/login_handle/check_access.dart';
import 'package:chatgpt_dart_server_with_shelf/login_handle/login_handle.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/database/userService.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/key/KeyHandler.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/staticProperty/staticProperty.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_session/cookies_middleware.dart';
import 'package:shelf_session/session_middleware.dart';
import 'package:shelf_static/shelf_static.dart';

//dart compile exe bin/main.dart
void main(List<String> args) async {
  ProcessSignal.sigint.watch().listen((signal) async {
    // 处理 Ctrl+C 中断操作，比如关闭文件、保存进度等操作
    print("程序即将终止,请等待工作完成");
    await KeyHandler.finalization();
    print("工作完成");
    exit(0); // 退出程序
  });
  await serveAt();
}
serveAt() async{
  final router = Router();
  
  router.all('/v1/chat/completions',(Request request){
    var response = checkAccess(request);
    if(response!=null){
      return response;
    }
    return chatHandle(request);
  });
  router.post('/app/login',loginHandle);
  final handler = Cascade().add(router).handler;
  final overrideHeaders = {
  ACCESS_CONTROL_ALLOW_ORIGIN: '*'};
  final pipeline = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(cookiesMiddleware())
      .addMiddleware(sessionMiddleware())
      .addMiddleware(corsHeaders(headers: overrideHeaders))
      .addHandler(handler);
  const address = '0.0.0.0';
  const port = 8082;
  final server = await io.serve(pipeline,address,port);
  print("Serving at http://${server.address.host}:${server.port}");
}