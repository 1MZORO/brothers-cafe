import 'package:hive_flutter/hive_flutter.dart';
import '../../../menu/data/models/menu_item.dart';

class FavoritesRepository {
  static const String _boxName = 'favorites';
  Box<MenuItem>? _favoritesBox;

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _favoritesBox = await Hive.openBox<MenuItem>(_boxName);
    } else {
      _favoritesBox = Hive.box<MenuItem>(_boxName);
    }
  }

  Future<List<MenuItem>> getFavorites() async {
    await _ensureBoxOpen();
    return _favoritesBox!.values.toList();
  }

  Future<void> addFavorite(MenuItem item) async {
    await _ensureBoxOpen();
    await _favoritesBox!.put(item.id, item);
  }

  Future<void> removeFavorite(String itemId) async {
    await _ensureBoxOpen();
    await _favoritesBox!.delete(itemId);
  }

  Future<bool> isFavorite(String itemId) async {
    await _ensureBoxOpen();
    return _favoritesBox!.containsKey(itemId);
  }

  Future<void> clearFavorites() async {
    await _ensureBoxOpen();
    await _favoritesBox!.clear();
  }

  Future<void> _ensureBoxOpen() async {
    if (_favoritesBox == null || !_favoritesBox!.isOpen) {
      await init();
    }
  }

  void dispose() {
    _favoritesBox?.close();
  }
}
