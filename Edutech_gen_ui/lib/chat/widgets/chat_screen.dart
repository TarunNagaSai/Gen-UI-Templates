import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart' hide ChatMessage;
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:education_gen_ui/chat/bloc/ai_bloc.dart';
import 'package:education_gen_ui/chat/chat_message.dart';
import 'package:education_gen_ui/chat/widgets/chat_empty_state.dart';
import 'package:education_gen_ui/chat/widgets/chat_message_input.dart';
import 'package:education_gen_ui/chat/widgets/chat_message_list.dart';
import 'package:education_gen_ui/chat/widgets/trip_card.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final GenUiConversation conversation;

  final List<String> surfaceIds = <String>[];

  @override
  void initState() {
    super.initState();
    context.read<AiBloc>().add(InitializeAiEvent(context: context));
    final Catalog catalog = CoreCatalogItems.asCatalog().copyWith([tripCard]);
    final generator = FirebaseAiContentGenerator(
      catalog: catalog,
      systemInstruction: ''' 
              You are a helpful travel assistant AI named Travel Gen AI.
              Your purpose is to assist users in planning their travel itineraries, suggesting destinations, and providing travel tips.
              Always respond in a friendly and engaging manner.
              
              When I send a message, generate new UI that displays the travel information I requested.
          ''',
    );
    conversation = GenUiConversation(
      genUiManager: GenUiManager(catalog: catalog),
      contentGenerator: generator,
      onSurfaceAdded: _onSurfaceAdded,
      onSurfaceDeleted: _onSurfaceDeleted,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSurfaceAdded(SurfaceAdded surface) {
    setState(() {
      surfaceIds.add(surface.surfaceId);
    });
  }

  void _onSurfaceDeleted(SurfaceRemoved surface) {
    setState(() {
      surfaceIds.remove(surface.surfaceId);
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _handleSendMessage(String text) async {
    final msg = text.trim();
    if (msg.isNotEmpty) {
      _messageController.clear();
      return conversation.sendRequest(UserMessage.text(text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Gen AI'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AiBloc>().add(ResetMessagesEvent(context: context));
            },
          ),
        ],
      ),
      body: BlocConsumer<AiBloc, AiState>(
        listener: (context, state) {
          // Auto-scroll when new content arrives during streaming
          if (state is AiLoadingState || state is AiLoadedState) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          List<ChatMessage> messages = [];
          bool isLoading = false;

          if (state is AiLoadedState) {
            messages = state.messages;
          } else if (state is AiLoadingState) {
            messages = state.messages;
            isLoading = true;
          } else if (state is AiErrorState) {
            messages = state.messages;
          } else if (state is AiInitializingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? const ChatEmptyState()
                    : ChatMessageList(
                        messages: messages,
                        isLoading: isLoading,
                        scrollController: _scrollController,
                        surfaceIds: surfaceIds,
                        conversation: conversation,
                      ),
              ),
              ChatMessageInput(
                controller: _messageController,
                onSendMessage: _handleSendMessage,
              ),
            ],
          );
        },
      ),
    );
  }
}

final _schema = S.object(
  properties: {
    'title': S.string(description: 'Title of the travel destination'),
    'description': S.string(
      description: 'Description of the travel destination',
    ),
    'imageUrl': S.string(
      description: 'URL of an image representing the destination',
    ),
    'bestTimeToVisit': S.string(
      description: 'Best time to visit the destination',
    ),
    'activities': S.list(
      description: 'List of recommended activities at the destination',
      items: S.string(),
    ),
  },
  required: ['title', 'description', 'imageUrl', 'activities'],
);

final tripCard = CatalogItem(
  name: "TripCard",
  dataSchema: _schema,
  widgetBuilder: (CatalogItemContext context) {
    final json = context.data as Map<String, dynamic>;
    final title = json['title'] as String;
    final description = json['description'] as String;
    final imageUrl = json['imageUrl'] as String;
    final activities =
        (json['activities'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];
    final bestTime = json['bestTimeToVisit'] as String?;

    return TripCard(
      title: title,
      description: description,
      imageUrl: imageUrl,
      activities: activities,
      bestTimeToVisit: bestTime,
    );
  },
);
