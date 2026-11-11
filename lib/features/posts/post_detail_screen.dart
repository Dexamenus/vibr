import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/app_models.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/social_platform_icon.dart';
import '../../shared/widgets/show_demo_message.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.post});

  final SocialPost post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Kembali',
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Detail Postingan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final platform in post.targetPlatforms) ...[
                    SocialPlatformIcon(platform: platform, size: 15),
                    const SizedBox(width: 5),
                  ],
                  Expanded(
                    child: Text(
                      '${post.targetPlatforms.join(' · ')} · ${post.format}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: post.status.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.status.label,
                      style: TextStyle(
                        color: post.status.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat(
                  'd MMMM yyyy · HH.mm',
                  'id_ID',
                ).format(post.scheduledAt),
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
              const SizedBox(height: 16),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: post.imageBytes == null
                      ? Image.asset(
                          'assets/img/Violet orbits artwork.png',
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          post.imageBytes!,
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                post.caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Performa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    'Analitik demo',
                    style: TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    child: _MetricTile(value: '312', label: 'Suka'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _MetricTile(value: '28', label: 'Komentar'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _MetricTile(value: '42', label: 'Dibagikan'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Contoh analitik · Bukan data langsung dari platform',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 10),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Lihat komentar · 28',
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: () =>
                    showDemoMessage(context, 'Fitur komentar segera hadir.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
