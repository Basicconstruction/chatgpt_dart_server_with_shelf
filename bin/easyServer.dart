import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

Future<void> main() async {
  var handler = createStaticHandler('index', defaultDocument: 'resources/index.html');
  var corsHeaders = {'Access-Control-Allow-Origin': '*'
  ,'content-type':'text/html'};

  var pipeline = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler((request) async {
    if (request.method == 'OPTIONS') {
      return shelf.Response.ok('', headers: corsHeaders);
    }

    var response = await handler(request);
    return shelf.Response(response.statusCode,
        headers: corsHeaders, body: response.read());
  });

  var server = await io.serve(pipeline, InternetAddress.anyIPv4, 10000);
  print('Server running on ${server.address}:${server.port}');
}
