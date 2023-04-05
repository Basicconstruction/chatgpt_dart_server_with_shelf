import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final client = HttpClient();
  final request = await client.postUrl(Uri.parse('http://154.19.184.190:8083/v1/chat/completions'));
  final response = await request.close();

  // 设置响应流类型
  if (response.headers.contentType?.mimeType == 'application/octet-stream') {
    // 处理流式HTTP响应数据
    await for (var data in response) {
      // 每次接收到一些数据就会打印
      print('Received ${data.length} bytes: $data');
    }
  } else {
    // 处理普通HTTP响应数据
    final content = await utf8.decodeStream(response);
    print('Received ${response.contentLength} bytes: $content');
  }

  client.close();
}
