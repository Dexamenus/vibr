import 'package:flutter/material.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_widgets.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  final AppController controller;
  final bool embedded;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  CommentSentiment? _filter;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ScreenHeader(
          title: 'Comments',
          leading: widget.embedded
              ? null
              : IconButton(
                  tooltip: 'Back to dashboard',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                ),
          trailing: AppIconButton(
            icon: Icons.tune_rounded,
            tooltip: 'Comment filters',
            onPressed: () => _showFilters(context),
          ),
          padding: const EdgeInsets.only(bottom: 13),
        ),
        const Row(
          children: [
            Expanded(
              child: Text(
                'Oct 20–26, 2026',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
            Text('Demo inbox', style: TextStyle(color: AppColors.muted)),
          ],
        ),
        const SizedBox(height: 15),
        AnimatedBuilder(
          animation: widget.controller,
          builder: (context, _) {
            final open = widget.controller.comments
                .where((comment) => !comment.isResolved)
                .toList();
            final counts = {
              null: open.length,
              for (final sentiment in CommentSentiment.values)
                sentiment: open
                    .where((comment) => comment.sentiment == sentiment)
                    .length,
            };
            return Wrap(
              spacing: 7,
              runSpacing: 0,
              children: [
                SelectablePill(
                  label: 'All',
                  count: counts[null],
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                for (final sentiment in CommentSentiment.values)
                  SelectablePill(
                    label: sentiment.label,
                    count: counts[sentiment],
                    selected: _filter == sentiment,
                    onTap: () => setState(() => _filter = sentiment),
                  ),
              ],
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 17),
          child: Text(
            'Questions and spam are separate inbox categories.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ),
        AnimatedBuilder(
          animation: widget.controller,
          builder: (context, _) {
            final comments = widget.controller.commentsFor(_filter);
            if (comments.isEmpty) {
              return const EmptyState(
                icon: Icons.mark_chat_read_outlined,
                title: 'You are all caught up',
                message: 'New comments will show up here.',
              );
            }
            final priority = comments
                .where((comment) => comment.isPriority)
                .toList();
            final others = comments
                .where((comment) => !comment.isPriority)
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (priority.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.push_pin_outlined,
                        size: 18,
                        color: AppColors.amber,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Priority',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _CountBadge(
                        count: '${priority.length} needs response',
                        color: AppColors.amber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 11),
                  for (final comment in priority) ...[
                    _CommentCard(
                      comment: comment,
                      onReply: () => _reply(context, comment),
                      onResolve: () =>
                          widget.controller.resolveComment(comment.id),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 12),
                ],
                if (others.isNotEmpty) ...[
                  const SectionHeading(title: 'Recent comments'),
                  for (final comment in others) ...[
                    _CommentCard(
                      comment: comment,
                      onReply: () => _reply(context, comment),
                      onResolve: () =>
                          widget.controller.resolveComment(comment.id),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ],
            );
          },
        ),
      ],
    );
    if (widget.embedded) return content;
    return AppPage(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      child: content,
    );
  }

  Future<void> _reply(BuildContext context, SocialComment comment) async {
    final controller = TextEditingController();
    final reply = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reply to ${comment.author}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Write a reply...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Send reply'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reply == null || reply.isEmpty || !context.mounted) return;
    showDemoMessage(
      context,
      'Demo only: this reply was not sent to Instagram.',
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Filter comments',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              for (final sentiment in [null, ...CommentSentiment.values])
                ListTile(
                  title: Text(sentiment?.label ?? 'All comments'),
                  trailing: _filter == sentiment
                      ? const Icon(Icons.check, color: AppColors.accent)
                      : null,
                  onTap: () {
                    setState(() => _filter = sentiment);
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({
    required this.comment,
    required this.onReply,
    required this.onResolve,
  });

  final SocialComment comment;
  final VoidCallback onReply;
  final VoidCallback onResolve;

  @override
  Widget build(BuildContext context) {
    final sentimentColor = switch (comment.sentiment) {
      CommentSentiment.positive => AppColors.teal,
      CommentSentiment.question => const Color(0xFF76B5FF),
      CommentSentiment.negative => AppColors.amber,
      CommentSentiment.spam => AppColors.red,
    };
    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surfaceRaised,
                child: Text(
                  comment.author.characters.first.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.author,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      comment.handle,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SocialPlatformIcon(platform: 'Instagram', size: 17),
              const SizedBox(width: 7),
              Text(
                _timeAgo(comment.receivedAt),
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(comment.message, style: const TextStyle(height: 1.4)),
          const SizedBox(height: 9),
          Text(
            'On: ${comment.postTitle}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _CountBadge(
                count: comment.sentiment.label,
                color: sentimentColor,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onReply,
                icon: const Icon(Icons.reply_rounded, size: 17),
                label: const Text('Reply'),
              ),
              IconButton(
                tooltip: 'Mark as done',
                onPressed: onResolve,
                icon: const Icon(Icons.check_circle_outline, size: 19),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.color});

  final String count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          count,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

String _timeAgo(DateTime date) {
  final difference = DateTime.now().difference(date);
  if (difference.isNegative) return 'just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';
  return '${difference.inDays}d ago';
}
