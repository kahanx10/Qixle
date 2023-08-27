import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenService {
  static Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('authToken', token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('authToken');
  }

  static Future<void> clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('authToken');
  }
}
