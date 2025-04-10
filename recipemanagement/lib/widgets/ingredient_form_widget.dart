import 'package:flutter/material.dart';
import '../models/ingredient_model.dart';

class IngredientFormWidget extends StatelessWidget {
  final IngredientModel ingredient;
  final VoidCallback onRemove;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onQuantityChanged;

  const IngredientFormWidget({
    Key? key,
    required this.ingredient,
    required this.onRemove,
    required this.onNameChanged,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextFormField(
            initialValue: ingredient.name,
            decoration: const InputDecoration(hintText: 'Ingredient Name'),
            onChanged: onNameChanged,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: TextFormField(
            initialValue: ingredient.quantity,
            decoration: const InputDecoration(hintText: 'Quantity'),
            onChanged: onQuantityChanged,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
