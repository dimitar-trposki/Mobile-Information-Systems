class Ingredient {
  final String name;
  final String measure;

  Ingredient({required this.name, required this.measure});
}

class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String thumbnail;
  final String instructions;
  final String? youtubeUrl;
  final List<Ingredient> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.thumbnail,
    required this.instructions,
    required this.ingredients,
    this.youtubeUrl,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final List<Ingredient> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'];
      final meas = json['strMeasure$i'];
      if (ing != null &&
          ing.toString().trim().isNotEmpty &&
          ing.toString().trim() != 'null') {
        ingredients.add(
          Ingredient(
            name: ing.toString().trim(),
            measure: (meas ?? '').toString().trim(),
          ),
        );
      }
    }

    return MealDetail(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      thumbnail: json['strMealThumb'] as String,
      instructions: json['strInstructions'] ?? '',
      youtubeUrl: json['strYoutube'],
      ingredients: ingredients,
    );
  }
}
