import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const keyEmail = 'email';
  static const keyPassword = 'password';
  static const keyIsRemember = 'is_remember';
  static const keyRequestBadge = 'request_badge';
  static const keyFriendBadge = 'request_friend';
  static const keyRoomBadge = 'room_badge_';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> init() async {
    if (_prefs == null) {
      _prefs = SharedPreferences.getInstance();
    }
  }

  PreferenceService._();
  factory PreferenceService() => _instance;

  static final PreferenceService _instance = PreferenceService._();

  Future<void> setEmail(String email) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(keyEmail, email);
  }

  Future<void> setPassword(String pass) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(keyPassword, pass);
  }

  Future<void> setRemember(bool flag) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(keyIsRemember, flag);
  }

  Future<void> setRequestBadge(bool flag) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(keyRequestBadge, flag);
  }

  Future<void> setFriendBadge(bool flag) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(keyFriendBadge, flag);
  }

  Future<void> setRoomBadge(dynamic roomid, int badge) async {
    final SharedPreferences prefs = await _prefs;
    String key = '$keyRoomBadge$roomid';
    await prefs.setInt(key, badge);
  }





  Future<String> getEmail() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(keyEmail);
  }

  Future<bool> getRemember() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(keyIsRemember)?? false;
  }

  Future<bool> getRequestBadge() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(keyRequestBadge)?? false;
  }

  Future<bool> getFriendBadge() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(keyFriendBadge)?? false;
  }

  Future<String> getPassword() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(keyPassword);
  }

  Future<int> getRoomBadge(dynamic roomid) async {
    final SharedPreferences prefs = await _prefs;
    String key = '$keyRoomBadge$roomid';
    return prefs.getInt(key) ?? 0;
  }



  Future<bool> checkKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.containsKey(key);
  }

}