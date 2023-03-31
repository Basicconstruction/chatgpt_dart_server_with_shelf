
import 'dart:collection';

import 'package:chatgpt_dart_server_with_shelf/user_mapper/user.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/user/KeyUserTable.dart';

import '../database/userService.dart';
// 记录key当前可用token的快表
// 需要在登录时加入连接信息
class KeyHandler{
  static HashMap<String,int> quickMap = HashMap();
  static void addData(String key,int availableToken){
    quickMap.putIfAbsent(key, () => availableToken);
  }
  static bool updateByConsume(String key,int consumeToken){
    int? token = quickMap[key];
    if(token!=null){
      quickMap[key] = token-consumeToken;
      return true;
    }
    return false;
  }
  static Future<bool> syncWithDateBase(String key) async{
    if(quickMap.containsKey(key)){
      int? current_token = quickMap[key];
      if(current_token==null){
        return true;
      }else{
        User user = await UserService.getUserByUserId(KeyUserTable.k_u[key]);
        user.current_key = key;
        user.key_token = current_token;
        if(await UserService.updateUser(user)){
          return true;
        }else{
          return false;
        }
      }
    }else{
      return true;
    }
  }
  static Future<bool> syncWithDatabaseById(int id)async{
    User user = await UserService.getUserByUserId(id);
    String key = '';
    for(String s in KeyUserTable.k_u.keys){
      if(KeyUserTable.k_u[s]==id){
        key = s;
        break;
      }
    }
    user.current_key = key;
    user.key_token = quickMap[key]!;
    if(user.key_token==null){
      return false;
    }
    if(await UserService.updateUser(user)){
      return true;
    }else{
      return false;
    }
  }
  static Future<bool> finalization()async{
    bool r = true;
    for(var key in quickMap.keys){
      int value = quickMap[key]??0;
      User user = await UserService.getUserByUserId(KeyUserTable.k_u[key]);
      user.current_key = key;
      user.key_token = value;
      if((await UserService.updateUser(user))){
        r = false;
        print('对 id = ${user.userId}的用户进行同步时，出现了错误');
      }else{
        print('完成了对 id = ${user.userId}的用户的同步');
      }
    }
    print('完成所有用户的信息同步');
    if(!r){
      print('但是出现了一些错误');
    }
    return r;
  }
  //每分钟同步一次
  static bool clearCache(){

    return false;
  }

}