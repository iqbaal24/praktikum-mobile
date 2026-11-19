import 'package:shared_preferences/shared_preferences.dart';

/// Class untuk menampung informasi sesi (login) pengguna.
class LoginInfo {
  String username;
  String password;
  bool isLoggedIn;

  LoginInfo({
    this.username = '',
    this.password = '',
    this.isLoggedIn = false,
  });

  // Menyimpan informasi sesi ke Shared Preferences.
  Future<void> saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // Membaca informasi sesi dari Shared Preferences.
  static Future<LoginInfo> fromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    final password = prefs.getString('password') ?? '';
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return LoginInfo(
      username: username,
      password: password,
      isLoggedIn: isLoggedIn,
    );
  }

  // Menghapus informasi sesi dari Shared Preferences.
  static Future<void> deleteFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('isLoggedIn');
  }

  @override
  String toString() {
    return 'LoginInfo{username: $username, password: $password, isLoggedIn: $isLoggedIn}';
  }
}
