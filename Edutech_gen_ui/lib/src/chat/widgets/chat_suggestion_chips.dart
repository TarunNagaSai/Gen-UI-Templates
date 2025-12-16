import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:education_gen_ui/src/chat/widgets/chat_suggestion_chip.dart';

class ChatSuggestionChips extends ConsumerWidget {
  const ChatSuggestionChips({super.key, required this.onSendMessage});

  final void Function(String) onSendMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        ChatSuggestionChip(
          label: 'What is photosynthesis?',
          icon: Icons.grass,
          onTap: (label) => onSendMessage(label),
        ),
        ChatSuggestionChip(
          label: 'Explain how mountains are formed',
          icon: Icons.terrain,
          onTap: (label) => onSendMessage(label),
        ),
        ChatSuggestionChip(
          label: 'How did Alexander the great conquer the world?',
          icon: Icons.history_edu,
          onTap: (label) => onSendMessage(label),
        ),
      ],
    );
  }
}
