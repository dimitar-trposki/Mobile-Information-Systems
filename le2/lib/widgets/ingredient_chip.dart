import 'package:flutter/material.dart';
import '../models/meal_detail.dart';

class IngredientChip extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientChip({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ingredient.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            ingredient.measure,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
