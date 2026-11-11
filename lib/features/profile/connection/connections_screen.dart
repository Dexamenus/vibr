import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../../shared/widgets/top_toast.dart';
import '../../social/facebook_connection_dialogs.dart';
import '../../social/facebook_demo_connection.dart';
import '../../social/instagram_connection_dialogs.dart';
import '../../social/instagram_demo_connection.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  final _facebookConnection = FacebookDemoConnection();
  final _instagramConnection = InstagramDemoConnection();
  bool _isFacebookConnected = false;
  bool _isInstagramConnected = false;
  bool _isLoading = true;
  bool _isConnectingFacebook = false;
  bool _isConnectingInstagram = false;

  @override
  void initState() {
    super.initState();
    _loadConnection();
  }

  Future<void> _loadConnection() async {
    final facebookConnected = await _facebookConnection.load();
    final instagramConnected = await _instagramConnection.load();
    if (mounted) {
      setState(() {
        _isFacebookConnected = facebookConnected;
        _isInstagramConnected = instagramConnected;
        _isLoading = false;
      });
    }
  }

  Future<void> _connectInstagram() async {
    if (_isConnectingInstagram || _isLoading) return;
    setState(() => _isConnectingInstagram = true);
    try {
      final alreadyConnected = _instagramConnection.connected;
      final connected = await ensureInstagramConnected(
        context,
        _instagramConnection,
      );
      if (!mounted) return;
      setState(() => _isInstagramConnected = connected);
      if (alreadyConnected && connected) {
        showTopToast(
          context,
          title: 'Instagram sudah terhubung',
          message: 'Akun demo ${_instagramConnection.account} sudah siap.',
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.teal,
        );
      }
    } finally {
      if (mounted) setState(() => _isConnectingInstagram = false);
    }
  }

  Future<void> _connectFacebook() async {
    if (_isConnectingFacebook || _isLoading) return;
    setState(() => _isConnectingFacebook = true);
    try {
      final alreadyConnected = _facebookConnection.connected;
      final connected = await ensureFacebookConnected(
        context,
        _facebookConnection,
      );
      if (!mounted) return;
      setState(() => _isFacebookConnected = connected);
      if (alreadyConnected && connected) {
        showTopToast(
          context,
          title: 'Facebook sudah terhubung',
          message: 'Halaman demo ${_facebookConnection.account} sudah siap.',
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.teal,
        );
      }
    } finally {
      if (mounted) setState(() => _isConnectingFacebook = false);
    }
  }

  Future<void> _disconnectInstagram() async {
    final shouldDisconnect = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const ValueKey('disconnect-instagram-dialog'),
        backgroundColor: AppColors.surface,
        icon: const Icon(
          Icons.link_off_rounded,
          color: AppColors.red,
          size: 28,
        ),
        title: const Text(
          'Putuskan Instagram?',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Akun demo tidak lagi ditampilkan sebagai terhubung. Kamu bisa '
          'menghubungkannya kembali kapan saja.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, height: 1.4),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            key: const ValueKey('cancel-instagram-disconnect'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            key: const ValueKey('confirm-instagram-disconnect'),
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Putuskan'),
          ),
        ],
      ),
    );
    if (shouldDisconnect != true) return;

    final disconnected = await _instagramConnection.disconnect();
    if (!mounted) return;
    if (!disconnected) {
      showTopToast(
        context,
        title: 'Koneksi belum diputus',
        message: 'Coba lagi beberapa saat.',
        icon: Icons.error_outline_rounded,
        iconColor: AppColors.red,
      );
      return;
    }
    setState(() => _isInstagramConnected = false);
    showTopToast(
      context,
      title: 'Instagram terputus',
      message: 'Akun demo berhasil diputuskan dari ruang kerjamu.',
      icon: Icons.link_off_rounded,
      iconColor: AppColors.amber,
    );
  }

  Future<void> _disconnectFacebook() async {
    final shouldDisconnect = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const ValueKey('disconnect-facebook-dialog'),
        backgroundColor: AppColors.surface,
        icon: const Icon(
          Icons.link_off_rounded,
          color: AppColors.red,
          size: 28,
        ),
        title: const Text(
          'Putuskan Facebook?',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Halaman demo tidak lagi ditampilkan sebagai terhubung. Kamu bisa '
          'menghubungkannya kembali kapan saja.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, height: 1.4),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            key: const ValueKey('cancel-facebook-disconnect'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            key: const ValueKey('confirm-facebook-disconnect'),
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Putuskan'),
          ),
        ],
      ),
    );
    if (shouldDisconnect != true) return;

    final disconnected = await _facebookConnection.disconnect();
    if (!mounted) return;
    if (!disconnected) {
      showTopToast(
        context,
        title: 'Koneksi belum diputus',
        message: 'Coba lagi beberapa saat.',
        icon: Icons.error_outline_rounded,
        iconColor: AppColors.red,
      );
      return;
    }
    setState(() => _isFacebookConnected = false);
    showTopToast(
      context,
      title: 'Facebook terputus',
      message: 'Halaman demo berhasil diputuskan dari ruang kerjamu.',
      icon: Icons.link_off_rounded,
      iconColor: AppColors.amber,
    );
  }

  @override
  Widget build(BuildContext context) {
    final instagramAccount = _isInstagramConnected
        ? _instagramConnection.account
        : 'Belum ditautkan';
    final facebookAccount = _isFacebookConnected
        ? _facebookConnection.account
        : 'Belum ditautkan';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Koneksi',
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
            'Kelola aplikasi yang terhubung ke ruang kerja Anda.',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Akun terhubung',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Mode demo',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildConnectionCard(
            key: const ValueKey('instagram-connection-card'),
            icon: Icons.camera_alt_outlined,
            platform: 'Instagram',
            accountName: _isLoading ? 'Memeriksa koneksi...' : instagramAccount,
            isConnected: _isInstagramConnected,
            isLoading: _isLoading || _isConnectingInstagram,
            onAction: _isInstagramConnected
                ? _disconnectInstagram
                : _connectInstagram,
          ),
          const SizedBox(height: 16),
          _buildConnectionCard(
            key: const ValueKey('facebook-connection-card'),
            icon: Icons.facebook_rounded,
            platform: 'Halaman Facebook',
            accountName: _isLoading ? 'Memeriksa koneksi...' : facebookAccount,
            isConnected: _isFacebookConnected,
            isLoading: _isLoading || _isConnectingFacebook,
            onAction: _isFacebookConnected
                ? _disconnectFacebook
                : _connectFacebook,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              key: const ValueKey('connect-instagram-profile'),
              onPressed: _isInstagramConnected ? null : _connectInstagram,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.surfaceRaised,
                disabledForegroundColor: AppColors.muted,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Hubungkan Instagram',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              key: const ValueKey('connect-facebook-profile'),
              onPressed: _isFacebookConnected || _isLoading
                  ? null
                  : _connectFacebook,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceRaised,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.surfaceRaised,
                disabledForegroundColor: AppColors.muted,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
              child: const Text(
                'Hubungkan Facebook',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sambungkan akun Instagram profesional atau Halaman Facebook '
            'untuk menyiapkan saluran konten merek Anda.',
            style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.muted,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Koneksi Instagram ini disimulasikan secara lokal. '
                    'Aplikasi tidak meminta kata sandi dan tidak terhubung '
                    'ke layanan Instagram.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard({
    required Key key,
    required IconData icon,
    required String platform,
    required String accountName,
    required bool isConnected,
    required VoidCallback onAction,
    bool isLoading = false,
  }) {
    return SurfaceCard(
      key: key,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        platform,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        accountName,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.border.withValues(alpha: 0.5),
            indent: 16,
            endIndent: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusPill(
                  label: isConnected ? 'Terhubung · Demo' : 'Belum terhubung',
                  color: isConnected ? AppColors.teal : AppColors.amber,
                ),
                TextButton(
                  onPressed: isLoading ? null : onAction,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: isLoading
                      ? const Text(
                          'Memproses...',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        )
                      : Text(
                          isConnected ? 'Putuskan koneksi' : 'Hubungkan',
                          style: TextStyle(
                            color: isConnected
                                ? AppColors.red
                                : AppColors.accent,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
