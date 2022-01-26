import 'dart:convert';

import 'package:flutter/material.dart';
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

  /*
  {date: DateTime, buyin: buyin, cashedOut, cashedOut, duration, duration
   */

  static List getGames() {
    String gamesStr = _prefsInstance?.getString('_games') ?? '[]';
    List games = json.decode(gamesStr);
    print('# of games: ${games.length}');
    return games;
  }

  static void addGame(Map game) {
    print('adding');
    List games = getGames();
    games.add(game);
    String gamesStr = json.encode(games);
    _prefsInstance?.setString('_games', gamesStr);
  }

  // static void removeGame(DateTime ts) {
  //   List games = getGames();
  //   List newGames = []
  //   for (Games g: games) {
  //     if
  //   }
  // }

}