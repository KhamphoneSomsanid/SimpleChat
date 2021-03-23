import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplechat/models/post_model.dart';
import 'package:simplechat/models/room_model.dart';
import 'package:simplechat/models/story_model.dart';

class PreferenceService {
  static const keyEmail = 'email';
  static const keyPassword = 'password';
  static const keyIsRemember = 'is_remember';
  static const keyRequestBadge = 'request_badge';
  static const keyFriendBadge = 'request_friend';
  static const keyRoomBadge = 'room_badge_';
  static const keyNewFeed = 'new_feed';
  static const keyStoryData = 'story_data';
  static const keyPostData = 'post_data';
  static const keyRoomData = 'room_data';

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

  Future<void> setNewFeed(int count) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(keyFriendBadge, count);
  }

  Future<void> setStoryData(List<ExtraStoryModel> storyList) async {
    final SharedPreferences prefs = await _prefs;
    List<String> listMap = [];
    for (var item in storyList) {
      listMap.add(item.toJson());
    }
    await prefs.setString(keyStoryData, json.encode(listMap));
  }

  Future<void> setPostData(List<ExtraPostModel> postList) async {
    final SharedPreferences prefs = await _prefs;
    List<String> listMap = [];
    for (var item in postList) {
      listMap.add(item.toJson());
    }
    await prefs.setString(keyPostData, json.encode(listMap));
  }

  Future<void> setRoomData(List<RoomModel> roomList) async {
    final SharedPreferences prefs = await _prefs;
    List<String> listMap = [];
    for (var item in roomList) {
      listMap.add(item.toJson());
    }
    await prefs.setString(keyRoomData, json.encode(listMap));
  }

  Future<String> getEmail() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(keyEmail);
  }

  Future<bool> getRemember() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(keyIsRemember) ?? false;
  }

  Future<bool> getRequestBadge() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(keyRequestBadge) ?? false;
  }

  Future<bool> getFriendBadge() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(keyFriendBadge) ?? false;
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

  Future<int> getNewFeed() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(keyNewFeed) ?? 0;
  }

  Future<List<ExtraStoryModel>> getStoryData() async {
    final SharedPreferences prefs = await _prefs;
    String jsonData = prefs.getString(keyStoryData) ?? null;
    if (jsonData == null) return [];
    List<ExtraStoryModel> stories = [];
    for (var storyJson in (json.decode(jsonData) as List)) {
      ExtraStoryModel model = ExtraStoryModel.fromMap(json.decode(storyJson));
      stories.add(model);
    }
    return stories;
  }

  Future<List<ExtraPostModel>> getPostData() async {
    final SharedPreferences prefs = await _prefs;
    String jsonData = prefs.getString(keyPostData) ?? null;
    if (jsonData == null) return [];
    List<ExtraPostModel> posts = [];
    for (var postJson in (json.decode(jsonData) as List)) {
      ExtraPostModel model = ExtraPostModel.fromMap(json.decode(postJson));
      posts.add(model);
    }
    return posts;
  }

  Future<List<RoomModel>> getRoomData() async {
    final SharedPreferences prefs = await _prefs;
    String jsonData = prefs.getString(keyRoomData) ?? null;
    if (jsonData == null) return [];
    List<RoomModel> rooms = [];
    for (var postJson in (json.decode(jsonData) as List)) {
      RoomModel model = RoomModel.fromMap(json.decode(postJson));
      rooms.add(model);
    }
    return rooms;
  }

  Future<bool> checkKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.containsKey(key);
  }
}
