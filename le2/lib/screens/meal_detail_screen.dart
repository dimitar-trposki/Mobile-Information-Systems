import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/meal_detail.dart';
import '../services/meal_api_service.dart';
import '../widgets/ingredient_chip.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final MealDetail? preloadedMeal;
  final bool isRandomOfTheDay;

  const MealDetailScreen({
    super.key,
    required this.mealId,
    this.preloadedMeal,
    this.isRandomOfTheDay = false,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApiService _apiService = MealApiService();

  MealDetail? _meal;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedMeal != null) {
      _meal = widget.preloadedMeal;
      _isLoading = false;
    } else {
      _fetchMealDetail();
    }
  }

  Future<void> _fetchMealDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final meal = await _apiService.fetchMealDetail(widget.mealId);
      setState(() {
        _meal = meal;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _openYoutube() async {
    final url = _meal?.youtubeUrl;
    if (url == null || url.isEmpty) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch YouTube link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isRandomOfTheDay ? 'Recipe of the day' : 'Recipe';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _buildBody(),
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
          child: Text('Error: $_error'),
        ),
      );
    }

    final meal = _meal!;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: 'meal-image-${meal.id}',
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(meal.thumbnail, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              meal.name,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${meal.category} • ${meal.area}',
              style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
          ),
          const SizedBox(height: 12),
          if (meal.youtubeUrl != null && meal.youtubeUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                onPressed: _openYoutube,
                icon: const Icon(Icons.play_circle_fill),
                label: const Text('Watch on YouTube'),
              ),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Ingredients',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: meal.ingredients
                  .map((ing) => IngredientChip(ingredient: ing))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Instructions',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              meal.instructions,
              style: textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
