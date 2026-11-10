import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';
import '../social/facebook_connection_dialogs.dart';
import '../social/facebook_demo_connection.dart';
import '../social/instagram_connection_dialogs.dart';
import '../social/instagram_demo_connection.dart';
import 'auth_widgets.dart';

class BrandSetupScreen extends StatefulWidget {
  const BrandSetupScreen({
    super.key,
    required this.onSkip,
    required this.onContinue,
  });

  final Future<void> Function() onSkip;
  final Future<void> Function(
    String brandName,
    String industry,
    Uint8List? imageBytes,
  )
  onContinue;

  @override
  State<BrandSetupScreen> createState() => _BrandSetupScreenState();
}

class _BrandSetupScreenState extends State<BrandSetupScreen> {
  static const _industries = [
    'Pilih industri',
    'Kecantikan',
    'Busana',
    'Makanan & minuman',
    'Teknologi',
    'Pendidikan',
    'Kesehatan',
    'Perjalanan',
    'Lainnya',
  ];

  final _formKey = GlobalKey<FormState>();
  final _brandNameController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _facebookConnection = FacebookDemoConnection();
  final _instagramConnection = InstagramDemoConnection();
  String _industry = _industries.first;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  bool _isFacebookConnected = false;
  bool _isInstagramConnected = false;
  bool _isConnectingFacebook = false;
  bool _isConnectingInstagram = false;

  @override
  void initState() {
    super.initState();
    _loadFacebookConnection();
    _loadInstagramConnection();
  }

  Future<void> _loadFacebookConnection() async {
    final connected = await _facebookConnection.load();
    if (mounted) setState(() => _isFacebookConnected = connected);
  }

  Future<void> _loadInstagramConnection() async {
    final connected = await _instagramConnection.load();
    if (mounted) setState(() => _isInstagramConnected = connected);
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    super.dispose();
  }

  Future<void> _pickBrandImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image == null || !mounted) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      if (bytes.isEmpty) {
        showAuthDemoMessage(context, 'File gambar tidak dapat dibaca.');
        return;
      }
      if (bytes.lengthInBytes > 10 * 1024 * 1024) {
        showAuthDemoMessage(context, 'Ukuran gambar maksimal 10 MB.');
        return;
      }
      setState(() => _imageBytes = bytes);
    } on PlatformException catch (error) {
      if (mounted) {
        showAuthDemoMessage(
          context,
          error.message ?? 'Tidak dapat membuka galeri.',
        );
      }
    }
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    if (_industry == _industries.first) {
      showAuthDemoMessage(context, 'Pilih industri merekmu terlebih dahulu.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.onContinue(
        _brandNameController.text.trim(),
        _industry,
        _imageBytes,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _skip() async {
    setState(() => _isLoading = true);
    try {
      await widget.onSkip();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _connectInstagram() async {
    if (_isConnectingInstagram) return;
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
        showAuthDemoMessage(context, 'Instagram sudah terhubung di mode demo.');
      }
    } finally {
      if (mounted) setState(() => _isConnectingInstagram = false);
    }
  }

  Future<void> _connectFacebook() async {
    if (_isConnectingFacebook) return;
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
        showAuthDemoMessage(context, 'Facebook sudah terhubung di mode demo.');
      }
    } finally {
      if (mounted) setState(() => _isConnectingFacebook = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Expanded(child: AuthBrand()),
                            TextButton(
                              onPressed: _isLoading ? null : _skip,
                              child: const Text('Lewati'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Ceritakan tentang\nmerekmu',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontSize: 24, height: 1.15),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Beri AI-mu suara yang sesuai dengan merekmu.',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _BrandImagePicker(
                          imageBytes: _imageBytes,
                          onTap: _pickBrandImage,
                        ),
                        const SizedBox(height: 16),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _FieldLabel('Nama merek'),
                              const SizedBox(height: 7),
                              TextFormField(
                                key: const ValueKey('brand-name-field'),
                                controller: _brandNameController,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) =>
                                    (value?.trim().isNotEmpty ?? false)
                                    ? null
                                    : 'Nama merek wajib diisi.',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Masukkan nama merek',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 13),
                              const _FieldLabel('Industri'),
                              const SizedBox(height: 7),
                              DropdownButtonFormField<String>(
                                key: const ValueKey('brand-industry-dropdown'),
                                initialValue: _industry,
                                dropdownColor: AppColors.surfaceRaised,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.muted,
                                ),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 12,
                                  ),
                                ),
                                items: [
                                  for (final industry in _industries)
                                    DropdownMenuItem(
                                      value: industry,
                                      child: Text(industry),
                                    ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _industry = value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const _FieldLabel('Hubungkan akunmu'),
                        const SizedBox(height: 8),
                        _SocialAccountCard(
                          actionKey: const ValueKey('instagram-brand-connect'),
                          icon: Icons.camera_alt_outlined,
                          name: 'Instagram',
                          isConnected: _isInstagramConnected,
                          isLoading: _isConnectingInstagram,
                          onConnect: _connectInstagram,
                        ),
                        const SizedBox(height: 8),
                        _SocialAccountCard(
                          actionKey: const ValueKey('facebook-brand-connect'),
                          icon: Icons.facebook_rounded,
                          name: 'Halaman Facebook',
                          isConnected: _isFacebookConnected,
                          isLoading: _isConnectingFacebook,
                          onConnect: _connectFacebook,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 10, 22, 12),
                  child: AuthPrimaryButton(
                    key: const ValueKey('brand-continue'),
                    label: 'Lanjutkan',
                    isLoading: _isLoading,
                    onPressed: _continue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandImagePicker extends StatelessWidget {
  const _BrandImagePicker({required this.imageBytes, required this.onTap});

  final Uint8List? imageBytes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: const ValueKey('brand-image-picker'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 112,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.7)),
          ),
          child: imageBytes == null
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      color: AppColors.accent,
                      size: 22,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Pilih file untuk diunggah',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'JPG atau PNG · Maks. 10 MB',
                      style: TextStyle(color: AppColors.muted, fontSize: 9),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.memory(
                    imageBytes!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _SocialAccountCard extends StatelessWidget {
  const _SocialAccountCard({
    required this.actionKey,
    required this.icon,
    required this.name,
    required this.isConnected,
    required this.isLoading,
    required this.onConnect,
  });

  final Key actionKey;
  final IconData icon;
  final String name;
  final bool isConnected;
  final bool isLoading;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.muted),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  isConnected ? 'Terhubung · akun demo' : 'Belum terhubung',
                  style: TextStyle(
                    color: isConnected ? AppColors.teal : AppColors.red,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            key: actionKey,
            onPressed: onConnect,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: isLoading
                ? const Text(
                    'Memproses...',
                    style: TextStyle(fontSize: 10, color: AppColors.muted),
                  )
                : Text(
                    isConnected ? 'Terhubung' : 'Hubungkan',
                    style: const TextStyle(fontSize: 10),
                  ),
          ),
        ],
      ),
    );
  }
}
