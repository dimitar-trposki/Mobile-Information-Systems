import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';

class MealApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<MealCategory>> fetchCategories() async {
    final uri = Uri.parse('$_baseUrl/categories.php');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List categories = data['categories'] ?? [];

    return categories
        .map((json) => MealCategory.fromJson(json))
        .toList()
        .cast<MealCategory>();
  }

  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final uri = Uri.parse('$_baseUrl/filter.php?c=$category');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load meals');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List meals = data['meals'] ?? [];

    return meals
        .map((json) => MealSummary.fromJson(json))
        .toList()
        .cast<MealSummary>();
  }

  Future<List<MealSummary>> searchMealsInCategory(
    String category,
    String query,
  ) async {
    final uri = Uri.parse('$_baseUrl/search.php?s=$query');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to search meals');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List? meals = data['meals'] as List?;
    if (meals == null) {
      return [];
    }

    final filtered = meals.where((json) {
      final cat = (json['strCategory'] ?? '') as String;
      return cat.toLowerCase() == category.toLowerCase();
    }).toList();

    return filtered
        .map(
          (json) => MealSummary(
            id: json['idMeal'],
            name: json['strMeal'],
            thumbnail: json['strMealThumb'],
          ),
        )
        .toList();
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final uri = Uri.parse('$_baseUrl/lookup.php?i=$id');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load meal detail');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List meals = data['meals'] ?? [];

    if (meals.isEmpty) {
      throw Exception('Meal not found');
    }

    return MealDetail.fromJson(meals.first);
  }

  Future<MealDetail> fetchRandomMeal() async {
    final uri = Uri.parse('$_baseUrl/random.php');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load random meal');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List meals = data['meals'] ?? [];

    if (meals.isEmpty) {
      throw Exception('Random meal not found');
    }

    return MealDetail.fromJson(meals.first);
  }
}
