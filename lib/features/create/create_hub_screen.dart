import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_widgets.dart';

class CreateHubScreen extends StatelessWidget {
  const CreateHubScreen({
    super.key,
    required this.onClose,
    required this.onOpenPrompt,
  });

  final VoidCallback onClose;
  final ValueChanged<String> onOpenPrompt;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenHeader(
            title: 'Create',
            trailing: AppIconButton(
              icon: Icons.close,
              tooltip: 'Close',
              onPressed: onClose,
            ),
          ),
          Text(
            'What will you create today?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              SocialPlatformIcon(platform: 'Instagram'),
              SizedBox(width: 8),
              Text(
                'Instagram & Facebook',
                style: TextStyle(color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.96,
            children: [
              _CreationTypeCard(
                icon: Icons.auto_awesome,
                title: 'Generate Image + Caption',
                subtitle: 'A complete post, made for your brand.',
                color: AppColors.accentSoft,
                onTap: () => onOpenPrompt('Image + caption'),
              ),
              _CreationTypeCard(
                icon: Icons.text_fields_rounded,
                title: 'Caption only',
                subtitle: 'Find the words for your next post.',
                onTap: () => onOpenPrompt('Caption'),
              ),
              _CreationTypeCard(
                icon: Icons.image_outlined,
                title: 'Image only',
                subtitle: 'Create a visual for your feed.',
                onTap: () => onOpenPrompt('Image'),
              ),
              _CreationTypeCard(
                icon: Icons.dashboard_customize_outlined,
                title: 'Post templates',
                subtitle: 'Start with a ready-made idea.',
                onTap: () => _showTemplatePicker(context, onOpenPrompt),
              ),
            ],
          ),
          const SizedBox(height: 26),
          SectionHeading(
            title: 'Recent prompts',
            actionLabel: 'See all',
            onAction: () => onOpenPrompt('Image + caption'),
          ),
          for (final prompt in const [
            'A violet planet with a mint glow',
            'A calm Monday morning desk',
            'Three ways to find inspiration',
          ])
            _RecentPromptTile(
              prompt: prompt,
              onTap: () => onOpenPrompt('Image + caption'),
            ),
        ],
      ),
    );
  }
}

class _CreationTypeCard extends StatelessWidget {
  const _CreationTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color = AppColors.surface,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      onTap: onTap,
      color: color,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 25,
            color: color == AppColors.surface
                ? AppColors.muted
                : AppColors.accent,
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 5),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 17,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

class _RecentPromptTile extends StatelessWidget {
  const _RecentPromptTile({required this.prompt, required this.onTap});

  final String prompt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
      leading: const CircleAvatar(
        backgroundColor: AppColors.surfaceRaised,
        child: Icon(Icons.history, color: AppColors.muted, size: 19),
      ),
      title: Text(prompt, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: const Text('Instagram · Image + caption'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}

void _showTemplatePicker(
  BuildContext context,
  ValueChanged<String> onOpenPrompt,
) {
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
              'Choose a template',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            for (final title in [
              'Product spotlight',
              'Behind the scenes',
              'Weekly inspiration',
            ])
              ListTile(
                leading: const Icon(
                  Icons.auto_awesome_outlined,
                  color: AppColors.accent,
                ),
                title: Text(title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pop();
                  onOpenPrompt(title);
                },
              ),
          ],
        ),
      ),
    ),
  );
}
