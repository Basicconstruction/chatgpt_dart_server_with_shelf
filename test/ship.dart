// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// void main() async {
//   // 创建代理服务器并绑定端口
//   final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
//
//   print('代理服务器已启动，正在监听 ${server.address}:${server.port}');
//
//   // 监听客户端请求
//   await for (var request in server) {
//     try {
//       // 解析请求的URL
//       var url = Uri.parse('https://api.openai.com/v1/chat/completions');
//
//       // 创建新的HTTP客户端
//       var client = HttpClient();
//       final apiKey = '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';
//       final headers = {'Content-Type': 'octet-stream', 'Authorization': 'Bearer $apiKey'};
//       Map<String, dynamic> requestBody = jsonDecode(await (request as http.Request).readAsString());//json解构
//       final body = jsonEncode({
//         "model": "gpt-3.5-turbo",
//         "messages": requestBody['message'],
//         "temperature": 0.7,
//         "max_tokens":1000
//       });
//       var proxyRequest = await client.openUrl(request.method, url);
//
//       // 发送代理请求并获取响应
//       var response = await proxyRequest.close();
//
//       // 将响应内容直接传递给客户端
//       request.response.statusCode = response.statusCode;
//       request.response.headers.set('content-type', response.headers.contentType.toString());
//       await response.pipe(request.response);
//     } catch (e) {
//       // 处理任何异常并向客户端发送错误响应
//       request.response.statusCode = HttpStatus.internalServerError;
//       await request.response.close();
//     }
//   }
// }
