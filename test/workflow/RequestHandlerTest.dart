import 'dart:collection';

import 'package:chatgpt_dart_server_with_shelf/workflow/user/RequestHandler.dart';

void main(){
  HashMap<String,int> map = HashMap();
  print(map['jk']);
  map.putIfAbsent('jk', () => 1);
  print(map['jk']);
  // print(RequestHandler.containRequestKey("lovey${11111198}"));
  // print(RequestHandler.containRequestKey("lovey${11111198}"));
  // print(RequestHandler.containRequestKey("lovey${11111198}"));
}