
import 'dart:collection';

import '../../user_mapper/user.dart';
// 根据key获得用户id,然后进行数据库操作
// 需要在登录时加入连接信息
class KeyUserTable{
  static HashMap<String,int> k_u = HashMap();
  bool containSecurityKey(String key){
    return k_u.keys.contains(key);
  }
  bool containUser(int userId){
    return k_u.values.contains(userId);
  }
  bool addKeyUser(String key,int userId){
    k_u.putIfAbsent(key, () => userId);
    return true;
  }
}