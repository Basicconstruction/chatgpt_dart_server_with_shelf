import 'package:mysql1/mysql1.dart';

class ConnectionImpl{
  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: '101.43.116.202',
        port: 3306,
        user: 'root',
        password: 'sakura99@',
        db: 'gpt'
    );
    var conn = await MySqlConnection.connect(settings);
    return conn;
  }
}