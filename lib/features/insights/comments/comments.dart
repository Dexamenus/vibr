part of '../insights_screen.dart';

extension _InsightsComments on _InsightsScreenState {
  Widget _buildComments() {
    final visibleComments = _comments.where((comment) {
      final sentimentMatches = switch (_commentFilter) {
        'Positif' => comment.sentiment == InsightsSentiment.positive,
        'Pertanyaan' => comment.sentiment == InsightsSentiment.question,
        'Negatif' => comment.sentiment == InsightsSentiment.negative,
        _ => true,
      };
      return sentimentMatches &&
          (_commentPlatform == null || comment.platform == _commentPlatform);
    }).toList();
    final count = _comments
        .where(
          (comment) =>
              _commentPlatform == null || comment.platform == _commentPlatform,
        )
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        SectionHeading(
          title: 'Komentar Hari Ini',
          padding: const EdgeInsets.only(bottom: 16),
          trailing: _filterButton(onTap: _showCommentFilter),
        ),
        Wrap(
          spacing: 7,
          runSpacing: 0,
          children: [
            _commentFilterChip('Semua', count),
            _commentFilterChip(
              'Positif',
              _countFor(InsightsSentiment.positive),
            ),
            _commentFilterChip(
              'Pertanyaan',
              _countFor(InsightsSentiment.question),
            ),
            _commentFilterChip(
              'Negatif',
              _countFor(InsightsSentiment.negative),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (visibleComments.isEmpty)
          _buildEmptyComments()
        else ...[
          SectionHeading(
            title: 'Komentar terbaru',
            actionLabel:
                'Menampilkan ${visibleComments.length < 3 ? visibleComments.length : 3} dari $count',
            padding: const EdgeInsets.only(top: 2, bottom: 10),
          ),
          for (final comment in visibleComments.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _commentCard(comment),
            ),
        ],
      ],
    );
  }

  Widget _commentFilterChip(String label, int count) => SelectablePill(
    label: label,
    count: count,
    selected: _commentFilter == label,
    onTap: () => _updateState(() => _commentFilter = label),
  );

  int _countFor(InsightsSentiment sentiment) => _comments
      .where(
        (comment) =>
            comment.sentiment == sentiment &&
            (_commentPlatform == null || comment.platform == _commentPlatform),
      )
      .length;

  Widget _buildEmptyComments() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.accent,
            size: 30,
          ),
          SizedBox(height: 12),
          Text(
            'Semua komentar sudah diperiksa',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          Text(
            'Komentar baru akan muncul di sini.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _commentCard(InsightsComment comment) {
    final reply = _replies[comment.id];
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: comment.initials == 'AS'
                    ? const Color(0xFF3B2028)
                    : AppColors.surfaceRaised,
                child: Text(
                  comment.initials,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.handle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          comment.platform == 'Instagram'
                              ? Icons.camera_alt_outlined
                              : Icons.facebook_rounded,
                          size: 12,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          comment.platform,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.camera_alt_outlined,
                size: 13,
                color: AppColors.muted,
              ),
              const SizedBox(width: 4),
              Text(
                comment.timeLabel,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.message,
            style: const TextStyle(fontSize: 14, height: 1.55),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 5,
            children: [
              _tag(comment.sentimentLabel, comment.sentimentColor),
              _tag(comment.aiLabel, const Color(0xFFBBA3FF)),
            ],
          ),
          if (reply != null) ...[
            const SizedBox(height: 9),
            Text(
              'Balasan Anda: $reply',
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _toggleResolved(comment),
                  child: Row(
                    children: [
                      Icon(
                        comment.isResolved
                            ? Icons.check_circle_outline_rounded
                            : Icons.check_rounded,
                        size: 15,
                        color: comment.isResolved
                            ? AppColors.teal
                            : AppColors.muted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        comment.isResolved ? 'Selesai' : 'Tandai selesai',
                        style: TextStyle(
                          color: comment.isResolved
                              ? AppColors.teal
                              : AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _showReplyDialog(comment),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  reply == null ? 'Balas' : 'Balas lagi',
                  style: const TextStyle(
                    color: Color(0xFFBBA3FF),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, Color color) {
    final background = label.startsWith('AI')
        ? AppColors.accentSoft
        : color.withValues(alpha: 0.12);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 10, height: 1),
        ),
      ),
    );
  }

  void _toggleResolved(InsightsComment comment) {
    _updateState(() {
      final index = _comments.indexWhere((item) => item.id == comment.id);
      _comments[index] = comment.copyWith(isResolved: !comment.isResolved);
    });
  }

  Future<void> _showCommentFilter() async {
    final platform = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) =>
          _CommentPlatformSheet(initialPlatform: _commentPlatform),
    );
    if (platform != null && mounted) {
      _updateState(
        () => _commentPlatform = platform == 'Semua' ? null : platform,
      );
    }
  }

  Future<void> _showReplyDialog(InsightsComment comment) async {
    final controller = TextEditingController();
    final reply = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surfaceRaised,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          title: Text(
            'Balas kepada ${comment.handle}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Unggahan asal · Instagram',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                      const SizedBox(height: 5),
                      Text(comment.postTitle),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  minLines: 3,
                  onChanged: (_) => setDialogState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Tulis balasan...',
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
            SizedBox(
              width: 142,
              child: PrimaryButton(
                label: 'Kirim balasan',
                icon: Icons.send_rounded,
                onPressed: controller.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, controller.text.trim()),
              ),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (reply != null && mounted) {
      _updateState(() => _replies[comment.id] = reply);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Balasan terkirim dalam mode demo')),
      );
    }
  }
}

class _CommentPlatformSheet extends StatefulWidget {
  const _CommentPlatformSheet({required this.initialPlatform});

  final String? initialPlatform;

  @override
  State<_CommentPlatformSheet> createState() => _CommentPlatformSheetState();
}

class _CommentPlatformSheetState extends State<_CommentPlatformSheet> {
  late String _platform = widget.initialPlatform ?? 'Semua';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _sheetHeading(
              'Filter jejaring sosial',
              'Pilih platform untuk menampilkan komentar.',
            ),
            const SizedBox(height: 20),
            for (final platform in ['Semua', 'Instagram', 'Facebook'])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _optionPill(
                  label: platform,
                  selected: _platform == platform,
                  onTap: () => setState(() => _platform = platform),
                  expand: true,
                ),
              ),
            const SizedBox(height: 10),
            PrimaryButton(
              label: 'Terapkan filter',
              icon: Icons.check_rounded,
              onPressed: () => Navigator.pop(context, _platform),
            ),
          ],
        ),
      ),
    );
  }
}
