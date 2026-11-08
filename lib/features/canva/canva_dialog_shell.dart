import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Colors for the light and dark variants of the Canva dialogs.
class CanvaPalette {
  const CanvaPalette._({
    required this.background,
    required this.text,
    required this.muted,
    required this.panel,
    required this.border,
    required this.closeBackground,
  });

  static const light = CanvaPalette._(
    background: Colors.white,
    text: Color(0xFF14131A),
    muted: Color(0xFF6B6878),
    panel: Color(0xFFF7F7FA),
    border: Color(0xFFE6E4EE),
    closeBackground: Color(0xFFF1F0F6),
  );

  static const dark = CanvaPalette._(
    background: Color(0xFF111016),
    text: Colors.white,
    muted: AppColors.muted,
    panel: Color(0xFF18171D),
    border: Color(0xFF2A2832),
    closeBackground: Color(0xFF211F28),
  );

  final Color background;
  final Color text;
  final Color muted;
  final Color panel;
  final Color border;
  final Color closeBackground;
}

class CanvaLogo extends StatelessWidget {
  const CanvaLogo({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/img/canva_logo.png',
      width: size,
      height: size,
      filterQuality: FilterQuality.high,
      semanticLabel: 'Canva',
    );
  }
}

/// Frame shared by the Canva dialogs: accent line, header, title and footer.
class CanvaDialogShell extends StatelessWidget {
  const CanvaDialogShell({
    super.key,
    required this.palette,
    required this.title,
    required this.description,
    required this.body,
    required this.footer,
    required this.onClose,
  });

  final CanvaPalette palette;
  final String title;
  final String description;
  final Widget body;
  final Widget footer;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.background,
              border: Border.all(color: palette.border),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF20D6B0),
                          Color(0xFF5B5BF0),
                          Color(0xFF8057FF),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CanvaLogo(),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Canva',
                                    style: TextStyle(
                                      color: palette.text,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Integrasi MCP',
                                    style: TextStyle(
                                      color: palette.muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Material(
                              color: palette.closeBackground,
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: onClose,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: palette.muted,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          title,
                          style: TextStyle(
                            color: palette.text,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            color: palette.muted,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 20),
                        body,
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, color: palette.border),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: footer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
