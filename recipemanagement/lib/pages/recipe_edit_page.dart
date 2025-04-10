import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/step_model.dart';
import '../models/recipe_model.dart';
import '../widgets/step_form_widget.dart';
import '../services/recipe_api_service.dart';

class RecipeEditPage extends StatefulWidget {
  @override
  _RecipeEditPageState createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<String> categories = ['Breakfast', 'Lunch', 'Dinner', 'Dessert'];
  String selectedCategory='Breakfast';
  String? selectedDifficulty;

  List<StepModel> steps = [];
  List<XFile> recipeImages = [];

  bool isLoading = true;
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        _fetchRecipeById(args); // Load recipe only if ID is provided
      } else {
        setState(() {
          isLoading = false; // Just show empty form
        });
      }
      isInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Recipe')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Recipe Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Category'),
                      items:
                          categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ),
                              )
                              .toList(),
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      validator:
                          (value) =>
                              value == null ? 'Please select a category' : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Difficulty',
                      ),
                      items:
                          ['Easy', 'Medium', 'Difficult']
                              .map(
                                (d) =>
                                    DropdownMenuItem(value: d, child: Text(d)),
                              )
                              .toList(),
                      value: selectedDifficulty,
                      onChanged:
                          (value) => setState(() => selectedDifficulty = value),
                      validator:
                          (value) =>
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
                      children:
                          recipeImages.map((img) {
                            return FutureBuilder<Uint8List>(
                              future: img.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return Image.memory(
                                    snapshot.data!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return const SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            );
                          }).toList(),
                    ),

                    const Divider(height: 32),
                    const Text(
                      'Steps',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...steps.asMap().entries.map((entry) {
                      final i = entry.key;
                      final step = entry.value;
                      return StepFormWidget(
                        step: step,
                        index: i,
                        onRemove: () => setState(() => steps.removeAt(i)),
                      );
                    }),

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
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Submit Recipe'),
                    ),
                  ],
                ),
              ),
    );
  }

  Future<void> _fetchRecipeById(int id) async {
    final api = RecipeApiService();
    final recipe = await api.getRecipeById(id);
    if (!mounted) return;
    setState(() {
      _populateFields(recipe);
      isLoading = false;
    });
  }

  void _populateFields(RecipeModel recipe) {
    titleController.text = recipe.name;
    descriptionController.text = recipe.description;
    selectedCategory = recipe.categoryName;
    selectedDifficulty = _intToDifficulty(recipe.difficulty);

    if (!categories.contains(recipe.categoryName)) {
      categories.add(recipe.categoryName);
    }

    recipeImages =
        recipe.images.map((img) {
          final bytes = base64Decode(img.data);
          return XFile.fromData(bytes, name: img.name);
        }).toList();

    steps =
        recipe.steps.map((s) {
          return StepModel(
            id: s.id,
            title: s.title,
            description: s.description,
            duration: s.duration,
            order: s.order,
            ingredients: s.ingredients,
            images: s.images,
          );
        }).toList();
  }

  int _difficultyToInt(String? difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 0;
      case 'Medium':
        return 1;
      case 'Difficult':
        return 2;
      default:
        return 0;
    }
  }

  String _intToDifficulty(int difficulty) {
    switch (difficulty) {
      case 0:
        return 'Easy';
      case 1:
        return 'Medium';
      case 2:
        return 'Difficult';
      default:
        return 'Easy';
    }
  }

  void addStep() {
    setState(() {
      steps.add(
        StepModel(
          id: 0,
          order: steps.length + 1,
          title: '',
          description: '',
          duration: 0,
          ingredients: [],
          images: [],
        ),
      );
    });
  }

  Future<void> pickRecipeImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    setState(() {
      recipeImages.addAll(pickedImages);
    });
    }

  Future<void> submitRecipe() async {
    if (_formKey.currentState!.validate()) {
      final api = RecipeApiService();

      // ✅ Convert recipe images
      final List<Map<String, dynamic>> encodedRecipeImages = [];
      for (var file in recipeImages) {
        final bytes = await file.readAsBytes();
        final base64Data = base64Encode(bytes);
        encodedRecipeImages.add({
          "id": 0,
          "name": file.name,
          "data": base64Data,
        });
      }

      // ✅ Convert full recipe with step images
      final recipeJson = {
        "name": titleController.text,
        "description": descriptionController.text,
        "categoryName": "Appetizer",
        "difficulty": _difficultyToInt(selectedDifficulty),
        "steps": await Future.wait(
          steps.asMap().entries.map((entry) async {
            final i = entry.key;
            final s = entry.value;

            final List<Map<String, dynamic>> encodedStepImages =
                s.images.map((img) {
                  return {
                    "id": img.id,
                    "name": img.name,
                    "data": img.data, // already base64
                  };
                }).toList();

            return {
              "id": s.id,
              "title": s.title,
              "description": s.description,
              "order": i + 1,
              "duration": s.duration,
              "ingredients":
                  s.ingredients
                      .map((i) => {"quantity": i.quantity, "name": i.name})
                      .toList(),
              "images": encodedStepImages,
            };
          }).toList(),
        ),
        "images": encodedRecipeImages,
        "categories": null,
      };

      final success = await api.createRecipe(recipeJson);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Recipe submitted successfully!'
                : 'Failed to submit recipe.',
          ),
        ),
      );

      if (success) {
        Navigator.pop(context);
      }
    }
  }
}
