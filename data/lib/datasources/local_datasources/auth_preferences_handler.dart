
import 'package:data/models/user/user_token.dart';
import 'package:data/utils/api_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferenceHandler {
  static AuthPreferenceHandler? _preferenceHelper;
  AuthPreferenceHandler._instance() {
    _preferenceHelper = this;
  }
  static SharedPreferences? _preferences;

  Future<SharedPreferences?> get preferences async {
    _preferences ??= await _initPreference();
    return _preferences;
  }

  factory AuthPreferenceHandler() =>
      _preferenceHelper ?? AuthPreferenceHandler._instance();

  static SharedPreferences? sharedPreferences;

  Future<SharedPreferences> _initPreference() async {
    final pr = await SharedPreferences.getInstance();
    return pr;
  }

  // Key
  static const accessTokenKey = 'ACCESS_TOKEN';
  static const refreshTokenKey = 'REFRESH_TOKEN';

  Future<bool> setUserData(
    UserToken user,
  ) async {
    final pr = await preferences;
    try {
      pr!.setString(accessTokenKey, user.accessToken!);
      pr.setString(refreshTokenKey, user.refreshToken!);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// For Get Use Credential Data
  Future<UserToken?> getCredential() async {
    try {
      final pr = await preferences;
      if (pr!.containsKey(accessTokenKey)) {
        String accessToken = pr.getString(accessTokenKey) ?? '';
        String refreshToken = pr.getString(refreshTokenKey) ?? '';
        CredentialSaver.credential ??= UserToken(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
        return UserToken(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } else {
        return null;
      }
    } catch (e) {
      // Handle or log the error as needed
      return null;
    }
  }

  /// For Delete User Credential Data
  Future<bool> removeCredential() async {
    final pr = await preferences;
    try {
      pr!.remove(accessTokenKey);
      pr.remove(refreshTokenKey);
      CredentialSaver.credential = null;

      return true;
    } catch (e) {
      pr!.clear();
      return true;
    }
  }
}
