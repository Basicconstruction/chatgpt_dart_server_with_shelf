import 'package:chatgpt_dart_server_with_shelf/user_mapper/user.dart';
import 'package:chatgpt_dart_server_with_shelf/workflow/database/userService.dart';

void main()async{
  // User u = await UserService().getUserByUserId(1);
  // print(u);
  User u = User.start(-2);
  print(u.hashCode);
  UserTest(u);
  print(u.hashCode);
}
void UserTest(User u){
  // u = User.start(-1);
  u.userId = 100;
  print(u.hashCode);
  print(u.userId);
}