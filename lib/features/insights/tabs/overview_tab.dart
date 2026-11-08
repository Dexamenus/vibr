import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/line_chart_card.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../shared/widgets/selectable_pill.dart';
import '../insights_demo_data.dart';
import '../insights_models.dart';
import '../widgets/insight_bottom_sheets.dart'; // import file bottom sheet

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  int _periodDays = 7;
  String _platform = 'Instagram';
  String _contentType = 'Reels';

  Future<void> _showAnalyticsFilter() async {
    final result = await showModalBottomSheet<({int days, String platform})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => AnalyticsFilterSheet(
        initialDays: _periodDays,
        initialPlatform: _platform,
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _periodDays = result.days;
        _platform = result.platform;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          trailing: FilterButton(onTap: _showAnalyticsFilter),
        ),
        const Text(
          'Tipe konten',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            SelectablePill(
              label: 'Reels',
              selected: _contentType == 'Reels',
              onTap: () => setState(() => _contentType = 'Reels'),
            ),
            const SizedBox(width: 8),
            SelectablePill(
              label: 'Post',
              selected: _contentType == 'Post',
              onTap: () => setState(() => _contentType = 'Post'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        _MetricGrid(metrics: metrics),
        const SizedBox(height: 16),
        for (final metric in metrics) ...[
          _MetricHeading(metric: metric),
          const SizedBox(height: 8),
          Text(
            '20–26 Jun 2026 · ${metric.description}',
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
}

class _MetricGrid extends StatelessWidget {
  final List<AnalyticsMetric> metrics;
  const _MetricGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
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
              caption: 'Rata-rata akun / post',
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricHeading extends StatelessWidget {
  final AnalyticsMetric metric;
  const _MetricHeading({required this.metric});

  @override
  Widget build(BuildContext context) {
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
}
