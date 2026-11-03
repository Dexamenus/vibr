import 'package:flutter/material.dart';

import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_page.dart';
import '../../shared/widgets/screen_header.dart';
import '../../shared/widgets/secondary_button.dart';
import '../../shared/widgets/section_heading.dart';
import '../../shared/widgets/show_demo_message.dart';
import '../../shared/widgets/surface_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.controller,
    required this.onSignOut,
  });

  final AppController controller;
  final VoidCallback onSignOut;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _llmModel = 'GPT-4o mini';
  String _imageModel = 'FLUX Schnell';
  String _tone = 'Casual · Illustration';
  String _theme = 'Dark';
  Color _accentColor = AppColors.accent;
  bool _postNotifications = true;
  bool _commentAlerts = true;
  final bool _instagramConnected = true;
  final bool _facebookConnected = true;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenHeader(title: 'Profile'),
          SurfaceCard(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.surfaceRaised,
                  child: Text(
                    'ZN',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.controller.brandName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'zahira@example.com',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _editProfile,
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: AppColors.accent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          const SectionHeading(title: 'AI Configuration'),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              children: [
                _SettingsRow(
                  icon: Icons.smart_toy_outlined,
                  label: 'LLM Model',
                  value: _llmModel,
                  onTap: () => _choose(
                    title: 'Language model',
                    choices: ['GPT-4o mini', 'GPT-4.1', 'Claude Sonnet'],
                    onSelected: (value) => setState(() => _llmModel = value),
                  ),
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.image_outlined,
                  label: 'Image Model',
                  value: _imageModel,
                  onTap: () => _choose(
                    title: 'Image model',
                    choices: ['FLUX Schnell', 'FLUX Pro', 'DALL·E'],
                    onSelected: (value) => setState(() => _imageModel = value),
                  ),
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.tune_rounded,
                  label: 'Default tone & style',
                  value: _tone,
                  onTap: () => _choose(
                    title: 'Default tone & style',
                    choices: [
                      'Casual · Illustration',
                      'Professional · Minimal',
                      'Playful · Vibrant',
                      'Luxury · Photorealistic',
                    ],
                    onSelected: (value) => setState(() => _tone = value),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeading(title: 'Knowledge Base (RAG)'),
          SurfaceCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Brand voice guide',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'No document uploaded',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => showDemoMessage(
                        context,
                        'File upload requires a connected storage service.',
                      ),
                      child: const Text('Manage'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  label: 'Add a brand document',
                  icon: Icons.add,
                  onPressed: () => showDemoMessage(
                    context,
                    'File upload requires a connected storage service.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeading(title: 'Connected Accounts'),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              children: [
                _ConnectedAccountRow(
                  icon: Icons.camera_alt_outlined,
                  name: 'Instagram',
                  connected: _instagramConnected,
                  onPressed: () => _showConnectionInfo('Instagram'),
                ),
                const Divider(height: 1),
                _ConnectedAccountRow(
                  icon: Icons.facebook_rounded,
                  name: 'Facebook Page',
                  connected: _facebookConnected,
                  onPressed: () => _showConnectionInfo('Facebook'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const SectionHeading(title: 'Appearance'),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.dark_mode_outlined,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('Theme', style: TextStyle(fontSize: 14)),
                      ),
                      for (final theme in ['Dark', 'Light', 'System'])
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ChoiceChip(
                            label: Text(theme),
                            selected: _theme == theme,
                            onSelected: (_) => setState(() => _theme = theme),
                            showCheckmark: false,
                            visualDensity: VisualDensity.compact,
                            labelStyle: TextStyle(
                              color: _theme == theme
                                  ? const Color(0xFFD8CCFF)
                                  : AppColors.muted,
                              fontSize: 12,
                            ),
                            side: BorderSide(
                              color: _theme == theme
                                  ? AppColors.accent
                                  : AppColors.border,
                            ),
                            backgroundColor: AppColors.surface,
                            selectedColor: AppColors.accentSoft,
                            shape: const StadiumBorder(),
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.palette_outlined,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Accent color',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      for (final color in [
                        AppColors.accent,
                        const Color(0xFF6D96D9),
                        AppColors.teal,
                        const Color(0xFFD487A2),
                      ])
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                            onTap: () => setState(() => _accentColor = color),
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _accentColor == color
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: _accentColor == color
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const SectionHeading(title: 'Notifications'),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              children: [
                _SettingsSwitch(
                  icon: Icons.notifications_none_rounded,
                  title: 'Publishing alerts',
                  value: _postNotifications,
                  onChanged: (value) =>
                      setState(() => _postNotifications = value),
                ),
                const Divider(height: 1),
                _SettingsSwitch(
                  icon: Icons.chat_bubble_outline,
                  title: 'Comment alerts',
                  value: _commentAlerts,
                  onChanged: (value) => setState(() => _commentAlerts = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const SectionHeading(title: 'Account'),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
            child: Column(
              children: [
                _SettingsRow(
                  icon: Icons.credit_card_outlined,
                  label: 'Subscription plan',
                  value: 'Pro · Monthly',
                  onTap: () => _showInfo(
                    'Subscription plan',
                    'You are viewing the sample Pro plan. Billing is not connected in this demo.',
                  ),
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () => _showInfo(
                    'Help & Support',
                    'Contact support when an account service is connected.',
                  ),
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () => _showInfo(
                    'Privacy Policy',
                    'This demo stores sample settings and content in memory on this device. No account or social data is sent to a service.',
                  ),
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  onTap: widget.onSignOut,
                  iconColor: AppColors.red,
                  labelColor: AppColors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _choose({
    required String title,
    required List<String> choices,
    required ValueChanged<String> onSelected,
  }) async {
    final selected = await showModalBottomSheet<String>(
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
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              for (final choice in choices)
                ListTile(
                  title: Text(choice),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pop(choice),
                ),
            ],
          ),
        ),
      ),
    );
    if (selected != null && mounted) onSelected(selected);
  }

  Future<void> _editProfile() async {
    final name = TextEditingController(text: widget.controller.brandName);
    final updatedName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit profile'),
        content: TextField(
          controller: name,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Display name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(name.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    name.dispose();
    if (updatedName == null || updatedName.isEmpty || !mounted) return;
    widget.controller.updateBrandName(updatedName);
  }

  void _showInfo(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showConnectionInfo(String platform) {
    showDemoMessage(
      context,
      '$platform account linking requires an OAuth provider. No account was changed.',
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.iconColor = AppColors.muted,
    this.labelColor = Colors.white,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor),
      title: Text(label, style: TextStyle(fontSize: 14, color: labelColor)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value!,
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          if (onTap != null) ...[
            const SizedBox(width: 5),
            const Icon(Icons.chevron_right, color: AppColors.muted, size: 19),
          ],
        ],
      ),
    );
  }
}

class _ConnectedAccountRow extends StatelessWidget {
  const _ConnectedAccountRow({
    required this.icon,
    required this.name,
    required this.connected,
    required this.onPressed,
  });

  final IconData icon;
  final String name;
  final bool connected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.muted),
      title: Text(name, style: const TextStyle(fontSize: 14)),
      trailing: TextButton(
        onPressed: onPressed,
        child: Text(
          connected ? 'Demo linked' : 'Connect',
          style: TextStyle(
            color: connected ? AppColors.teal : AppColors.accent,
          ),
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      activeTrackColor: AppColors.accent,
      secondary: Icon(icon, color: AppColors.muted),
      title: Text(title, style: const TextStyle(fontSize: 14)),
    );
  }
}
