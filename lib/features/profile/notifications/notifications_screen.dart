import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/surface_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // State untuk menyimpan nilai toggle
  bool _isPublishingAlertsOn = true;
  bool _isCommentAlertsOn = false;

  void _handlePublishingToggle(bool value) {
    setState(() {
      _isPublishingAlertsOn = value;
    });
  }

  void _handleCommentToggle(bool value) {
    setState(() {
      _isCommentAlertsOn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          const Text(
            'Pilih pembaruan apa yang ingin Anda terima.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),

          // Peringatan Aktivitas
          const Text(
            'Peringatan aktivitas',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          SurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildNotificationToggle(
                  icon: Icons.notifications_none_outlined,
                  title: 'Peringatan publikasi',
                  subtitle: 'Dapatkan pembaruan tentang aktivitas publikasi agar Anda dapat memantau postingan Anda.',
                  value: _isPublishingAlertsOn,
                  onChanged: _handlePublishingToggle,
                ),
                Divider(
                  height: 1,
                  color: AppColors.border.withValues(alpha: 0.5),
                  indent: 16,
                  endIndent: 16,
                ),
                _buildNotificationToggle(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Peringatan komentar',
                  subtitle: 'Dapatkan notifikasi tentang komentar baru di akun yang terhubung.',
                  value: _isCommentAlertsOn,
                  onChanged: _handleCommentToggle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Izin Perangkat
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.smartphone_outlined,
                  color: AppColors.muted,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Izin perangkat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pengaturan notifikasi perangkat Anda juga mengontrol pengiriman. Jika peringatan tidak muncul, pastikan notifikasi diizinkan untuk aplikasi ini.',
                        style: TextStyle(
                          color: AppColors.muted.withValues(alpha: 0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Teks Helper Bawah
          const Text(
            'Mematikan peringatan hanya akan mengubah notifikasi. Itu tidak menghentikan publikasi atau komentar.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Widget helper untuk item toggle
  Widget _buildNotificationToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.muted, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              SizedBox(
                height: 36, // Menyesuaikan tinggi agar sejajar
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.accent,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: AppColors.border,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value ? 'Aktif' : 'Nonaktif',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}