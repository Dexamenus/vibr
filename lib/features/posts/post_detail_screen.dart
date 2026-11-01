import 'package:flutter/material.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_widgets.dart';
import '../create/generated_result_screen.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({
    super.key,
    required this.controller,
    required this.post,
    required this.onChanged,
    required this.onOpenComments,
  });

  final AppController controller;
  final SocialPost post;
  final VoidCallback onChanged;
  final VoidCallback onOpenComments;

  @override
  Widget build(BuildContext context) {
    final date = post.scheduledAt;
    return Scaffold(
      body: AppPage(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Post Detail',
              leading: IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            Row(
              children: [
                SocialPlatformIcon(platform: post.platform),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${post.platform} · ${post.format}',
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ),
                StatusPill(status: post.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_monthLabel(date.month)} ${date.day}, ${date.year} · ${TimeOfDay.fromDateTime(date).format(context)}',
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 19),
            const GeneratedArtwork(height: 310, seed: 3),
            const SizedBox(height: 17),
            Text(
              post.caption,
              style: const TextStyle(fontSize: 15, height: 1.45),
            ),
            const SizedBox(height: 20),
            const SectionHeading(title: 'Performance'),
            const Row(
              children: [
                MetricCard(value: '312', label: 'Likes'),
                SizedBox(width: 9),
                MetricCard(value: '28', label: 'Comments'),
                SizedBox(width: 9),
                MetricCard(value: '42', label: 'Saves'),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                MetricCard(value: '4.8%', label: 'Engagement rate'),
                SizedBox(width: 9),
                MetricCard(value: '1.2K', label: 'Reach'),
              ],
            ),
            const SizedBox(height: 22),
            if (post.status == PostStatus.scheduled)
              PrimaryButton(
                label: 'Edit scheduled post',
                icon: Icons.edit_outlined,
                onPressed: () => _edit(context),
              )
            else
              PrimaryButton(
                label: 'View comments',
                icon: Icons.chat_bubble_outline,
                onPressed: () {
                  Navigator.of(context).pop();
                  onOpenComments();
                },
              ),
            const SizedBox(height: 10),
            if (post.status == PostStatus.scheduled)
              SecondaryButton(
                label: 'Cancel scheduled post',
                icon: Icons.delete_outline,
                onPressed: () => _confirmDelete(context),
              )
            else
              SecondaryButton(
                label: 'Create a similar post',
                icon: Icons.add,
                onPressed: () => showDemoMessage(
                  context,
                  'Open Create to make a new version of this post.',
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _edit(BuildContext context) {
    final draft = PostDraft(
      prompt: post.caption,
      caption: post.caption,
      platform: post.platform,
      tone: 'Casual',
      style: 'Illustration',
      format: post.format,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewPostScreen(
          controller: controller,
          draft: draft,
          existingPost: post,
          onScheduled: () {
            onChanged();
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this post?'),
        content: const Text(
          'This post will be removed from your local schedule.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep post'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel post'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    controller.deletePost(post.id);
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      const SnackBar(content: Text('Post removed from your schedule.')),
    );
    onChanged();
  }
}

String _monthLabel(int month) => const [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
][month - 1];
