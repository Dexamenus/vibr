import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/app_models.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/status_pill.dart';
import '../../shared/widgets/surface_card.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onDelete,
  });

  final SocialPost post;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'EEE, d MMM yyyy • HH.mm',
      'id_ID',
    ).format(post.scheduledAt);

    return SurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    post.platform == 'Instagram'
                        ? Icons.camera_alt_outlined
                        : Icons.facebook_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    post.platform,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  StatusPill(status: post.status),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: AppColors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  post.format,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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
