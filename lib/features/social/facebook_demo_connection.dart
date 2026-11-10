import 'package:shared_preferences/shared_preferences.dart';

class FacebookDemoConnection {
  static const connectedPreferenceKey = 'vibr.facebook_demo_connected';
  static const accountPreferenceKey = 'vibr.facebook_demo_account';
  static const demoAccount = 'Zahira Studio';

  bool connected = false;
  String account = demoAccount;

  Future<bool> load() async {
    final preferences = await SharedPreferences.getInstance();
    connected = preferences.getBool(connectedPreferenceKey) ?? false;
    account = preferences.getString(accountPreferenceKey) ?? demoAccount;
    return connected;
  }

  Future<bool> authorize() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final preferences = await SharedPreferences.getInstance();
    final savedAccount = await preferences.setString(
      accountPreferenceKey,
      demoAccount,
    );
    final savedConnection = await preferences.setBool(
      connectedPreferenceKey,
      true,
    );
    if (!savedAccount || !savedConnection) return false;
    account = demoAccount;
    connected = true;
    return true;
  }

  Future<bool> disconnect() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setBool(connectedPreferenceKey, false);
    if (saved) connected = false;
    return saved;
  }
}
