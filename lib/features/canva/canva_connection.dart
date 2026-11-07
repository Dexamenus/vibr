import 'package:flutter/foundation.dart';

/// Whether the workspace is linked to Canva. Authorization is simulated until
/// the real Canva MCP integration is wired in.
class CanvaConnection extends ChangeNotifier {
  bool _connected = false;

  bool get connected => _connected;

  /// Re-checks the connection status.
  Future<bool> check() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return _connected;
  }

  /// Runs the (simulated) Canva authorization.
  Future<void> authorize() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    _connected = true;
    notifyListeners();
  }
}
