import 'dart:io';

import 'package:dio/dio.dart';

void main() async {
  Dio dio = Dio();
  final rs = await dio.get(
    "https://www.google.com/search?q=How+does+dart+shelf+stream+data+to+customers&sxsrf=APwXEddY7paD-rEfEHwVQsf_7KXS7DbjaQ%3A1680493131010&ei=S0oqZNgah9qQ8g-vjpqQCw&ved=0ahUKEwiY7Pvg5Iz-AhUHLUQIHS-HBrIQ4dUDCA8&uact=5&oq=How+does+dart+shelf+stream+data+to+customers&gs_lcp=Cgxnd3Mtd2l6LXNlcnAQAzIFCAAQogQyBQgAEKIEMgUIABCiBDIFCAAQogQyBQgAEKIEOgcIIxDqAhAnSgQIQRgAUABYhFdglVxoAXABeACAAb4CiAG-ApIBAzMtMZgBAKABAaABArABCsABAQ&sclient=gws-wiz-serp",
    options: Options(responseType: ResponseType.stream), // Set the response type to `stream`.
  );
  int i = 0;
  await rs.data.stream.listen((data){
    print("data: ${i++}"+String.fromCharCodes(data));
    sleep(Duration(seconds: 1));
  });
  print("end");
}
