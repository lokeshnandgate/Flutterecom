// import '../../../shared/services/api_service.dart';

import 'package:ecom/shared/services/api_service.dart';

class AuthService {
  final ApiService apiService;

  AuthService(this.apiService);
  Future<Map<String, dynamic>> loginUser(String identifier, String password) async {
    try {
      final response = await apiService.post('auth/user/login', {
        'identifier': identifier,
        'password': password,
      });

      if (!response.containsKey('token') || 
          !response.containsKey('userId') || 
          !response.containsKey('userType')) {
        throw Exception('Invalid login response');
      }

      return response;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<Map<String, dynamic>> loginBusiness(String identifier, String password) async {
    final response = await apiService.post('auth/business/login', {
      'identifier': identifier,
      'password': password,
    });
    return response;
  }

  Future<Map<String, dynamic>> registerUser(
    String username, 
    String email, 
    String password,
  ) async {
    final response = await apiService.post('auth/user/register', {
      'username': username,
      'email': email,
      'password': password,
    });
    return response;
  }

  Future<Map<String, dynamic>> registerBusiness(
    String username,
    String email,
    String password,
    String businessType,
  ) async {
    final response = await apiService.post('auth/business/register', {
      'username': username,
      'email': email,
      'password': password,
      'businessType': businessType,
    });
    return response;
  }

  Future<void> logout() async {
    await apiService.post('auth/logout', {});
  }
}