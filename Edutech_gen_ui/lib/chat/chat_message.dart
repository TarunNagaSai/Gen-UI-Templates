class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage({
    required this.message,
    required this.isUser,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        'isUser': isUser,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'].toString(),
      isUser: json['isUser'].toString() == "true",
    );
  }
}
