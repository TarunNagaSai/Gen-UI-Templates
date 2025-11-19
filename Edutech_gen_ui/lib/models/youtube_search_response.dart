class YouTubeSearchResponse {
  final String kind;
  final String etag;
  final String? nextPageToken;
  final String regionCode;
  final PageInfo pageInfo;
  final List<SearchResultItem> items;

  YouTubeSearchResponse({
    required this.kind,
    required this.etag,
    this.nextPageToken,
    required this.regionCode,
    required this.pageInfo,
    required this.items,
  });

  factory YouTubeSearchResponse.fromJson(Map<String, dynamic> json) {
    return YouTubeSearchResponse(
      kind: json['kind'] as String,
      etag: json['etag'] as String,
      nextPageToken: json['nextPageToken'] as String?,
      regionCode: json['regionCode'] as String,
      pageInfo: PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((item) => SearchResultItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'etag': etag,
      'nextPageToken': nextPageToken,
      'regionCode': regionCode,
      'pageInfo': pageInfo.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class PageInfo {
  final int totalResults;
  final int resultsPerPage;

  PageInfo({
    required this.totalResults,
    required this.resultsPerPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      totalResults: json['totalResults'] as int,
      resultsPerPage: json['resultsPerPage'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalResults': totalResults,
      'resultsPerPage': resultsPerPage,
    };
  }
}

class SearchResultItem {
  final String kind;
  final String etag;
  final VideoId id;
  final Snippet snippet;

  SearchResultItem({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet,
  });

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem(
      kind: json['kind'] as String,
      etag: json['etag'] as String,
      id: VideoId.fromJson(json['id'] as Map<String, dynamic>),
      snippet: Snippet.fromJson(json['snippet'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'etag': etag,
      'id': id.toJson(),
      'snippet': snippet.toJson(),
    };
  }
}

class VideoId {
  final String kind;
  final String videoId;

  VideoId({
    required this.kind,
    required this.videoId,
  });

  factory VideoId.fromJson(Map<String, dynamic> json) {
    return VideoId(
      kind: json['kind'] as String,
      videoId: json['videoId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'videoId': videoId,
    };
  }
}

class Snippet {
  final String publishedAt;
  final String channelId;
  final String title;
  final String description;
  final Thumbnails thumbnails;
  final String channelTitle;
  final String liveBroadcastContent;
  final String publishTime;

  Snippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.liveBroadcastContent,
    required this.publishTime,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) {
    return Snippet(
      publishedAt: json['publishedAt'] as String,
      channelId: json['channelId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnails: Thumbnails.fromJson(json['thumbnails'] as Map<String, dynamic>),
      channelTitle: json['channelTitle'] as String,
      liveBroadcastContent: json['liveBroadcastContent'] as String,
      publishTime: json['publishTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publishedAt': publishedAt,
      'channelId': channelId,
      'title': title,
      'description': description,
      'thumbnails': thumbnails.toJson(),
      'channelTitle': channelTitle,
      'liveBroadcastContent': liveBroadcastContent,
      'publishTime': publishTime,
    };
  }
}

class Thumbnails {
  final ThumbnailDetail defaultThumbnail;
  final ThumbnailDetail medium;
  final ThumbnailDetail high;

  Thumbnails({
    required this.defaultThumbnail,
    required this.medium,
    required this.high,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return Thumbnails(
      defaultThumbnail: ThumbnailDetail.fromJson(json['default'] as Map<String, dynamic>),
      medium: ThumbnailDetail.fromJson(json['medium'] as Map<String, dynamic>),
      high: ThumbnailDetail.fromJson(json['high'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'default': defaultThumbnail.toJson(),
      'medium': medium.toJson(),
      'high': high.toJson(),
    };
  }
}

class ThumbnailDetail {
  final String url;
  final int width;
  final int height;

  ThumbnailDetail({
    required this.url,
    required this.width,
    required this.height,
  });

  factory ThumbnailDetail.fromJson(Map<String, dynamic> json) {
    return ThumbnailDetail(
      url: json['url'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'width': width,
      'height': height,
    };
  }
}
