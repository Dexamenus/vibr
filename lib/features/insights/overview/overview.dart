part of '../insights_screen.dart';

extension _InsightsOverview on _InsightsScreenState {
  Widget _buildOverview() {
    final metrics = InsightsDemoData.metrics(
      periodDays: _periodDays,
      platform: _platform,
      contentType: _contentType,
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        SectionHeading(
          title: 'Kinerja konten',
          padding: const EdgeInsets.only(bottom: 16),
          trailing: _filterButton(onTap: _showAnalyticsFilter),
        ),
        const Text(
          'Tipe konten',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            SelectablePill(
              label: 'Video Reels',
              selected: _contentType == 'Reels',
              onTap: () => _updateState(() => _contentType = 'Reels'),
            ),
            const SizedBox(width: 8),
            SelectablePill(
              label: 'Unggahan',
              selected: _contentType == 'Post',
              onTap: () => _updateState(() => _contentType = 'Post'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                'Contoh analitik · $_platform',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'WIB',
              style: TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _metricGrid(metrics),
        const SizedBox(height: 16),
        for (final metric in metrics) ...[
          _metricHeading(metric),
          const SizedBox(height: 8),
          Text(
            '20–26 Juni 2026 · ${metric.description}',
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          LineChartCard(
            values: metric.points,
            axisLabels: metric.axisLabels,
            xAxisLabels: const ['20', '21', '22', '23', '24', '25', '26'],
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _metricGrid(List<AnalyticsMetric> metrics) {
    return Column(
      children: [
        Row(
          children: [
            MetricCard(
              value: metrics[0].value,
              label: metrics[0].title,
              caption: 'Total penayangan',
            ),
            const SizedBox(width: 12),
            MetricCard(
              value: metrics[1].value,
              label: metrics[1].title,
              caption: 'Aksi pada konten',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            MetricCard(
              value: metrics[2].value,
              label: metrics[2].title,
              caption: 'Interaksi ÷ tayangan',
            ),
            const SizedBox(width: 12),
            MetricCard(
              value: metrics[3].value,
              label: metrics[3].title,
              caption: 'Rata-rata jangkauan / unggahan',
            ),
          ],
        ),
      ],
    );
  }

  Widget _metricHeading(AnalyticsMetric metric) {
    return Row(
      children: [
        Expanded(
          child: Text(
            metric.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          metric.value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Future<void> _showAnalyticsFilter() async {
    final result = await showModalBottomSheet<({int days, String platform})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => _AnalyticsFilterSheet(
        initialDays: _periodDays,
        initialPlatform: _platform,
      ),
    );
    if (result != null && mounted) {
      _updateState(() {
        _periodDays = result.days;
        _platform = result.platform;
      });
    }
  }
}

class _AnalyticsFilterSheet extends StatefulWidget {
  const _AnalyticsFilterSheet({
    required this.initialDays,
    required this.initialPlatform,
  });

  final int initialDays;
  final String initialPlatform;

  @override
  State<_AnalyticsFilterSheet> createState() => _AnalyticsFilterSheetState();
}

class _AnalyticsFilterSheetState extends State<_AnalyticsFilterSheet> {
  late int _days = widget.initialDays;
  late String _platform = widget.initialPlatform;
  static const _periods = [7, 14, 30, 60, 90];
  static const _platformOptions = ['Instagram', 'Facebook'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
        child: Column(
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
            _sheetHeading('Filter analitik', 'Sesuaikan periode dan platform.'),
            const SizedBox(height: 24),
            const Text('Rentang waktu'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _periods
                  .map(
                    (days) => _optionPill(
                      label: '$days hari',
                      selected: _days == days,
                      onTap: () => setState(() => _days = days),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Text('Jejaring sosial'),
            const SizedBox(height: 5),
            const Text(
              'Pilih satu platform.',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              children: _platformOptions
                  .map(
                    (platform) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: platform == 'Instagram' ? 8 : 0,
                        ),
                        child: _optionPill(
                          label: platform,
                          selected: _platform == platform,
                          onTap: () => setState(() => _platform = platform),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        _days = 7;
                        _platform = 'Instagram';
                      }),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.surfaceRaised,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text('Atur ulang'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, (
                        days: _days,
                        platform: _platform,
                      )),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text('Terapkan filter'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
