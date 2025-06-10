import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../app/app_state.dart';
import '../../../../models/chat_model.dart';
import '../../../../models/message_model.dart';
import '../../../shared/services/api_service.dart';
import '../../../shared/services/storage_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late ChatModel _chat;
  List<MessageModel> _messages = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _messageController = TextEditingController();
  bool _showInfo = false;

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  Future<void> _loadChat() async {
    try {
      final apiService = ApiService(StorageService());
      final chatResponse = await apiService.get('chat/chats/${widget.chatId}/getchatdetail');
      final messagesResponse = await apiService.get('chat/messages/${widget.chatId}/getmessage');

      setState(() {
        _chat = ChatModel.fromJson(chatResponse);
        _messages = (messagesResponse as List)
            .map((m) => MessageModel.fromJson(m))
            .toList()
            .reversed
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final apiService = ApiService(StorageService());
      final response = await apiService.post(
        'chat/messages/sendmessage',
        {
          'chatId': widget.chatId,
          'content': _messageController.text,
        },
      );

      setState(() {
        _messages.insert(0, MessageModel.fromJson(response));
        _messageController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String?>(
      converter: (store) => store.state.user?.id,
      builder: (context, userId) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_chat.chatName ?? 'Chat'),
            actions: [
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  setState(() {
                    _showInfo = !_showInfo;
                  });
                },
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text('Error: $_error'))
                  : Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                reverse: true,
                                itemCount: _messages.length,
                                padding: const EdgeInsets.all(12),
                                itemBuilder: (context, index) {
                                  final message = _messages[index];
                                  final isMe = message.senderId == userId;
                                  return _buildMessageBubble(message, isMe);
                                },
                              ),
                            ),
                            _buildMessageInput(),
                          ],
                        ),
                        if (_showInfo) _buildChatInfo(context),
                      ],
                    ),
        );
      },
    );
  }

  Widget _buildMessageBubble(MessageModel message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              message.sentTime.toLocal().toString().substring(11, 16),
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildChatInfo(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Chat Info',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 40,
                  child: const Icon(Icons.chat, size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  _chat.chatName ?? 'Chat',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Delete chat
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete Chat'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
