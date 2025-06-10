import '../../../shared/services/api_service.dart';

class ProfileService {
  final ApiService apiService;

  ProfileService(this.apiService);

  Future<dynamic> getProfile(String userId) async {
    return await apiService.get('profile/$userId');
  }

  Future<dynamic> updateProfile(Map<String, dynamic> profileData) async {
    return await apiService.put('profile', profileData);
  }

  Future<dynamic> uploadProfilePicture(String userId, String imagePath) async {
    // Implementation for file upload would go here
    // This would typically use a multipart request
    return await apiService.post('profile/$userId/picture', {});
  }
}