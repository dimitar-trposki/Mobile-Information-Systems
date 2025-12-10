import 'package:flutter/material.dart';

import '../services/favorites_service.dart';
import '../widgets/meal_grid_item.dart';
import '../models/meal_summary.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesService = FavoritesService();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite recipes')),
      body: ValueListenableBuilder<List<MealSummary>>(
        valueListenable: favoritesService.favorites,
        builder: (context, favorites, _) {
          if (favorites.isEmpty) {
            return const Center(child: Text('No favorite recipes yet'));
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: favorites.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final meal = favorites[index];
              return MealGridItem(
                meal: meal,
                isFavorite: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MealDetailScreen(mealId: meal.id),
                    ),
                  );
                },
                onToggleFavorite: () {
                  favoritesService.toggleFavorite(meal);
                },
              );
            },
          );
        },
      ),
    );
  }
}
