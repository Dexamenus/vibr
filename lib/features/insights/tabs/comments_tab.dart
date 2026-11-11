import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../shared/widgets/selectable_pill.dart';
import '../insights_demo_data.dart';
import '../insights_models.dart';
import '../widgets/insight_bottom_sheets.dart';

class CommentsTab extends StatefulWidget {
  final List<InsightsComment>? initialComments;
  const CommentsTab({super.key, this.initialComments});

  @override
  State<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  late List<InsightsComment> _comments;
  final Map<String, String> _replies = {};
  String? _commentPlatform;
  String _commentFilter = 'All';

  @override
  void initState() {
    super.initState();
    _comments = [...(widget.initialComments ?? InsightsDemoData.comments)];
  }

  Future<void> _showCommentFilter() async {
    final platform = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) =>
          CommentPlatformSheet(initialPlatform: _commentPlatform),
    );
    if (platform != null && mounted) {
      setState(() => _commentPlatform = platform == 'All' ? null : platform);
    }
  }

  void _toggleResolved(InsightsComment comment) {
    setState(() {
      final index = _comments.indexWhere((item) => item.id == comment.id);
      _comments[index] = comment.copyWith(isResolved: !comment.isResolved);
    });
  }

  Future<void> _showReplyDialog(InsightsComment comment) async {
    final controller = TextEditingController();
    final reply = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surfaceRaised,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          title: Text(
            'Reply to ${comment.handle}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Postingan asal · Instagram',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                      const SizedBox(height: 5),
                      Text(comment.postTitle),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  minLines: 3,
                  onChanged: (_) => setDialogState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Write a reply...',
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
            SizedBox(
              width: 142,
              child: PrimaryButton(
                label: 'Send reply',
                icon: Icons.send_rounded,
                onPressed: controller.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, controller.text.trim()),
              ),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (reply != null && mounted) {
      setState(() => _replies[comment.id] = reply);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reply sent in demo mode')));
    }
  }

  int _countFor(InsightsSentiment sentiment) => _comments
      .where(
        (comment) =>
            comment.sentiment == sentiment &&
            (_commentPlatform == null || comment.platform == _commentPlatform),
      )
      .length;

  @override
  Widget build(BuildContext context) {
    final visibleComments = _comments.where((comment) {
      final sentimentMatches = switch (_commentFilter) {
        'Positive' => comment.sentiment == InsightsSentiment.positive,
        'Questions' => comment.sentiment == InsightsSentiment.question,
        'Negative' => comment.sentiment == InsightsSentiment.negative,
        _ => true,
      };
      return sentimentMatches &&
          (_commentPlatform == null || comment.platform == _commentPlatform);
    }).toList();
    final count = _comments
        .where(
          (comment) =>
              _commentPlatform == null || comment.platform == _commentPlatform,
        )
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        SectionHeading(
          title: 'Komentar Hari Ini',
          padding: const EdgeInsets.only(bottom: 16),
          trailing: FilterButton(onTap: _showCommentFilter),
        ),
        Wrap(
          spacing: 7,
          runSpacing: 0,
          children: [
            _CommentFilterChip(
              label: 'Semua',
              count: count,
              selected: _commentFilter == 'All',
              onTap: () => setState(() => _commentFilter = 'All'),
            ),
            _CommentFilterChip(
              label: 'Positif',
              count: _countFor(InsightsSentiment.positive),
              selected: _commentFilter == 'Positive',
              onTap: () => setState(() => _commentFilter = 'Positive'),
            ),
            _CommentFilterChip(
              label: 'Pertanyaan',
              count: _countFor(InsightsSentiment.question),
              selected: _commentFilter == 'Questions',
              onTap: () => setState(() => _commentFilter = 'Questions'),
            ),
            _CommentFilterChip(
              label: 'Negatif',
              count: _countFor(InsightsSentiment.negative),
              selected: _commentFilter == 'Negative',
              onTap: () => setState(() => _commentFilter = 'Negative'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (visibleComments.isEmpty)
          const _EmptyComments()
        else ...[
          SectionHeading(
            title: 'Komentar terbaru',
            actionLabel:
                'Menampilkan ${visibleComments.length < 3 ? visibleComments.length : 3} dari $count',
            padding: const EdgeInsets.only(top: 2, bottom: 10),
          ),
          for (final comment in visibleComments.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _CommentCard(
                comment: comment,
                reply: _replies[comment.id],
                onToggleResolved: () => _toggleResolved(comment),
                onReply: () => _showReplyDialog(comment),
              ),
            ),
        ],
      ],
    );
  }
}

class _CommentFilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _CommentFilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SelectablePill(
      label: label,
      count: count,
      selected: selected,
      onTap: onTap,
    );
  }
}

class _EmptyComments extends StatelessWidget {
  const _EmptyComments();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: const [
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.accent,
            size: 30,
          ),
          SizedBox(height: 12),
          Text(
            'Semua komentar sudah diperiksa',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          Text(
            'Komentar baru akan muncul di sini.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final InsightsComment comment;
  final String? reply;
  final VoidCallback onToggleResolved;
  final VoidCallback onReply;

  const _CommentCard({
    required this.comment,
    this.reply,
    required this.onToggleResolved,
    required this.onReply,
  });

  Widget _tag(String label, Color color) {
    final background = label.startsWith('AI')
        ? AppColors.accentSoft
        : color.withValues(alpha: 0.12);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 10, height: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: comment.initials == 'AS'
                    ? const Color(0xFF3B2028)
                    : AppColors.surfaceRaised,
                child: Text(
                  comment.initials,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.handle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          comment.platform == 'Instagram'
                              ? Icons.camera_alt_outlined
                              : Icons.facebook_rounded,
                          size: 12,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          comment.platform,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.camera_alt_outlined,
                size: 13,
                color: AppColors.muted,
              ),
              const SizedBox(width: 4),
              Text(
                comment.timeLabel,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.message,
            style: const TextStyle(fontSize: 14, height: 1.55),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 5,
            children: [
              _tag(comment.sentimentLabel, comment.sentimentColor),
              // _tag(comment.aiLabel, const Color(0xFFBBA3FF)),
            ],
          ),
          if (reply != null) ...[
            const SizedBox(height: 9),
            Text(
              'You replied: $reply',
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onToggleResolved,
                  child: Row(
                    children: [
                      Icon(
                        comment.isResolved
                            ? Icons.check_circle_outline_rounded
                            : Icons.check_rounded,
                        size: 15,
                        color: comment.isResolved
                            ? AppColors.teal
                            : AppColors.muted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        comment.isResolved ? 'Resolved' : 'Mark as resolved',
                        style: TextStyle(
                          color: comment.isResolved
                              ? AppColors.teal
                              : AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: onReply,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  reply == null ? 'Reply' : 'Reply again',
                  style: const TextStyle(
                    color: Color(0xFFBBA3FF),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
