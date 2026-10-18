import 'package:flutter/material.dart';
import '../models/perfume_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<PerfumeModel> _favorites = [];

  List<PerfumeModel> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String id) => _favorites.any((p) => p.id == id);

  void toggle(PerfumeModel perfume) {
    if (isFavorite(perfume.id)) {
      _favorites.removeWhere((p) => p.id == perfume.id);
    } else {
      _favorites.add(perfume);
    }
    notifyListeners();
  }
}