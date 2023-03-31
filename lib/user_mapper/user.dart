class User{
  int userId = 0;
  String username='';
  String password='';
  String current_key='';
  int key_token=0;
  int totalToken=0;
  User.fromLogin(this.username,this.password);
  User.important(this.userId,this.username,this.password,this.current_key,this.key_token);
  User.full(this.userId,this.username,this.password,this.current_key,this.key_token,this.totalToken);

  User.start(this.userId);

  @override
  String toString() {
    return 'User{userId: $userId, name: $username, password: $password, current_key: $current_key, key_token: $key_token, totalToken: $totalToken}';
  }
}