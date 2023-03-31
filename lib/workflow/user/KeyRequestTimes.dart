
import 'dart:collection';
//存储key和调用次数的快表
// 需要在请求或登录时加入信息
class KeyRequestTimes{
  static HashMap<String,int> times = HashMap();
  static bool addRequestTime(String key){
    int? time = times[key];
    if(time==null){
      times.putIfAbsent(key, () => 1);
    }else if(time<=8){
      times[key] = time+1;
    }else{
      syncDatabase(key);
    }
    return true;
  }
  static Future<bool> syncDatabase(String key) async{
    // 调用服务
    return true;
  }
}