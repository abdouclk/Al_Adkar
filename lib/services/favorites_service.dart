import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dhikr_item.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites_dhikr';
  static FavoritesService? _instance;
  SharedPreferences? _prefs;

  FavoritesService._();

  static Future<FavoritesService> getInstance() async {
    if (_instance == null) {
      _instance = FavoritesService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get all favorites
  Future<List<DhikrItem>> getFavorites() async {
    final String? favoritesJson = _prefs?.getString(_favoritesKey);
    if (favoritesJson == null || favoritesJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = json.decode(favoritesJson);
      return decoded.map((item) => DhikrItem.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // Save favorites
  Future<void> _saveFavorites(List<DhikrItem> favorites) async {
    final String encoded = json.encode(
      favorites.map((item) => item.toJson()).toList(),
    );
    await _prefs?.setString(_favoritesKey, encoded);
  }

  // Add to favorites
  Future<void> addFavorite(DhikrItem item) async {
    final favorites = await getFavorites();

    // Check if already exists
    if (!favorites.any((fav) => fav.id == item.id)) {
      favorites.add(item);
      await _saveFavorites(favorites);
    }
  }

  // Remove from favorites
  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item.id == id);
    await _saveFavorites(favorites);
  }

  // Check if item is favorite
  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item.id == id);
  }

  // Toggle favorite
  Future<bool> toggleFavorite(DhikrItem item) async {
    final isFav = await isFavorite(item.id);
    if (isFav) {
      await removeFavorite(item.id);
      return false;
    } else {
      await addFavorite(item);
      return true;
    }
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    await _prefs?.remove(_favoritesKey);
  }
}
