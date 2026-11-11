import 'package:flutter/foundation.dart';

import '../models/app_models.dart';

class AppController extends ChangeNotifier {
  AppController() {
    _posts = [
      SocialPost(
        id: 'post-oct-27',
        caption: 'Orbit ungu. Kilau mint. ✦ Sambut ide-ide segar.',
        platform: 'Instagram',
        scheduledAt: DateTime.now().add(const Duration(days: 1)),
        status: PostStatus.scheduled,
        format: 'Gambar 1:1',
      ),
      SocialPost(
        id: 'post-oct-28',
        caption: 'Sedikit warna untuk menyemarakkan tengah pekanmu.',
        platform: 'Instagram',
        scheduledAt: DateTime(2026, 10, 23, 12, 30),
        status: PostStatus.published,
        format: 'Karosel',
      ),
      SocialPost(
        id: 'post-oct-30',
        caption: 'Ide sederhana bisa membawa perubahan besar.',
        platform: 'Facebook',
        scheduledAt: DateTime.now().add(const Duration(days: 3)),
        status: PostStatus.scheduled,
        format: 'Gambar 1:1',
      ),
    ];
    _comments = [
      SocialComment(
        id: 'comment-1',
        author: 'Maya Putri',
        handle: '@mayaputri',
        message: 'Bisa berbagi tutorial santai untuk desain ini?',
        postTitle: 'Orbit ungu. Kilau mint. ✦',
        sentiment: CommentSentiment.question,
        receivedAt: DateTime(2026, 10, 31, 10, 15),
        isPriority: true,
      ),
      SocialComment(
        id: 'comment-2',
        author: 'Dita S.',
        handle: '@ditastudio',
        message: 'Warnanya indah! Aku suka sekali ✨',
        postTitle: 'Sambut ide-ide segar',
        sentiment: CommentSentiment.positive,
        receivedAt: DateTime(2026, 10, 31, 9, 40),
      ),
      SocialComment(
        id: 'comment-3',
        author: 'Andi K.',
        handle: '@andikreatif',
        message: 'Biasanya pukul berapa kamu mengunggah karya baru?',
        postTitle: 'Sedikit warna untuk pekanmu',
        sentiment: CommentSentiment.question,
        receivedAt: DateTime(2026, 10, 30, 18, 20),
      ),
      SocialComment(
        id: 'comment-4',
        author: 'Studio North',
        handle: '@studionorth',
        message: 'Bukan gayaku, tetapi usahanya terlihat.',
        postTitle: 'Orbit ungu. Kilau mint. ✦',
        sentiment: CommentSentiment.negative,
        receivedAt: DateTime(2026, 10, 30, 16, 5),
      ),
      SocialComment(
        id: 'comment-5',
        author: 'promo_daily',
        handle: '@promo_daily',
        message: 'Dapatkan ribuan pengikut hari ini! Klik bio kami.',
        postTitle: 'Sambut ide-ide segar',
        sentiment: CommentSentiment.spam,
        receivedAt: DateTime(2026, 10, 30, 14),
      ),
    ];
  }

  late List<SocialPost> _posts;
  late List<SocialComment> _comments;
  String brandName = 'Zahira Studio';
  String brandIndustry = 'Belum dipilih';
  Uint8List? brandImageBytes;

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
    brandName = value.trim().isEmpty ? 'Merek Anda' : value.trim();
    notifyListeners();
  }

  void updateBrandProfile({
    required String name,
    required String industry,
    Uint8List? imageBytes,
  }) {
    brandName = name.trim();
    brandIndustry = industry;
    brandImageBytes = imageBytes;
    notifyListeners();
  }

  SocialPost addPost({
    required String caption,
    required String platform,
    List<String>? platforms,
    required DateTime scheduledAt,
    required String format,
    Uint8List? imageBytes,
    String? imageName,
    PostStatus status = PostStatus.scheduled,
  }) {
    final post = SocialPost(
      id: 'post-${DateTime.now().microsecondsSinceEpoch}',
      caption: caption,
      platform: platforms?.first ?? platform,
      platforms: platforms ?? [platform],
      scheduledAt: scheduledAt,
      status: status,
      format: format,
      imageBytes: imageBytes,
      imageName: imageName,
    );
    _posts.add(post);
    notifyListeners();
    return post;
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
