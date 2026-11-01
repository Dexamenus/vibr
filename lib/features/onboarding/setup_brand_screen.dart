import 'package:flutter/material.dart';

import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_widgets.dart';
import '../shell/home_shell.dart';

class SetupBrandScreen extends StatefulWidget {
  const SetupBrandScreen({
    super.key,
    required this.controller,
    this.initialBrandName = '',
  });

  final AppController controller;
  final String initialBrandName;

  @override
  State<SetupBrandScreen> createState() => _SetupBrandScreenState();
}

class _SetupBrandScreenState extends State<SetupBrandScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _brandName;
  String _industry = 'Creator / Influencer';
  String _tone = 'Casual';
  final Set<String> _platforms = {'Instagram', 'Facebook'};

  @override
  void initState() {
    super.initState();
    _brandName = TextEditingController(text: widget.initialBrandName);
  }

  @override
  void dispose() {
    _brandName.dispose();
    super.dispose();
  }

  void _finish() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_platforms.isEmpty) {
      showDemoMessage(context, 'Select at least one social platform.');
      return;
    }
    _openHome();
  }

  void _openHome() {
    widget.controller.updateBrandName(_brandName.text);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HomeShell(controller: widget.controller),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPage(
        padding: const EdgeInsets.fromLTRB(26, 20, 26, 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const BrandLogo(compact: true),
                  const Spacer(),
                  TextButton(
                    onPressed: _openHome,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Tell us about your brand',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 9),
              const Text(
                'Give your AI a voice that feels like you.',
                style: TextStyle(color: AppColors.muted, fontSize: 16),
              ),
              const SizedBox(height: 28),
              AppTextField(
                label: 'Brand name',
                hint: 'Enter your brand name',
                controller: _brandName,
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Brand name is required'
                    : null,
              ),
              const SizedBox(height: 22),
              const Text(
                'Industry',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 9),
              DropdownButtonFormField<String>(
                initialValue: _industry,
                decoration: const InputDecoration(hintText: 'Select industry'),
                items:
                    const [
                          'Creator / Influencer',
                          'Beauty & wellness',
                          'Food & beverage',
                          'Fashion & lifestyle',
                          'Education',
                          'Other',
                        ]
                        .map(
                          (industry) => DropdownMenuItem(
                            value: industry,
                            child: Text(industry),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _industry = value);
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Brand description',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 9),
              const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'What makes your brand special?',
                ),
              ),
              const SizedBox(height: 20),
              const _SetupLabel('Platforms'),
              Wrap(
                spacing: 8,
                children: [
                  for (final platform in ['Instagram', 'Facebook', 'TikTok'])
                    SelectablePill(
                      label: platform,
                      selected: _platforms.contains(platform),
                      onTap: () => setState(() {
                        if (!_platforms.add(platform)) {
                          _platforms.remove(platform);
                        }
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 19),
              const _SetupLabel('Brand tone'),
              Wrap(
                spacing: 8,
                children: [
                  for (final tone in [
                    'Casual',
                    'Professional',
                    'Playful',
                    'Luxury',
                    'Minimal',
                  ])
                    SelectablePill(
                      label: tone,
                      selected: _tone == tone,
                      onTap: () => setState(() => _tone = tone),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              PrimaryButton(label: 'Continue', onPressed: _finish),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupLabel extends StatelessWidget {
  const _SetupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
