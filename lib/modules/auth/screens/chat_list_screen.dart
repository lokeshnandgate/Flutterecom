import 'package:ecom/redux/thunk_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../app/app_state.dart';
import '../../../app/routes.dart';
import '../../../models/chat_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(context).dispatch(fetchChatsThunk());
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ChatListViewModel>(
      converter: (Store<AppState> store) {
        return _ChatListViewModel(
          chats: store.state.chats,
          isLoading: store.state.isLoading,
          error: store.state.error,
          currentUserId: store.state.user?.id ?? '',
        );
      },
      builder: (context, vm) {
        final chats = _filterChats(vm.chats, '');

        return Scaffold(
          appBar: AppBar(
            title: const Text('Messages'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ChatSearchDelegate(vm.chats, vm.currentUserId),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showNewChatDialog,
              ),
            ],
          ),
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : vm.error != null
                  ? Center(child: Text('Error: ${vm.error}'))
                  : chats.isEmpty
                      ? const Center(
                          child: Text(
                            'No chats yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            return _buildChatItem(chat, vm.currentUserId);
                          },
                        ),
        );
      },
    );
  }

  List<ChatModel> _filterChats(List<ChatModel> chats, String query) {
    return chats.where((chat) {
      final chatName =
          (chat.chatName ?? chat.participantIds.join(', ')).toLowerCase();
      return chatName.contains(query.toLowerCase());
    }).toList();
  }

  Widget _buildChatItem(ChatModel chat, String currentUserId) {
    final isGroup = chat.participantIds.length > 2;
    final displayName = chat.chatName ??
        chat.participantIds.where((id) => id != currentUserId).join(', ');

    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            chat.chatImage != null ? NetworkImage(chat.chatImage!) : null,
        child: chat.chatImage == null
            ? Icon(isGroup ? Icons.group : Icons.person)
            : null,
      ),
      title:
          Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        chat.lastMessage ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: chat.lastMessageTime != null
          ? Text(
              _formatTime(chat.lastMessageTime!),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.chatDetail,
          arguments: chat.id,
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Chat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('New Individual Chat'),
              onTap: () {
                Navigator.pop(context);
                _showUserSelectionDialog(false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('New Group Chat'),
              onTap: () {
                Navigator.pop(context);
                _showUserSelectionDialog(true);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUserSelectionDialog(bool isGroup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isGroup ? 'Create Group Chat' : 'Start New Chat'),
        content: const Text('User selection functionality would be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add create chat logic here
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _ChatListViewModel {
  final List<ChatModel> chats;
  final bool isLoading;
  final String? error;
  final String currentUserId;

  _ChatListViewModel({
    required this.chats,
    required this.isLoading,
    required this.error,
    required this.currentUserId,
  });
}

class ChatSearchDelegate extends SearchDelegate {
  final List<ChatModel> chats;
  final String currentUserId;

  ChatSearchDelegate(this.chats, this.currentUserId);

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    final filtered = chats.where((chat) {
      final name = (chat.chatName ??
              chat.participantIds.where((id) => id != currentUserId).join(', '))
          .toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final chat = filtered[index];
        final isGroup = chat.participantIds.length > 2;
        final displayName = chat.chatName ??
            chat.participantIds.where((id) => id != currentUserId).join(', ');

        return ListTile(
          leading: CircleAvatar(
            child: Icon(isGroup ? Icons.group : Icons.person),
          ),
          title: Text(displayName),
          onTap: () {
            close(context, null);
            Navigator.pushNamed(
              context,
              Routes.chatDetail,
              arguments: chat.id,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
