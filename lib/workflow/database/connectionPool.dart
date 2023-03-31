import 'dart:core';

import 'package:chatgpt_dart_server_with_shelf/workflow/database/connectionImpl.dart';
import 'package:mysql1/mysql1.dart';

class ConnectionPool{
  static int maxPool = 20;
  static int currentConnections = 0;
  static List<MySqlConnection> connections = [];
  static Future<bool> fillUpPool() async{
    for(int i = 0;i<maxPool;i++){
      addConnection();
    }
    // 未加处理的异步线程，直接返回true，预计会创建20个连接池
    return true;
  }
  static Future<MySqlConnection> getAConnection()async{
    if(currentConnections>0){
      return connections[--currentConnections];
    }else{
      await addConnection();
      return getAConnection();
    }
  }
  static Future<bool> backConnection(MySqlConnection conn) async{
    if(conn!=null){
      currentConnections++;
      connections.add(conn);
      return true;
    }
    return false;
  }
  static Future<bool> addConnection()async{
    MySqlConnection conn = await ConnectionImpl().getConnection();
    if(conn!=null){
      currentConnections++;
      connections.add(conn);
      return true;
    }
    return false;
  }
}