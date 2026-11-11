import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/app_models.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/social_platform_icon.dart';

enum SchedulePostAction { details, edit, delete }

class SchedulePostTile extends StatelessWidget {
  const SchedulePostTile({
    super.key,
    required this.post,
    required this.onTap,
    required this.onMenuAction,
  });

  final SocialPost post;
  final VoidCallback onTap;
  final ValueChanged<SchedulePostAction> onMenuAction;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: ValueKey('schedule-post-${post.id}'),
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 54,
                height: 54,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: post.imageBytes == null
                      ? Image.asset(
                          'assets/img/Violet orbits artwork.png',
                          fit: BoxFit.cover,
                        )
                      : Image.memory(post.imageBytes!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        for (final platform in post.targetPlatforms) ...[
                          SocialPlatformIcon(platform: platform, size: 13),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            post.targetPlatforms.join(' · '),
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            post.status.label,
                            style: const TextStyle(
                              color: AppColors.teal,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      post.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('HH.mm', 'id_ID').format(post.scheduledAt),
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<SchedulePostAction>(
                key: ValueKey('post-options-${post.id}'),
                tooltip: 'Opsi postingan',
                onSelected: onMenuAction,
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.muted,
                  size: 19,
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: SchedulePostAction.details,
                    child: Text('Lihat detail postingan'),
                  ),
                  PopupMenuItem(
                    value: SchedulePostAction.edit,
                    child: Text('Edit postingan'),
                  ),
                  PopupMenuItem(
                    value: SchedulePostAction.delete,
                    child: Text('Hapus postingan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
