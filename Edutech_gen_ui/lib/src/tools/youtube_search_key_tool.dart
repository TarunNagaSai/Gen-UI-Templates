import 'package:education_gen_ui/src/services/youtube_service.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// This is a AI tool to search YouTube videos based on a search key.
/// Basic MCP tool implementation
class YoutubeSearchKeyTool extends AiTool<Map<String, Object?>> {
  YoutubeSearchKeyTool()
    : super(
        name: "YouTube Search Key Tool",
        description: "A tool to search YouTube videos based on a search key.",
        parameters: S.object(
          properties: {
            'searchKey': S.string(
              description: 'The search key to find relevant YouTube videos.',
            ),
          },
          required: ['searchKey'],
        ),
      );

  @override
  Future<Map<String, Object?>> invoke(JsonMap args) async {
    final String searchKey = args['searchKey'] as String;
    // Implement the logic to search YouTube videos using the searchKey.
    final result = await YouTubeService().searchVideos(query: searchKey);

    /// Send the result to the youtube card
    return result.toJson();
  }
}
