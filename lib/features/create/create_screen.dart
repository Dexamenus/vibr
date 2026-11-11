import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_bottom_navigation.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/show_demo_message.dart';
part 'create_dialogs.dart';
part 'create_date_time_picker.dart';
part 'create_form_widgets.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({
    super.key,
    required this.controller,
    required this.onNavigationSelected,
    required this.onPostScheduled,
    required this.onPostPublished,
    required this.onPostUpdated,
    this.initialPost,
    this.showBottomNavigation = true,
  });

  final AppController controller;
  final ValueChanged<int> onNavigationSelected;
  final ValueChanged<DateTime> onPostScheduled;
  final ValueChanged<SocialPost> onPostPublished;
  final ValueChanged<DateTime> onPostUpdated;
  final SocialPost? initialPost;
  final bool showBottomNavigation;

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  static const _sampleCaption =
      'Orbit ungu. Kilau mint. ✦\n'
      'Sambut ide segar dan sudut pandang baru.\n'
      '#IdeSegar #Desain';

  late final TextEditingController _captionController;
  late DateTime _scheduledAt;
  late String _format;
  late final Set<String> _platforms;
  Uint8List? _imageBytes;
  String? _imageName;

  @override
  void initState() {
    super.initState();
    final post = widget.initialPost;
    _captionController = TextEditingController(
      text: post?.caption ?? _sampleCaption,
    );
    _format = switch (post?.format ?? 'Postingan') {
      'Post' => 'Postingan',
      'Story' => 'Cerita',
      'Carousel' => 'Karosel',
      '1:1 image' => 'Gambar 1:1',
      'Image' => 'Gambar',
      'Reel' => 'Video pendek',
      final format => format,
    };
    _imageBytes = post?.imageBytes;
    _imageName = post?.imageName;
    _platforms = post == null
        ? {'Instagram', 'Facebook'}
        : post.targetPlatforms.toSet();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _scheduledAt =
        post?.scheduledAt ??
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9);
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _togglePlatform(String platform) {
    setState(() {
      if (!_platforms.add(platform)) _platforms.remove(platform);
    });
  }

  Future<void> _showSchedulePrompt() async {
    if (widget.initialPost case final post?) {
      if (_platforms.isEmpty) {
        showDemoMessage(context, 'Pilih setidaknya satu platform.');
        return;
      }
      widget.controller.updatePost(
        post.copyWith(
          caption: _captionController.text.trim(),
          platform: _platforms.first,
          platforms: _platforms.toList(),
          scheduledAt: _scheduledAt,
          format: _format,
          imageBytes: _imageBytes,
          imageName: _imageName,
        ),
      );
      widget.onPostUpdated(_scheduledAt);
      return;
    }

    final action = await showDialog<_PublishAction>(
      context: context,
      builder: (context) => const _PublishOptionsDialog(),
    );
    if (!mounted || action == null) return;

    if (action == _PublishAction.postNow) {
      final post = _createPost(DateTime.now(), PostStatus.published);
      if (post != null) widget.onPostPublished(post);
      return;
    }

    if (_createPost(_scheduledAt, PostStatus.scheduled) == null) return;
    widget.onPostScheduled(_scheduledAt);
  }

  SocialPost? _createPost(DateTime dateTime, PostStatus status) {
    if (_platforms.isEmpty) {
      showDemoMessage(context, 'Pilih setidaknya satu platform.');
      return null;
    }
    return widget.controller.addPost(
      caption: _captionController.text.trim(),
      platform: _platforms.first,
      platforms: _platforms.toList(),
      scheduledAt: dateTime,
      format: _format,
      imageBytes: _imageBytes,
      imageName: _imageName,
      status: status,
    );
  }

  Future<void> _pickImage() async {
    try {
      final files = await FilePicker.pickFiles(type: FileType.image);
      if (!mounted || files.isEmpty) return;

      final file = files.first;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      if (bytes.isEmpty) {
        showDemoMessage(context, 'Gambar yang dipilih tidak dapat dibaca.');
        return;
      }

      setState(() {
        _imageBytes = bytes;
        _imageName = file.name;
      });
    } on PlatformException catch (error) {
      if (mounted) {
        showDemoMessage(
          context,
          error.message ?? 'Tidak dapat membuka pemilih gambar.',
        );
      }
    }
  }

  Future<void> _generateCaption() async {
    final prompt = await showDialog<String>(
      context: context,
      builder: (context) => const _CaptionPromptDialog(),
    );
    if (!mounted || prompt == null) return;
    final topic = prompt.trim();
    final capitalizedTopic = '${topic[0].toUpperCase()}${topic.substring(1)}';
    _captionController.text =
        '$capitalizedTopic ✨\n\n'
        'Sedikit inspirasi untuk harimu.\n'
        '#IdeSegar';
    showDemoMessage(context, 'Caption dibuat dari prompt kamu.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              _buildArtworkPicker(),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Buat caption',
                icon: Icons.auto_awesome_rounded,
                onPressed: _generateCaption,
              ),
              const SizedBox(height: 16),
              _buildCaptionField(),
              const SizedBox(height: 16),
              _buildFormatPicker(),
              const SizedBox(height: 16),
              _buildPlatformPicker(),
              const SizedBox(height: 16),
              _buildDateTimeSelector(),
              const SizedBox(height: 16),
              PrimaryButton(
                label: widget.initialPost == null
                    ? 'Jadwalkan'
                    : 'Simpan perubahan',
                icon: Icons.calendar_month_rounded,
                onPressed: _showSchedulePrompt,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.showBottomNavigation
          ? SafeArea(
              top: false,
              child: AppBottomNavigation(
                selectedIndex: 2,
                onSelected: widget.onNavigationSelected,
              ),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Text(
      widget.initialPost == null ? 'Jadwal Baru' : 'Edit Postingan',
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildArtworkPicker() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _imageBytes == null
              ? Image.asset(
                  'assets/img/Violet orbits artwork.png',
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                )
              : Image.memory(
                  _imageBytes!,
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _imageName ?? 'Dari kreasimu · 1 gambar',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
              const SizedBox(height: 9),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SmallActionButton(
                    label: 'Koleksi',
                    onPressed: () => showDemoMessage(
                      context,
                      'Koleksi media kamu siap digunakan.',
                    ),
                  ),
                  _SmallActionButton(label: 'Unggah', onPressed: _pickImage),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCaptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Caption · Ketuk untuk mengedit',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const ValueKey('caption-field'),
          controller: _captionController,
          minLines: 3,
          maxLines: 5,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.4,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormatPicker() {
    final formats = {'Postingan', 'Video pendek', 'Cerita', _format}.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis konten',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final format in formats)
              _ChoicePill(
                label: format,
                selected: _format == format,
                onTap: () => setState(() => _format = format),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlatformPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Platform',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Text(
              '${_platforms.length} dipilih',
              style: const TextStyle(color: AppColors.muted, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final platform in ['Instagram', 'Facebook'])
              _ChoicePill(
                label: platform,
                icon: platform == 'Instagram'
                    ? Icons.camera_alt_outlined
                    : Icons.facebook_rounded,
                selected: _platforms.contains(platform),
                onTap: () => _togglePlatform(platform),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Tanggal & waktu',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Text(
              'WIB (UTC+7)',
              style: const TextStyle(color: AppColors.muted, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            key: const ValueKey('open-date-time-picker'),
            borderRadius: BorderRadius.circular(12),
            onTap: _openDateTimePicker,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.accent,
                    size: 17,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      DateFormat(
                        'EEE, d MMM yyyy · HH.mm',
                        'id_ID',
                      ).format(_scheduledAt),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const Icon(
                    Icons.edit_calendar_rounded,
                    color: AppColors.muted,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openDateTimePicker() async {
    final selectedDateTime = await showDialog<DateTime>(
      context: context,
      builder: (context) =>
          _DateTimePickerDialog(initialDateTime: _scheduledAt),
    );
    if (selectedDateTime != null && mounted) {
      setState(() => _scheduledAt = selectedDateTime);
    }
  }
}
