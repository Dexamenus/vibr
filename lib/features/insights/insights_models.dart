import 'package:flutter/material.dart';

enum InsightsSentiment { positive, question, negative }

class InsightsComment {
  const InsightsComment({
    required this.id,
    required this.handle,
    required this.initials,
    required this.message,
    required this.postTitle,
    required this.platform,
    required this.timeLabel,
    required this.sentiment,
    required this.aiLabel,
    this.isResolved = false,
  });

  final String id;
  final String handle;
  final String initials;
  final String message;
  final String postTitle;
  final String platform;
  final String timeLabel;
  final InsightsSentiment sentiment;
  final String aiLabel;
  final bool isResolved;

  Color get sentimentColor => switch (sentiment) {
    InsightsSentiment.positive => const Color(0xFF00D6A5),
    InsightsSentiment.question => const Color(0xFFFFB648),
    InsightsSentiment.negative => const Color(0xFFFF5268),
  };

  String get sentimentLabel => switch (sentiment) {
    InsightsSentiment.positive => 'Positif',
    InsightsSentiment.question => 'Pertanyaan',
    InsightsSentiment.negative => 'Negatif',
  };

  InsightsComment copyWith({bool? isResolved}) => InsightsComment(
    id: id,
    handle: handle,
    initials: initials,
    message: message,
    postTitle: postTitle,
    platform: platform,
    timeLabel: timeLabel,
    sentiment: sentiment,
    aiLabel: aiLabel,
    isResolved: isResolved ?? this.isResolved,
  );
}

class AnalyticsMetric {
  const AnalyticsMetric({
    required this.title,
    required this.value,
    required this.description,
    required this.axisLabels,
    required this.points,
  });

  final String title;
  final String value;
  final String description;
  final List<String> axisLabels;
  final List<double> points;
}
