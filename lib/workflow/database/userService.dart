import 'package:chatgpt_dart_server_with_shelf/user_mapper/user.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/database/connectionPool.dart';
import 'package:mysql1/mysql1.dart';
class UserService{

  static Future<bool> deleteUserByUserId(int id) async{
    var conn = await ConnectionPool.getAConnection();
    var result = await conn.query('delete from user where userId = ?',[id]);
    ConnectionPool.backConnection(conn);
    if(result.affectedRows==1){
      return true;
    }else{
      return false;
    }
  }


  static Future<bool> deleteUserByUsername(String username) async {
    var conn = await ConnectionPool.getAConnection();
    var result = await conn.query('delete from user where username = ?',[username]);
    ConnectionPool.backConnection(conn);
    if(result.affectedRows==1){
      return true;
    }else{
      return false;
    }
  }


  static Future<List<User>> getAllUser() async {
    var conn = await ConnectionPool.getAConnection();
    Results result = await conn.query('select * from user');
    List<User> users = [];
    for(var row in result){
      users.add(User.full(int.parse(row['userId'].toString()), row['username'] as String, row['password'] as String,row['current_key'] as String, int.parse(row['key_token'].toString()),int.parse(row['totalToken'].toString())));
    }
    ConnectionPool.backConnection(conn);
    return users;
  }


  static Future<User> getUserByUsername(String username) async {
    var conn = await ConnectionPool.getAConnection();
    Results result = await conn.query('select * from user where username = ?',[username]);
    User user = User.start(-1);
    for(var row in result){
      user = User.full(int.parse(row['userId'].toString()), row['username'] as String, row['password'] as String,row['current_key'] as String, int.parse(row['key_token'].toString()),int.parse(row['totalToken'].toString()));
    }
    ConnectionPool.backConnection(conn);
    return user;
  }


  static Future<bool> insertUser(User user)async {
    var conn = await ConnectionPool.getAConnection();
    var result = await conn.query('insert into user(username, password, current_key, key_token, totalToken)'
        ' VALUE (?,?,?,?,?,?)',[user.username,user.password,user.current_key,user.current_key,user.totalToken]);
    ConnectionPool.backConnection(conn);
    if(result.insertId==null){
      return false;
    }else{
      user.userId = result.insertId!;//修改内存中该User的id值
      return true;
    }
  }


  static Future<bool> updateUser(User user)async {
    if(user.userId==null){
      //某些地方出现了问题
      User u = await getUserByUsername(user.username);
      user.userId = u.userId;
    }
    var conn = await ConnectionPool.getAConnection();
    var result = await conn.query('update user set username=?,password=?,current_key=?,key_token=?,totalToken=?',[user.username,user.password,user.current_key,user.key_token,user.totalToken]);
    ConnectionPool.backConnection(conn);
    return result.affectedRows==1;
  }



  static Future<User> getUserByUserId(int? id) async{
    if(id==null){
      return User.start(-1);
    }
    var conn = await ConnectionPool.getAConnection();
    Results result = await conn.query('select * from user where userId = ?',[id]);
    User user = User.start(-1);
    for(var row in result){
      user = User.full(int.parse(row['userId'].toString()), row['username'] as String, row['password'] as String,row['current_key'] as String, int.parse(row['key_token'].toString()),int.parse(row['totalToken'].toString()));
    }
    ConnectionPool.backConnection(conn);
    return user;
  }

}