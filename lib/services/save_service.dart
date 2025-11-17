import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

/// Handles saving and loading game state
class SaveService {
  static const String _saveKey = 'game_save_v1';

  /// Save game state to local storage
  Future<bool> saveGame(GameState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.toJson());
      return await prefs.setString(_saveKey, jsonString);
    } catch (e) {
      print('Error saving game: $e');
      return false;
    }
  }

  /// Load game state from local storage
  Future<GameState?> loadGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_saveKey);

      if (jsonString == null) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final state = GameState();
      state.fromJson(json);
      return state;
    } catch (e) {
      print('Error loading game: $e');
      return null;
    }
  }

  /// Check if save exists
  Future<bool> hasSave() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_saveKey);
    } catch (e) {
      return false;
    }
  }

  /// Delete save
  Future<bool> deleteSave() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_saveKey);
    } catch (e) {
      print('Error deleting save: $e');
      return false;
    }
  }
}
