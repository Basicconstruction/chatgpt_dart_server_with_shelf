import 'dart:convert';
import 'dart:math';
import 'package:chatgpt_dart_server_with_shelf/workflow/key/KeyHandler.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/user/KeyRequestTimes.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/user/RequestHandler.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import '../workflow/staticProperty/staticProperty.dart';
Future<Response> chatHandle(Request request)async{
  Map<String, dynamic> requestBody = jsonDecode(await request.readAsString());//json解构
  String key = requestBody['temporary_key'].trim();
  int? keyI = int.tryParse(key.substring(5));
  var corsHeaders = {'Access-Control-Allow-Origin': '*'};
  if(key.length!=13||keyI==null){
    return Response(201,headers: corsHeaders,body:'key格式不符合规则，该key是用来辨认客户身份的key。');
  }
  if(RequestHandler.containRequestKey(key)){
    return Response(202,headers: corsHeaders,body:'请等待先前的请求结束');
  }
  KeyRequestTimes.addRequestTime(key);//标识用户请求进入用户请求队列
  final apiKey = 'sk-CKvjRkhQKMV2mEYarBAiT367568hhghjtjtyutyujty';
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'};
  int av_token = KeyHandler.quickMap[key]??0;
  if(av_token<100){
    return Response(203,headers: corsHeaders,body: '剩余token数较少，无法得到有效的回答，请充值token');
  }
  final body = jsonEncode({
    "model": "gpt-3.5-turbo",
    "messages": requestBody['message'],
    "temperature": 0.7,
    "max_tokens":min(av_token,int.tryParse(Property.config['default_max_token']!)??0)
  });
  final response = await http.post(url, headers: headers, body: body);
  final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
  // print(jsonResponse);
  RequestHandler.removeRequest(key);//移除用户key的请求队列
  if (response.statusCode == 200) {
    final completions = jsonResponse['choices'][0]['message']['content'].toString();
    int consume = int.tryParse(jsonResponse['usage']['total_tokens'].toString())??0;
    KeyHandler.updateByConsume(key, consume);
    //
    return Response.ok(headers: corsHeaders,completions);
  }
  return Response(500,headers: corsHeaders,body:'服务器错误,请联系管理员或站长');

}
/*
http://154.19.184.190:8082/v1/chat/completions
{
"message": [
{
"role": "assistant",
"content": "How i can help you?"
},
{
"role": "user",
"content": "how can i get a american phone in china!"
}
]
}
 */