import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipemanagement/models/recipe_model.dart';
import 'package:recipemanagement/services/recipe_api_service.dart';
import 'step_execution_page.dart';

class RecipeExecutionPage extends StatefulWidget {
  @override
  _RecipeExecutionPageState createState() => _RecipeExecutionPageState();
}

class _RecipeExecutionPageState extends State<RecipeExecutionPage> {
  List<RecipeModel> allRecipes = [];
  RecipeModel? selectedRecipe;
  bool isLoading = false;
  bool isLoadingRecipe = false;

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    setState(() => isLoading = true);
    final api = RecipeApiService();

    try {
      final recipes = await api.getAllRecipes();
      setState(() {
        allRecipes = recipes;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading recipes: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> beginRecipe() async {
    if (selectedRecipe == null) return;

    setState(() => isLoadingRecipe = true);
    final api = RecipeApiService();

    try {
      final fullRecipe = await api.getRecipeById(selectedRecipe!.id);

      setState(() => isLoadingRecipe = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StepExecutionPage(recipe: fullRecipe),
        ),
      );
    } catch (e) {
      print('Error fetching full recipe: $e');
      setState(() => isLoadingRecipe = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load recipe details")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipe Execution")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Recipe Execution',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    DropdownButton<RecipeModel>(
                      value: selectedRecipe,
                      hint: const Text('Select a Recipe'),
                      items: allRecipes
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
                              child: Text('${r.name} - ${r.description}'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedRecipe = value);
                      },
                    ),
                    const SizedBox(height: 20),

                    if (selectedRecipe != null &&
                        selectedRecipe!.images.isNotEmpty)
                      SizedBox(
                        height: 250,
                        child: PageView(
                          children: selectedRecipe!.images.map((img) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  base64Decode(img.data),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 80),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    if (selectedRecipe != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                          onPressed: isLoadingRecipe ? null : beginRecipe,
                          child: isLoadingRecipe
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text("Begin Recipe"),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
