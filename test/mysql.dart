import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'package:test/expect.dart';
Future<void> main(List<String> arguments) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'gz-cynosdbmysql-grp-6pq5yqd5.sql.tencentcdb.com',
      port: 20248,
      user: 'root',
      db: 'ai_included',
      password: 'sakura99@'));
  print(conn);
  var id = 1;
  var results = await conn.query('select name,entity from provider where id = ?', [id]);
  for(var row in results){
    print("${row[0]} ${row[1]}");
  }
}