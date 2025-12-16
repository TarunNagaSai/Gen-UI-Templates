import 'package:flutter/material.dart';
import 'package:education_gen_ui/src/chat/widgets/chat_suggestion_chips.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key, required this.onSendMessage});
  final void Function(String) onSendMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.tertiary,
                  theme.colorScheme.tertiaryContainer,
                ],
              ),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 80),
          ),
          const SizedBox(height: 24),
          Text(
            'Learn everything thing with AI',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Ask me anything related to your studies and get instant answers, explanations, with videos and tutorials.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ChatSuggestionChips(onSendMessage: onSendMessage),
        ],
      ),
    );
  }
}
