import 'package:auto_route/auto_route.dart';
import 'package:education_gen_ui/src/catalogs/catalogs.dart';
import 'package:education_gen_ui/src/chat/widgets/chat_empty_state.dart';
import 'package:education_gen_ui/src/chat/widgets/conversations.dart';
import 'package:education_gen_ui/src/const/education_system_prompt.dart';
import 'package:education_gen_ui/src/services/youtube_service.dart';
import 'package:education_gen_ui/src/tools/youtube_search_key_tool.dart';
import 'package:education_gen_ui/src/utils/loggin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genui/genui.dart';
import 'package:education_gen_ui/src/providers/ai_provider.dart';
import 'package:education_gen_ui/src/chat/widgets/chat_message_input.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';

@RoutePage()
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final surfaceIds = <String>[];

  /// AI conversation instance
  late final GenUiConversation _uiConversation;
  late final GenUiManager genUiManager;

  @override
  void initState() {
    /// Initialize GenUiManager and Content Generator
    genUiManager = GenUiManager(
      catalog: eduAppCatalog,
      configuration: const GenUiConfiguration(
        actions: ActionsConfig(
          allowCreate: true,
          allowUpdate: true,
          allowDelete: true,
        ),
      ),
    );
    genUiManager.dataModels;

    /// genui_firebase_ai content generator
    final FirebaseAiContentGenerator generator = FirebaseAiContentGenerator(
      catalog: eduAppCatalog,
      systemInstruction: educationSystemPrompt,
      additionalTools: [
        YoutubeSearchKeyTool(listOfVideos: YouTubeService().searchVideos),
      ],
    );

    generator.inputTokenUsage;
    generator.outputTokenUsage;

    /// Initialize GenUiConversation with [genUiManager] and [generator]
    /// Set up callbacks to handle updates and scrolling
    /// to bottom on new messages
    _uiConversation = GenUiConversation(
      genUiManager: genUiManager,
      contentGenerator: generator,
      onSurfaceAdded: surfaceAdded,
      onSurfaceUpdated: surfaceUpdated,
      onSurfaceDeleted: surfaceRemoved,
      onTextResponse: onTextResponse,
      onError: onError,
    );
    super.initState();
  }

  /// Actions to be performed when new UI is added to chat.
  void surfaceAdded(SurfaceAdded surfaceAdded) {
    surfaceIds.add(surfaceAdded.surfaceId); // "youtube_video_display"
    final context = surfaceAdded.definition.asContextDescriptionText(); //
    logging.info(
      context,
    ); // "A user interface is shown..........'Start Quiz!'}}}}}}."
    final value = genUiManager.getSurfaceNotifier(surfaceAdded.surfaceId).value;

    logging.info(value);

    _scrollToBottom(); // scroll to the bottom of the chat
  }

  /// Actions to be performed when surface is updated
  void surfaceUpdated(SurfaceUpdated surfaceUpdated) {
    /// Check if surface id is prest
    if (!surfaceIds.contains(surfaceUpdated.surfaceId)) {
      surfaceIds.add(surfaceUpdated.surfaceId);
    }
    final value = genUiManager
        .getSurfaceNotifier(surfaceUpdated.surfaceId)
        .value;

    logging.info(value);

    _scrollToBottom(); //scroll the chat to bottom of the chat
  }

  void surfaceRemoved(SurfaceRemoved surfacedRemoved) {
    surfaceIds.remove(
      surfacedRemoved.surfaceId,
    ); // When widget is removed from the chat.
  }

  // If AI responded with a text based response.
  void onTextResponse(String text) {
    if (!mounted) return;
    if (text.isNotEmpty) {
      _scrollToBottom();
    }
  }

  // if a error is generated in the ai response
  void onError(ContentGeneratorError onError) {
    // record this error in firebase crashlytics
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
      ref.read(aiChatProvider.notifier).sendMessage(text);
      _uiConversation.sendRequest(UserMessage.text(text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduTech Gen AI'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(aiChatProvider.notifier).resetMessages();
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final aiChatState = ref.watch(aiChatProvider);
          return aiChatState.when(
            data: (chatState) {
              return Column(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<List<ChatMessage>>(
                      valueListenable: _uiConversation.conversation,
                      builder: (context, messages, child) {
                        if (messages.isEmpty) {
                          return ChatEmptyState(
                            onSendMessage: _handleSendMessage,
                          );
                        }
                        return Conversation(
                          messages: messages,
                          manager: _uiConversation.genUiManager,
                          scrollController: _scrollController,
                        );
                      },
                    ),
                  ),

                  ValueListenableBuilder(
                    valueListenable: _uiConversation.isProcessing,
                    builder: (context, value, child) {
                      return ChatMessageInput(
                        controller: _messageController,
                        onSendMessage: _handleSendMessage,
                        isLoading: _uiConversation.isProcessing.value,
                      );
                    },
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(aiChatProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
