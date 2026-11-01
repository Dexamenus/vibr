import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_widgets.dart';
import 'generated_result_screen.dart';

class PromptInputScreen extends StatefulWidget {
  const PromptInputScreen({
    super.key,
    required this.creationType,
    required this.controller,
    required this.onScheduled,
  });

  final String creationType;
  final AppController controller;
  final VoidCallback onScheduled;

  @override
  State<PromptInputScreen> createState() => _PromptInputScreenState();
}

class _PromptInputScreenState extends State<PromptInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prompt = TextEditingController();
  String _platform = 'Instagram';
  String _tone = 'Casual';
  String _style = 'Illustration';
  String _format = '1:1 square';

  @override
  void dispose() {
    _prompt.dispose();
    super.dispose();
  }

  void _generate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final prompt = _prompt.text.trim();
    final draft = PostDraft(
      prompt: prompt,
      caption: _captionFor(prompt, _tone),
      platform: _platform,
      tone: _tone,
      style: _style,
      format: _format,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GenerationLoadingScreen(
          draft: draft,
          controller: widget.controller,
          onScheduled: widget.onScheduled,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPage(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: 'Create with AI',
                leading: _BackButton(),
                trailing: AppIconButton(
                  icon: Icons.close,
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Row(
                children: [
                  const SocialPlatformIcon(platform: 'Instagram'),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.creationType} · Instagram & Facebook',
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ],
              ),
              const SizedBox(height: 23),
              TextFormField(
                controller: _prompt,
                minLines: 5,
                maxLines: 7,
                maxLength: 300,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Your prompt',
                  alignLabelWithHint: true,
                  hintText: 'Describe what you want to create...',
                  counterStyle: TextStyle(color: AppColors.muted),
                ),
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Describe your post idea first'
                    : null,
              ),
              const SizedBox(height: 19),
              const _OptionLabel('Mood'),
              Wrap(
                spacing: 7,
                runSpacing: 0,
                children: [
                  for (final tone in ['Casual', 'Professional', 'Playful'])
                    SelectablePill(
                      label: tone,
                      selected: _tone == tone,
                      onTap: () => setState(() => _tone = tone),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const _OptionLabel('Style'),
              Wrap(
                spacing: 7,
                runSpacing: 0,
                children: [
                  for (final style in [
                    'Illustration',
                    'Photorealistic',
                    'Minimal',
                    'Vibrant',
                  ])
                    SelectablePill(
                      label: style,
                      selected: _style == style,
                      onTap: () => setState(() => _style = style),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const _OptionLabel('Format'),
              Wrap(
                spacing: 7,
                children: [
                  for (final format in ['1:1 square', '4:5 portrait', 'Story'])
                    SelectablePill(
                      label: format,
                      selected: _format == format,
                      onTap: () => setState(() => _format = format),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const _OptionLabel('Platform'),
              Wrap(
                spacing: 7,
                children: [
                  for (final platform in ['Instagram', 'Facebook'])
                    SelectablePill(
                      label: platform,
                      selected: _platform == platform,
                      onTap: () => setState(() => _platform = platform),
                    ),
                ],
              ),
              const SizedBox(height: 13),
              SecondaryButton(
                label: 'Attach image / reference',
                icon: Icons.add_photo_alternate_outlined,
                onPressed: () => showDemoMessage(
                  context,
                  'Image upload will be available when storage is connected.',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Demo mode creates a local visual preview; no AI service is connected.',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Generate',
                icon: Icons.auto_awesome,
                onPressed: _generate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenerationLoadingScreen extends StatefulWidget {
  const GenerationLoadingScreen({
    super.key,
    required this.draft,
    required this.controller,
    required this.onScheduled,
  });

  final PostDraft draft;
  final AppController controller;
  final VoidCallback onScheduled;

  @override
  State<GenerationLoadingScreen> createState() =>
      _GenerationLoadingScreenState();
}

class _GenerationLoadingScreenState extends State<GenerationLoadingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => GeneratedResultScreen(
            draft: widget.draft,
            controller: widget.controller,
            onScheduled: widget.onScheduled,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPage(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Your creation',
              leading: _BackButton(),
              trailing: AppIconButton(
                icon: Icons.close,
                tooltip: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Row(
              children: [
                const SocialPlatformIcon(platform: 'Instagram'),
                const SizedBox(width: 7),
                Text(
                  '${widget.draft.platform} · ${widget.draft.format}',
                  style: const TextStyle(color: AppColors.muted),
                ),
                const Spacer(),
                const StatusPill(status: PostStatus.draft),
              ],
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 330,
                color: AppColors.surface,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const GeneratedArtwork(height: 330, seed: 1),
                    ColoredBox(
                      color: AppColors.background.withValues(alpha: 0.62),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox.square(
                            dimension: 32,
                            child: CircularProgressIndicator(
                              color: AppColors.accent,
                              strokeWidth: 3,
                            ),
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Preparing your idea...',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Creating a local demo preview',
                            style: TextStyle(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const LinearProgressIndicator(
              value: 0.68,
              color: AppColors.accent,
              backgroundColor: AppColors.surfaceRaised,
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your preview will be ready in a moment.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionLabel extends StatelessWidget {
  const _OptionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back),
      style: IconButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.surface,
      ),
    );
  }
}

String _captionFor(String prompt, String tone) {
  final concisePrompt = prompt.trim();
  final start = concisePrompt.isEmpty
      ? 'A fresh idea for your feed'
      : concisePrompt[0].toUpperCase() + concisePrompt.substring(1);
  return switch (tone) {
    'Professional' => '$start. Thoughtfully made for your next chapter.',
    'Playful' => '$start ✨ A little spark for your scroll.',
    _ => '$start. Make room for fresh ideas. ✦',
  };
}
