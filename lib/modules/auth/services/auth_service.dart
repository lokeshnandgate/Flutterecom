import 'package:ecom/config.dart';

import '../../../shared/services/api_service.dart';

class AuthService {
  final ApiService apiService;

  AuthService(this.apiService);

  Future<dynamic> loginUser(String identifier, String password) async {
    return await apiService.post('${AppConfig.apiUrl}/api/login/login', {
      'identifier': identifier,
      'password': password,
    });
  }

  Future<dynamic> loginBusiness(String identifier, String password) async {
    final response = await apiService.post('${AppConfig.apiUrl}/api/login/business', {
      'identifier': identifier,
      'password': password,
    });

    if (response == null || response['token'] == null) {
      throw Exception('API Error: Missing token in response');
    }

    return response['token'];
  }

  Future<dynamic> registerUser(String username, String email, String password) async {
    return await apiService.post('userreg/register', {
      'username': username,
      'email': email,
      'password': password,
    });
  }

  Future<dynamic> registerBusiness(
    String username,
    String email,
    String password,
    String businessType,
  ) async {
    return await apiService.post('businessreg/breg', {
      'username': username,
      'email': email,
      'password': password,
      'businessType': businessType,
    });
  }
}