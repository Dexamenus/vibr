abstract final class CreateOptions {
  static const models = ['FLUX Schnell', 'SDXL', 'Pollinations'];
  static const styles = ['Realistis', 'Ilustrasi', 'Minimalis', 'Cerah'];
  static const tones = ['Profesional', 'Santai', 'Ceria'];
  static const rotations = ['Potret', 'Lanskap'];

  static const defaultStyle = 'Ilustrasi';
  static const defaultTone = 'Santai';
  static const defaultRotation = 'Potret';
  static const defaultRatio = '1:1';

  static const _portraitRatios = ['1:1', '4:5', '9:16'];
  static const _landscapeRatios = ['1:1', '5:4', '16:9'];

  /// Ratios on offer for a rotation; picking a rotation swaps the list.
  static List<String> ratiosFor(String rotation) =>
      rotation == 'Lanskap' ? _landscapeRatios : _portraitRatios;

  /// The same ratio in the other rotation, e.g. 4:5 <-> 5:4.
  static String flipRatio(String ratio) {
    final parts = ratio.split(':');
    return '${parts[1]}:${parts[0]}';
  }

  static double aspectOf(String ratio) {
    final parts = ratio.split(':');
    return int.parse(parts[0]) / int.parse(parts[1]);
  }
}
