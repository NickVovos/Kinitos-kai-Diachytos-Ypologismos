import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipemanagement/models/recipe_image.dart';
import 'package:recipemanagement/widgets/ingredient_form_widget.dart';
import '../models/step_model.dart';
import '../models/ingredient_model.dart';

class StepFormWidget extends StatefulWidget {
  final StepModel step;
  final int index;
  final VoidCallback onRemove;

  const StepFormWidget({
    Key? key,
    required this.step,
    required this.index,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<StepFormWidget> createState() => _StepFormWidgetState();
}

class _StepFormWidgetState extends State<StepFormWidget> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();

  List<XFile> stepImages = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.step.title;
    descriptionController.text = widget.step.description;
    durationController.text = widget.step.duration.toString();
  }

  void addIngredient() {
    setState(() {
      widget.step.ingredients.add(IngredientModel(name: '', quantity: ''));
    });
  }

  void removeIngredient(int index) {
    setState(() {
      widget.step.ingredients.removeAt(index);
    });
  }

  Future<void> pickStepImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    for (final file in picked) {
      final bytes = await file.readAsBytes();
      final base64Data = base64Encode(bytes);

      widget.step.images.add(
        RecipeImage(
          id: 0,
          name: file.name,
          data: base64Data,
        ),
      );
    }

    setState(() {}); // Refresh UI
    }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step ${widget.index + 1}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Step Title'),
              onChanged: (val) => widget.step.title = val,
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: (val) => widget.step.description = val,
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              onChanged: (val) =>
                  widget.step.duration = int.tryParse(val) ?? 0,
            ),
            const SizedBox(height: 12),

            const Text('Ingredients',
                style: TextStyle(fontWeight: FontWeight.w600)),
            ...widget.step.ingredients.asMap().entries.map((entry) {
              final i = entry.key;
              final ingredient = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: IngredientFormWidget(
                  ingredient: ingredient,
                  onRemove: () => removeIngredient(i),
                  onNameChanged: (val) => ingredient.name = val,
                  onQuantityChanged: (val) => ingredient.quantity = val,
                ),
              );
            }),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: addIngredient,
                icon: const Icon(Icons.add),
                label: const Text('Add Ingredient'),
              ),
            ),

            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Upload Step Images'),
              onPressed: pickStepImages,
            ),

            // ✅ Show images from widget.step.images (already base64)
            if (widget.step.images.isNotEmpty)
              Wrap(
                spacing: 8,
                children: widget.step.images.map((img) {
                  try {
                    return Image.memory(
                      base64Decode(img.data),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  } catch (_) {
                    return const Icon(Icons.broken_image);
                  }
                }).toList(),
              ),

            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete),
                label: const Text('Remove Step'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
