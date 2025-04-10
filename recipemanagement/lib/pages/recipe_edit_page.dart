import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/step_model.dart';
import '../models/ingredient_model.dart';
import '../widgets/step_form_widget.dart';

class RecipeEditPage extends StatefulWidget {
  @override
  _RecipeEditPageState createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<String> categories = ['Breakfast', 'Lunch', 'Dinner', 'Dessert'];
  String? selectedCategory;
  bool showNewCategoryInput = false;
  final TextEditingController newCategoryController = TextEditingController();

  String? selectedDifficulty;

  List<StepModel> steps = [];

  List<XFile> recipeImages = [];

  void addStep() {
    setState(() {
      steps.add(StepModel(
        title: '',
        description: '',
        duration: 0,
        ingredients: [],
      ));
    });
  }

  Future<void> pickRecipeImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        recipeImages.addAll(pickedImages);
      });
    }
  }

  void submitRecipe() {
    if (_formKey.currentState!.validate()) {
      // Submit logic here (e.g. save to DB or call API)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Recipe Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value!.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Category'),
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList()
                ..add(const DropdownMenuItem(
                    value: 'Other', child: Text('Other (Add New)'))),
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  showNewCategoryInput = value == 'Other';
                });
              },
            ),

            if (showNewCategoryInput)
              TextFormField(
                controller: newCategoryController,
                decoration: const InputDecoration(labelText: 'New Category'),
              ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Difficulty'),
              items: ['Easy', 'Medium', 'Difficult']
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              value: selectedDifficulty,
              onChanged: (value) => setState(() => selectedDifficulty = value),
              validator: (value) =>
                  value == null ? 'Please select difficulty' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Upload Recipe Images'),
              onPressed: pickRecipeImages,
            ),

            Wrap(
              spacing: 8,
              children: recipeImages
                  .map((img) => Image.file(
                        File(img.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
            ),
            const Divider(height: 32),
            const Text(
              'Steps',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ...steps
                .asMap()
                .entries
                .map((entry) => StepFormWidget(
                      step: entry.value,
                      index: entry.key,
                      onRemove: () {
                        setState(() => steps.removeAt(entry.key));
                      },
                    ))
                .toList(),

            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Step'),
              onPressed: addStep,
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: submitRecipe,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size.fromHeight(48)),
              child: const Text('Submit Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
