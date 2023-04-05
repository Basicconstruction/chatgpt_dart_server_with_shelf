import 'dart:async';
import 'dart:convert';
import 'dart:io' show Cookie, File, ProcessSignal, exit;

import 'package:dio/dio.dart' as dio;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_session/cookies_middleware.dart';
import 'package:shelf_session/session_middleware.dart';
import 'package:shelf_static/shelf_static.dart';
// import 'package:http/http.dart' as http;
//dart compile exe bin/main.dart
void main(List<String> args) async {
  await serveAt();
}
serveAt() async{
  final router = Router();
  router.all('/v1/chat/completions',chatHandle);
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
  const port = 8083;
  final server = await io.serve(pipeline,address,port);
  print("Serving at http://${server.address.host}:${server.port}");
}
// Future<Response> chatHandle(Request request)async{
//   Map<String, dynamic> requestBody = jsonDecode(await request.readAsString());//json解构
//   var corsHeaders = {'Access-Control-Allow-Origin': '*'};
//   final apiKey = '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';
//   final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'};
//   final body = jsonEncode({
//     "model": "gpt-3.5-turbo",
//     "messages": requestBody['message'],
//     "temperature": 0.7,
//     "max_tokens":1000
//   });
//   StreamController<String> sc = StreamController();
//   try{
//     // final response = await dio.Dio().post('https://api.openai.com/v1/chat/completions',data: body,queryParameters: headers,
//     //     options: dio.Options(responseType: dio.ResponseType.stream));
//     final response = await dio.Dio().post('https://ai-included.com',options: dio.Options(responseType: dio.ResponseType.stream));
//     ()async{
//       await response.data.stream.listen((data){
//         sc.sink.add(data.toString());
//       });
//       sc.close();
//     }();
//   }catch(e){
//     print('error: '+e.toString());
//   }
//   Stream<String> ss2 = sc.stream.map((s)=>s);
//   return Response.ok(headers: corsHeaders,ss2);
// }

Future<Response> chatHandle(Request request) async {
  final corsHeaders = {'Access-Control-Allow-Origin': '*'};
  final apiKey = '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';
  final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'};

  try {
    final requestBody = jsonDecode(await request.readAsString());
    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": requestBody['message'],
      "temperature": 0.7,
      "max_tokens": 1000,
    });

    final response = await dio.Dio().post(
      'https://api.openai.com/v1/chat/completions',
      data: body,
      options: dio.Options(responseType: dio.ResponseType.stream, headers: headers),
    );

    return Response.ok(
      response.data.stream.map((data) => data),
      headers: corsHeaders,
    );
  } catch (e) {
    print('error: ${e.toString()}');
    return Response.internalServerError(headers: corsHeaders);
  }
}