import 'package:flutter/material.dart';
import 'package:genui/genui.dart' hide ChatMessage;
import 'package:education_gen_ui/chat/chat_message.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isLoading;
  final ScrollController scrollController;
  final List<String> surfaceIds;
  final GenUiConversation conversation;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.surfaceIds,
    required this.scrollController,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: surfaceIds.length,
      itemBuilder: (context, index) {
        final id = surfaceIds[index];
        return GenUiSurface(host: conversation.host, surfaceId: id);
      },
    );
  }
}
