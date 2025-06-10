import '../../../shared/services/api_service.dart';

class ChatService {
  final ApiService apiService;

  ChatService(this.apiService);

  Future<List<dynamic>> getChats() async {
    return await apiService.get('chat/chats');
  }

  Future<dynamic> getChatDetails(String chatId) async {
    return await apiService.get('chat/chats/$chatId');
  }

  Future<List<dynamic>> getMessages(String chatId) async {
    return await apiService.get('chat/messages/$chatId');
  }

  Future<dynamic> sendMessage(String chatId, String content) async {
    return await apiService.post('chat/messages', {
      'chatId': chatId,
      'content': content,
    });
  }

  Future<dynamic> createChat(List<String> participantIds, String? chatName) async {
    return await apiService.post('chat/chats', {
      'participantIds': participantIds,
      'chatName': chatName,
    });
  }
}