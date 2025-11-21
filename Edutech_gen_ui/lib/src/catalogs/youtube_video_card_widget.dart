import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

final _schema = S.object(
  properties: {
    'videoId': S.string(
      description: 'The YouTube video ID to display in the card.',
    ),
    'action': S.object(
      description: 'The action to perform when the item is tapped.',
      properties: {
        'name': S.string(description: 'The name of the action to perform.'),
        'context': S.object(
          description:
              'The context to pass along with the action. This can include'
              'additional information about the video or user interaction.',
          properties: {
            'analysisPrompt': S.string(
              description:
                  'A prompt to guide the analysis of the YouTube video.',
            ),
            'youtubeVideo': S.string(
              description:
                  'The URL of the YouTube video in the format "https://www.youtube.com/watch?v={videoId}".',
            ),
          },
          required: ['analysisPrompt', 'youtubeVideo'],
        ),
      },
      required: ['name'],
    ),
  },
  required: ['videoId', 'action'],
);

final youtubeCardWidgetCatalog = CatalogItem(
  name: 'YoutubeVideoCardWidget',
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, String>;

    final videoId = data["videoId"] as String;
    final action = data["action"] as Map<String, String>;

    return YouTubeVideoCardWidget(
      videoId: videoId,
      widgetId: itemContext.id,
      action: action,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
  dataSchema: _schema,
  exampleData: [_example1, _example2],
);

class YouTubeVideoCardWidget extends StatefulWidget {
  final String videoId;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;
  final Map<String, dynamic> action;

  const YouTubeVideoCardWidget({
    super.key,
    required this.videoId,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
    required this.action,
  });

  @override
  State<YouTubeVideoCardWidget> createState() => _YouTubeVideoCardWidgetState();
}

class _YouTubeVideoCardWidgetState extends State<YouTubeVideoCardWidget> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          YoutubePlayerScaffold(
            controller: _controller,
            builder: (context, player) {
              return AspectRatio(aspectRatio: 16 / 9, child: player);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                icon: Icon(Icons.auto_awesome),
                onPressed: () {
                  /// Dispatch the action with context
                  final List<Object?> contextDefinition =
                      (widget.action['context'] as List<Object?>?) ??
                      <Object?>[];
                  final String actionName = widget.action['name'] as String;

                  /// Resolve the context
                  final JsonMap resolvedContext = resolveContext(
                    widget.dataContext,
                    contextDefinition,
                  );

                  /// Dispatch the event
                  widget.dispatchEvent(
                    UserActionEvent(
                      name: actionName,
                      sourceComponentId: widget.widgetId,
                      context: resolvedContext,
                    ),
                  );
                },
                label: Text("Analyze"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _example1() =>
    '''{'videoId': 'dQw4w9WgXcQ',"action": "name": "selectExperience"}''';

String _example2() =>
    '''{'videoId': '3JZ_D3ELwOQ',"action": "name": "selectExperience"}''';
