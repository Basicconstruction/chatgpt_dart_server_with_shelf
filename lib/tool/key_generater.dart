import 'dart:math';

String generateRandomString() {
  final random = Random();
  const charset =
      r'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%';
  var result = '';

  for (var i = 0; i < 5; i++) {
    result += charset[random.nextInt(charset.length)];
  }

  for (var i = 0; i < 8; i++) {
    result += random.nextInt(10).toString();
  }

  return result;
}