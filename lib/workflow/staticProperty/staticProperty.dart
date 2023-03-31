
import 'dart:io';

class Property{
  static Map<String, String> config = {
    'temporary_default_token': '100000',
  };
  static void init(){
    String filename = 'resources/config.ini'; // 数据文件的名称
    // 读取数据文件
    File file = File(filename);
    String contents = file.readAsStringSync();

    // 使用正则表达式匹配键值对，并将其存储到map中
    RegExp pattern = RegExp(r'(\w+)=(\w+)');
    Iterable<Match> matches = pattern.allMatches(contents);
    matches.forEach((match) {
      String? key = match.group(1);
      String? value = match.group(2);
      if(key!=null&&value!=null){
        config[key] = value;
      }
    });

    // 输出map中的键值对，用于验证
    // config.forEach((key, value) {
    //   print('$key: $value');
    // });
  }
}