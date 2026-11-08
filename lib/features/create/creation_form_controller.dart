import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'create_options.dart';

/// State of the create form, shared by the Create and Your creation screens.
class CreationFormController extends ChangeNotifier {
  static const maxReferences = 4;

  CreationFormController() {
    // Clear the error as soon as the user starts typing a prompt.
    promptController.addListener(() {
      if (_promptError != null && promptController.text.trim().isNotEmpty) {
        _update(() => _promptError = null);
      }
    });
  }

  final promptController = TextEditingController();
  final List<Uint8List> _references = [];
  String? _promptError;

  String _model = CreateOptions.models.first;
  String _style = CreateOptions.defaultStyle;
  String _tone = CreateOptions.defaultTone;
  String _rotation = CreateOptions.defaultRotation;
  String _ratio = CreateOptions.defaultRatio;

  String get model => _model;
  String get style => _style;
  String get tone => _tone;
  String get rotation => _rotation;
  String get ratio => _ratio;
  List<Uint8List> get references => List.unmodifiable(_references);
  String? get promptError => _promptError;

  set model(String value) => _update(() => _model = value);
  set style(String value) => _update(() => _style = value);
  set tone(String value) => _update(() => _tone = value);
  set ratio(String value) => _update(() => _ratio = value);

  /// Changing the rotation also flips the chosen ratio (4:5 becomes 5:4).
  set rotation(String value) => _update(() {
    if (value == _rotation) return;
    _rotation = value;
    _ratio = CreateOptions.flipRatio(_ratio);
  });

  /// The prompt is required; flags the field and returns false when empty.
  bool validatePrompt() {
    final valid = promptController.text.trim().isNotEmpty;
    _update(() => _promptError = valid ? null : 'Prompt wajib diisi dulu ya.');
    return valid;
  }

  void addReferences(Iterable<Uint8List> images) =>
      _update(() => _references.addAll(images));

  void removeReferenceAt(int index) =>
      _update(() => _references.removeAt(index));

  void _update(VoidCallback change) {
    change();
    notifyListeners();
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }
}
