class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime sentTime;
  final MessageStatus status;
  final MessageType type;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.sentTime,
    this.status = MessageStatus.sent,
    this.type = MessageType.text,
  });

  // Add fromJson/toJson methods if needed
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'],
      sentTime: DateTime.parse(json['sentTime']),
      status: MessageStatus.values[json['status']],
      type: MessageType.values[json['type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'sentTime': sentTime.toIso8601String(),
      'status': status.index,
      'type': type.index,
    };
  }
}

enum MessageStatus {
  sent,
  delivered,
  read,
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
}