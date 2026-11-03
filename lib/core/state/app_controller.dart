import 'package:flutter/foundation.dart';

import '../models/app_models.dart';

class AppController extends ChangeNotifier {
  AppController() {
    _posts = [
      SocialPost(
        id: 'post-oct-27',
        caption: 'Violet orbits. A mint spark. ✦ Make room for fresh ideas.',
        platform: 'Instagram',
        scheduledAt: DateTime(2026, 10, 31, 9),
        status: PostStatus.scheduled,
        format: '1:1 image',
      ),
      SocialPost(
        id: 'post-oct-28',
        caption: 'A little color for the middle of your week.',
        platform: 'Instagram',
        scheduledAt: DateTime(2026, 10, 23, 12, 30),
        status: PostStatus.published,
        format: 'Carousel',
      ),
      SocialPost(
        id: 'post-oct-30',
        caption: 'Small ideas can make a big difference.',
        platform: 'Facebook',
        scheduledAt: DateTime(2026, 11, 2, 16),
        status: PostStatus.scheduled,
        format: '1:1 image',
      ),
    ];
    _comments = [
      SocialComment(
        id: 'comment-1',
        author: 'Maya Putri',
        handle: '@mayaputri',
        message: 'Could you share a casual tutorial for this design?',
        postTitle: 'Violet orbits. A mint spark. ✦',
        sentiment: CommentSentiment.question,
        receivedAt: DateTime(2026, 10, 31, 10, 15),
        isPriority: true,
      ),
      SocialComment(
        id: 'comment-2',
        author: 'Dita S.',
        handle: '@ditastudio',
        message: 'The colors are beautiful! Love this so much ✨',
        postTitle: 'Make room for fresh ideas',
        sentiment: CommentSentiment.positive,
        receivedAt: DateTime(2026, 10, 31, 9, 40),
      ),
      SocialComment(
        id: 'comment-3',
        author: 'Andi K.',
        handle: '@andikreatif',
        message: 'What time do you usually post your new work?',
        postTitle: 'A little color for your week',
        sentiment: CommentSentiment.question,
        receivedAt: DateTime(2026, 10, 30, 18, 20),
      ),
      SocialComment(
        id: 'comment-4',
        author: 'Studio North',
        handle: '@studionorth',
        message: 'Not my style, but the effort is clear.',
        postTitle: 'Violet orbits. A mint spark. ✦',
        sentiment: CommentSentiment.negative,
        receivedAt: DateTime(2026, 10, 30, 16, 5),
      ),
      SocialComment(
        id: 'comment-5',
        author: 'promo_daily',
        handle: '@promo_daily',
        message: 'Get thousands of followers today! Click our bio.',
        postTitle: 'Make room for fresh ideas',
        sentiment: CommentSentiment.spam,
        receivedAt: DateTime(2026, 10, 30, 14),
      ),
    ];
  }

  late List<SocialPost> _posts;
  late List<SocialComment> _comments;
  String brandName = 'Zahira Studio';

  List<SocialPost> get posts {
    final result = [..._posts]
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return List.unmodifiable(result);
  }

  List<SocialComment> get comments => List.unmodifiable(_comments);

  List<SocialPost> postsOn(DateTime day) => posts
      .where(
        (post) =>
            post.scheduledAt.year == day.year &&
            post.scheduledAt.month == day.month &&
            post.scheduledAt.day == day.day,
      )
      .toList();

  List<SocialComment> commentsFor(CommentSentiment? sentiment) =>
      _comments.where((comment) {
        return !comment.isResolved &&
            (sentiment == null || comment.sentiment == sentiment);
      }).toList()..sort((a, b) {
        if (a.isPriority != b.isPriority) return a.isPriority ? -1 : 1;
        return b.receivedAt.compareTo(a.receivedAt);
      });

  void updateBrandName(String value) {
    brandName = value.trim().isEmpty ? 'Your brand' : value.trim();
    notifyListeners();
  }

  void addPost({
    required String caption,
    required String platform,
    required DateTime scheduledAt,
    required String format,
    PostStatus status = PostStatus.scheduled,
  }) {
    _posts.add(
      SocialPost(
        id: 'post-${DateTime.now().microsecondsSinceEpoch}',
        caption: caption,
        platform: platform,
        scheduledAt: scheduledAt,
        status: status,
        format: format,
      ),
    );
    notifyListeners();
  }

  void deletePost(String id) {
    _posts.removeWhere((post) => post.id == id);
    notifyListeners();
  }

  void updatePost(SocialPost updated) {
    final index = _posts.indexWhere((post) => post.id == updated.id);
    if (index == -1) return;
    _posts[index] = updated;
    notifyListeners();
  }

  void resolveComment(String id) {
    _comments = [
      for (final comment in _comments)
        if (comment.id == id) comment.copyWith(isResolved: true) else comment,
    ];
    notifyListeners();
  }
}
