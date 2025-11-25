import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/meal_summary.dart';
import '../services/meal_api_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final MealCategory category;

  const MealsByCategoryScreen({super.key, required this.category});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final MealApiService _apiService = MealApiService();
  final TextEditingController _searchController = TextEditingController();

  List<MealSummary> _meals = [];
  List<MealSummary> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMeals();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchMeals() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _isSearching = false;
    });

    try {
      final meals = await _apiService.fetchMealsByCategory(
        widget.category.name,
      );
      setState(() {
        _meals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _searchMeals(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      final results = await _apiService.searchMealsInCategory(
        widget.category.name,
        query,
      );
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
      });
    } else {
      _searchMeals(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final displayMeals = _isSearching ? _searchResults : _meals;

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: Column(
        children: [
          Hero(
            tag: 'category-image-${category.id}',
            child: Container(
              margin: const EdgeInsets.all(16),
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: NetworkImage(category.thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search meals in this category...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildBody(displayMeals)),
        ],
      ),
    );
  }

  Widget _buildBody(List<MealSummary> displayMeals) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error: $_error', textAlign: TextAlign.center),
        ),
      );
    }

    if (displayMeals.isEmpty) {
      return const Center(child: Text('No meals found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: displayMeals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final meal = displayMeals[index];
        return MealGridItem(
          meal: meal,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MealDetailScreen(mealId: meal.id),
              ),
            );
          },
        );
      },
    );
  }
}
