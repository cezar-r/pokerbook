import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';

/// A class that represents a user's preferences
/// Has getter and setter methods for preferences such as theme color
class AppUser {

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  /// called to initialize the preferences
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static List getGames() {
    String gamesStr = _prefsInstance?.getString('_gameHistory') ?? '[]';
    List games = json.decode(gamesStr);
    return games;
  }

  static void addGame(Map game) {
    List games = getGames();
    games.add(game);
    String gamesStr = json.encode(games);
    _prefsInstance?.setString('_gameHistory', gamesStr);
  }

  static void removeGame(DateTime ts) {
    List games = getGames();
    List newGames = [];
    for (Map g in games) {
      if (!Constants.dateFormat.parse(g['startTime']).isAtSameMomentAs(ts)) {
        newGames.add(g);
      }
    }
    String gamesStr = json.encode(newGames);
    _prefsInstance?.setString('_gameHistory', gamesStr);
  }

}
