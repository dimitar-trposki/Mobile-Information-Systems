import 'package:flutter/material.dart';

import '../models/category.dart';
import '../services/meal_api_service.dart';
import '../widgets/category_card.dart';
import 'meals_by_category_screen.dart';
import 'meal_detail_screen.dart';
import '../models/meal_detail.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final MealApiService _apiService = MealApiService();
  final TextEditingController _searchController = TextEditingController();

  List<MealCategory> _allCategories = [];
  List<MealCategory> _filteredCategories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final categories = await _apiService.fetchCategories();
      setState(() {
        _allCategories = categories;
        _filteredCategories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredCategories = _allCategories;
      });
    } else {
      setState(() {
        _filteredCategories = _allCategories
            .where((c) => c.name.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  Future<void> _openRandomMeal() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final MealDetail randomMeal = await _apiService.fetchRandomMeal();
      if (!mounted) return;
      Navigator.of(context).pop();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MealDetailScreen(
            mealId: randomMeal.id,
            preloadedMeal: randomMeal,
            isRandomOfTheDay: true,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load random meal: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: const Text('Meal Explorer'),
        actions: [
          TextButton.icon(
            onPressed: _openRandomMeal,
            icon: const Icon(Icons.casino),
            label: const Text('Random'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchCategories,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search categories...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
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

    if (_filteredCategories.isEmpty) {
      return const Center(child: Text('No categories found'));
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
        return CategoryCard(
          category: category,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MealsByCategoryScreen(category: category),
              ),
            );
          },
        );
      },
    );
  }
}
