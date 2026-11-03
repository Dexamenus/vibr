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
    this.format = 'Image',
  });

  final String id;
  final String caption;
  final String platform;
  final DateTime scheduledAt;
  final PostStatus status;
  final String format;

  SocialPost copyWith({
    String? caption,
    String? platform,
    DateTime? scheduledAt,
    PostStatus? status,
    String? format,
  }) {
    return SocialPost(
      id: id,
      caption: caption ?? this.caption,
      platform: platform ?? this.platform,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      format: format ?? this.format,
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
    PostStatus.scheduled => 'Scheduled',
    PostStatus.published => 'Published',
    PostStatus.draft => 'Draft',
  };

  Color get color => switch (this) {
    PostStatus.scheduled => const Color(0xFF61A7FF),
    PostStatus.published => const Color(0xFF20D6B0),
    PostStatus.draft => const Color(0xFFFFC45C),
  };
}

extension CommentSentimentLabel on CommentSentiment {
  String get label => switch (this) {
    CommentSentiment.positive => 'Positive',
    CommentSentiment.question => 'Question',
    CommentSentiment.negative => 'Negative',
    CommentSentiment.spam => 'Spam',
  };
}
