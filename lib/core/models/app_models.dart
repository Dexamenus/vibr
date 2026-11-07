import 'dart:typed_data';

import 'package:flutter/material.dart';

enum PostStatus { scheduled, published, draft }

enum CommentSentiment { positive, question, negative, spam }

class SocialPost {
  const SocialPost({
    required this.id,
    required this.caption,
    required this.platform,
    required this.scheduledAt,
    required this.status,
    this.platforms = const [],
    this.format = 'Gambar',
    this.imageBytes,
    this.imageName,
  });

  final String id;
  final String caption;
  final String platform;
  final List<String> platforms;
  final DateTime scheduledAt;
  final PostStatus status;
  final String format;
  final Uint8List? imageBytes;
  final String? imageName;

  List<String> get targetPlatforms =>
      platforms.isEmpty ? [platform] : platforms;

  SocialPost copyWith({
    String? caption,
    String? platform,
    List<String>? platforms,
    DateTime? scheduledAt,
    PostStatus? status,
    String? format,
    Uint8List? imageBytes,
    String? imageName,
  }) {
    final updatedPlatforms =
        platforms ?? (platform == null ? targetPlatforms : [platform]);
    return SocialPost(
      id: id,
      caption: caption ?? this.caption,
      platform: updatedPlatforms.first,
      platforms: updatedPlatforms,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      format: format ?? this.format,
      imageBytes: imageBytes ?? this.imageBytes,
      imageName: imageName ?? this.imageName,
    );
  }
}

class PostDraft {
  const PostDraft({
    required this.prompt,
    required this.caption,
    required this.platform,
    required this.tone,
    required this.style,
    required this.format,
  });

  final String prompt;
  final String caption;
  final String platform;
  final String tone;
  final String style;
  final String format;
}

class SocialComment {
  const SocialComment({
    required this.id,
    required this.author,
    required this.handle,
    required this.message,
    required this.postTitle,
    required this.sentiment,
    required this.receivedAt,
    this.isPriority = false,
    this.isResolved = false,
  });

  final String id;
  final String author;
  final String handle;
  final String message;
  final String postTitle;
  final CommentSentiment sentiment;
  final DateTime receivedAt;
  final bool isPriority;
  final bool isResolved;

  SocialComment copyWith({bool? isResolved}) {
    return SocialComment(
      id: id,
      author: author,
      handle: handle,
      message: message,
      postTitle: postTitle,
      sentiment: sentiment,
      receivedAt: receivedAt,
      isPriority: isPriority,
      isResolved: isResolved ?? this.isResolved,
    );
  }
}

extension PostStatusLabel on PostStatus {
  String get label => switch (this) {
    PostStatus.scheduled => 'Terjadwal',
    PostStatus.published => 'Dipublikasikan',
    PostStatus.draft => 'Draf',
  };

  Color get color => switch (this) {
    PostStatus.scheduled => const Color(0xFF61A7FF),
    PostStatus.published => const Color(0xFF20D6B0),
    PostStatus.draft => const Color(0xFFFFC45C),
  };
}

extension CommentSentimentLabel on CommentSentiment {
  String get label => switch (this) {
    CommentSentiment.positive => 'Positif',
    CommentSentiment.question => 'Pertanyaan',
    CommentSentiment.negative => 'Negatif',
    CommentSentiment.spam => 'Spam',
  };
}
