import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    if (picked != null) {
      setState(() {
        stepImages.addAll(picked);
      });
    }
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        initialValue: ingredient.name,
                        decoration:
                            const InputDecoration(hintText: 'Name'),
                        onChanged: (val) => ingredient.name = val,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        initialValue: ingredient.quantity,
                        decoration:
                            const InputDecoration(hintText: 'Quantity'),
                        onChanged: (val) => ingredient.quantity = val,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => removeIngredient(i),
                    )
                  ],
                ),
              );
            }).toList(),
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
            Wrap(
              spacing: 8,
              children: stepImages
                  .map((img) => Image.file(
                        File(img.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
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
