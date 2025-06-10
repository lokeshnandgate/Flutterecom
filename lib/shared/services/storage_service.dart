import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String tokenKey = 'token';
  static const String userKey = 'user_data';
  static const String isBusinessKey = 'is_business';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<void> saveUser(dynamic user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, json.encode(user));
  }

  Future<dynamic> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(userKey);
    return userString != null ? json.decode(userString) : null;
  }

  Future<void> saveIsBusiness(bool isBusiness) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isBusinessKey, isBusiness);
  }

  Future<bool> getIsBusiness() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isBusinessKey) ?? false;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userKey);
    await prefs.remove(isBusinessKey);
  }
}