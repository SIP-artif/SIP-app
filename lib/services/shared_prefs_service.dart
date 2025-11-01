import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserIdToPrefs(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
}

Future<String?> getUserIdFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

Future<void> clearUserIdFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
}
