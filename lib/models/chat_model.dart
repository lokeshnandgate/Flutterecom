class ChatModel {
  final String id;
  final List<String> participantIds;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? chatName;
  final String? chatImage;

  ChatModel({
    required this.id,
    required this.participantIds,
    this.lastMessage,
    this.lastMessageTime,
    this.chatName,
    this.chatImage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      participantIds: List<String>.from(json['participantIds']),
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
      chatName: json['chatName'],
      chatImage: json['chatImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'chatName': chatName,
      'chatImage': chatImage,
    };
  }
}
