import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

Future<Response> chatHandle(Request request)async{
  try{
    final apiKey = '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';
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'};
    Map<String, dynamic> requestBody = jsonDecode(await request.readAsString());//json解构
    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": requestBody['message'],
      "temperature": 0.7,
      "max_tokens":1000
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final completions = data['choices'][0]['message']['content'].toString();
      return Response.ok(completions);
    }
    return Response.ok(response.statusCode);
  }catch(e){
    return Response.badRequest(body:{'message':'500 error occur in server!'});
  }

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