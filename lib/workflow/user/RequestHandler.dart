import 'dart:collection';
// 存储key的快表，如果表中已经有该key说明已经有一个请求在进行，拦截后续请求
// 请求结束时，将该记录清除。为了避免key前列过多，key的格式需要注意。
// 需要在请求时加入信息,请求结束时退出
class RequestHandler{
  static HashMap<String,List<int>> handler = HashMap();
  static bool containRequestKey(String key){
    String keyS = key.substring(0,5);
    int keyI = int.parse(key.substring(5));
    if(!handler.containsKey(keyS)){
      handler.putIfAbsent(keyS, () => [keyI]);
      return false;
    }else{
      List<int>? second = handler[keyS];
      if(second==null){
        handler[keyS] = [keyI];
        return false;
      }
      if(!second.contains(keyI)){
        handler[keyS] = [keyI];
        return false;
      }
      return true;
    }
  }
  static void removeRequest(String key){
    String keyS = key.substring(0,5);
    int keyI = int.parse(key.substring(5));
    if(!handler.containsKey(keyS)){
      return;
    }
    List<int>? second = handler[keyS];
    if(second==null){
      return;
    }
    if(!second.contains(keyI)){
      return;
    }
    second.remove(keyI);
  }
}