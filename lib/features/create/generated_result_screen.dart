import 'package:flutter/material.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_widgets.dart';

class GeneratedResultScreen extends StatefulWidget {
  const GeneratedResultScreen({
    super.key,
    required this.draft,
    required this.controller,
    required this.onScheduled,
  });

  final PostDraft draft;
  final AppController controller;
  final VoidCallback onScheduled;

  @override
  State<GeneratedResultScreen> createState() => _GeneratedResultScreenState();
}

class _GeneratedResultScreenState extends State<GeneratedResultScreen> {
  late final TextEditingController _caption;
  final Set<String> _hashtags = {'#FreshIdeas', '#CreativeLife', '#SociAI'};

  @override
  void initState() {
    super.initState();
    _caption = TextEditingController(text: widget.draft.caption);
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPage(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Your creation',
              leading: IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              trailing: AppIconButton(
                icon: Icons.close,
                tooltip: 'Close',
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ),
            Row(
              children: [
                SocialPlatformIcon(platform: widget.draft.platform),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${widget.draft.platform} · ${widget.draft.format}',
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ),
                const _ReadyPill(),
              ],
            ),
            const SizedBox(height: 17),
            const GeneratedArtwork(height: 310, seed: 3),
            const SizedBox(height: 21),
            const Text(
              'Caption · Tap to edit',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 9),
            TextField(
              controller: _caption,
              minLines: 2,
              maxLines: 4,
              maxLength: 2200,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Write a caption for your post',
              ),
            ),
            const SizedBox(height: 17),
            const Text(
              'Hashtags',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in ['#FreshIdeas', '#CreativeLife', '#SociAI'])
                  SelectablePill(
                    label: tag,
                    selected: _hashtags.contains(tag),
                    onTap: () => setState(() {
                      if (!_hashtags.add(tag)) _hashtags.remove(tag);
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 13),
            const Text(
              'Demo preview · generated locally, not by an AI service.',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Schedule post',
                    icon: Icons.calendar_month_outlined,
                    onPressed: () => _openEditor(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SecondaryButton(
                    label: 'Post now',
                    icon: Icons.send_outlined,
                    onPressed: () => _openEditor(context, publishNow: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openEditor(BuildContext context, {bool publishNow = false}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewPostScreen(
          controller: widget.controller,
          draft: widget.draft,
          initialCaption: [
            _caption.text.trim(),
            if (_hashtags.isNotEmpty) _hashtags.join(' '),
          ].join('\n\n'),
          publishNow: publishNow,
          onScheduled: widget.onScheduled,
        ),
      ),
    );
  }
}

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({
    super.key,
    required this.controller,
    required this.draft,
    required this.onScheduled,
    this.existingPost,
    this.initialCaption,
    this.publishNow = false,
  });

  final AppController controller;
  final PostDraft draft;
  final VoidCallback onScheduled;
  final SocialPost? existingPost;
  final String? initialCaption;
  final bool publishNow;

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  late final TextEditingController _caption;
  late DateTime _date;
  late TimeOfDay _time;
  late String _platform;
  bool _autoSchedule = false;
  bool _notifyOnPublish = true;

  @override
  void initState() {
    super.initState();
    _caption = TextEditingController(
      text: widget.initialCaption ?? widget.draft.caption,
    );
    _date = widget.publishNow
        ? DateTime.now()
        : widget.existingPost?.scheduledAt ??
              DateTime.now().add(const Duration(days: 1));
    _time = widget.publishNow
        ? TimeOfDay.now()
        : widget.existingPost != null
        ? TimeOfDay.fromDateTime(widget.existingPost!.scheduledAt)
        : const TimeOfDay(hour: 9, minute: 0);
    _platform = widget.existingPost?.platform ?? widget.draft.platform;
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _save({required bool publishNow}) {
    final caption = _caption.text.trim();
    if (caption.isEmpty) {
      showDemoMessage(context, 'Add a caption before scheduling your post.');
      return;
    }
    final scheduledAt = publishNow
        ? DateTime.now()
        : DateTime(
            _date.year,
            _date.month,
            _date.day,
            _time.hour,
            _time.minute,
          );
    if (widget.existingPost case final existing?) {
      widget.controller.updatePost(
        existing.copyWith(
          caption: caption,
          platform: _platform,
          scheduledAt: scheduledAt,
          status: publishNow ? PostStatus.published : PostStatus.scheduled,
        ),
      );
    } else {
      widget.controller.addPost(
        caption: caption,
        platform: _platform,
        scheduledAt: scheduledAt,
        format: widget.draft.format,
        status: publishNow ? PostStatus.published : PostStatus.scheduled,
      );
    }
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
    widget.onScheduled();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          publishNow
              ? 'Demo post saved. Publishing is not connected.'
              : 'Post scheduled in your local calendar.',
        ),
      ),
    );
  }

  void _setAutoSchedule(bool value) {
    setState(() {
      _autoSchedule = value;
      if (value) {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        _date = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
        _time = const TimeOfDay(hour: 18, minute: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPage(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'New Post',
              trailing: AppIconButton(
                icon: Icons.close,
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: GeneratedArtwork(height: 96, seed: 3),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'From your creation',
                        style: TextStyle(color: AppColors.muted),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              label: 'Library',
                              icon: Icons.photo_library_outlined,
                              onPressed: () => showDemoMessage(
                                context,
                                'Image library is not connected.',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Caption · Tap to edit',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 9),
            TextField(
              controller: _caption,
              minLines: 3,
              maxLines: 5,
              maxLength: 2200,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Write a caption for your post',
              ),
            ),
            const SizedBox(height: 13),
            const Text(
              'Platforms',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final platform in ['Instagram', 'Facebook'])
                  SelectablePill(
                    label: platform,
                    selected: _platform == platform,
                    onTap: () => setState(() => _platform = platform),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Date & time',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: _dateLabel(_date),
                    icon: Icons.calendar_month_outlined,
                    onPressed: _selectDate,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: SecondaryButton(
                    label: _time.format(context),
                    icon: Icons.access_time,
                    onPressed: _selectTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              value: _autoSchedule,
              onChanged: _setAutoSchedule,
              contentPadding: EdgeInsets.zero,
              activeTrackColor: AppColors.accent,
              title: const Text('Suggest best time'),
              subtitle: const Text(
                'Use the most active time for your audience',
              ),
            ),
            SwitchListTile(
              value: _notifyOnPublish,
              onChanged: (value) => setState(() => _notifyOnPublish = value),
              contentPadding: EdgeInsets.zero,
              activeTrackColor: AppColors.accent,
              title: const Text('Notify me when it is published'),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Schedule it',
              icon: Icons.calendar_month_outlined,
              onPressed: () => _save(publishNow: false),
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: 'Post now',
              icon: Icons.send_outlined,
              onPressed: () => _save(publishNow: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadyPill extends StatelessWidget {
  const _ReadyPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          'Ready to edit',
          style: TextStyle(
            color: AppColors.teal,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

String _dateLabel(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
