import 'package:dio/dio.dart';

void main() async {
  Dio dio = Dio();
  final rs = await dio.get(
    "https://ai-included.com/",
    options: Options(responseType: ResponseType.stream), // Set the response type to `stream`.
  );
  int i = 0;
  await rs.data.stream.listen((data){
    print("data: ${i++}"+String.fromCharCodes(data));
  });
  print("end");
}
