import 'package:flutter/material.dart';
import 'package:education_gen_ui/chat/widgets/chat_suggestion_chips.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

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
            child: const Icon(
              Icons.flight_takeoff,
              color: Colors.white,
              size: 80,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Plan Your Dream Trip',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Tell me about your travel plans and I\'ll help you create the perfect itinerary!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const ChatSuggestionChips(),
        ],
      ),
    );
  }
}
