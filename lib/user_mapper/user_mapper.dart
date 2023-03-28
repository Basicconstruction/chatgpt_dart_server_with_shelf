import 'package:shelf/shelf.dart';
import 'package:shelf_session/session_middleware.dart';
import 'package:chatgpt_dart_server_with_shelf/user_mapper/user.dart';
class UserMapper{
  User? getUser(Request request){
    final session = Session.getSession(request);
    if(session==null){
      return null;
    }
    final user = session.data['user'];
    if(user is User){
      return user;
    }
    return null;
  }
  User setUser(Request request,User user){
    var session = Session.getSession(request);
    session ??= Session.createSession(request);
    session.data['user'] = user;
    return user;
  }
}