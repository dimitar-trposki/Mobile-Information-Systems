import 'package:flutter/foundation.dart';
import '../models/meal_summary.dart';

class FavoritesService {
  FavoritesService._internal();

  static final FavoritesService _instance = FavoritesService._internal();

  factory FavoritesService() => _instance;

  final ValueNotifier<List<MealSummary>> favorites =
      ValueNotifier<List<MealSummary>>([]);

  bool isFavorite(MealSummary meal) {
    return favorites.value.any((m) => m.id == meal.id);
  }

  void toggleFavorite(MealSummary meal) {
    final current = List<MealSummary>.from(favorites.value);

    final index = current.indexWhere((m) => m.id == meal.id);
    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(meal);
    }

    favorites.value = current;
  }
}
