/// Which creation flow a form/result screen belongs to.
enum CreationMode {
  ai,
  canva;

  String get createTitle => switch (this) {
    CreationMode.ai => 'Buat Gambar dengan AI',
    CreationMode.canva => 'Buat dengan Canva',
  };

  /// Canva designs are not tied to an image model.
  bool get showsModel => this == CreationMode.ai;
}
