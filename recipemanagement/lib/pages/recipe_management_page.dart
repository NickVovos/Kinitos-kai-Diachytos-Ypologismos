import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/recipe_api_service.dart';

class RecipeManagementPage extends StatefulWidget {
  @override
  _RecipeManagementPageState createState() => _RecipeManagementPageState();
}

class _RecipeManagementPageState extends State<RecipeManagementPage> {
  List<RecipeModel> recipes = [];
  String searchTerm = '';
  String selectedCategory = 'All';
  RecipeModel? recipeToDelete;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final api = RecipeApiService();
    final data = await api.getAllRecipes();

    if (!mounted) return;

    setState(() {
      recipes = data;
    });
  }

  Future<void> deleteRecipe() async {
    if (recipeToDelete == null) return;

    final api = RecipeApiService();
    final success = await api.deleteRecipe(recipeToDelete!.id);

    if (success) {
      setState(() {
        recipes.removeWhere((r) => r.id == recipeToDelete!.id);
        recipeToDelete = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete recipe')),
      );
    }
  }

  void cancelDelete() {
    setState(() => recipeToDelete = null);
  }

  void executeRecipe(RecipeModel recipe) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Executing ${recipe.name}')));
  }

  void editRecipe(RecipeModel recipe) {
    Navigator.pushNamed(
      context,
      '/recipeEdit',
      arguments: recipe.id, // Passing only the ID
    );
  }

  List<String> get categoryOptions {
    final categories = recipes.map((r) => r.name).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  List<RecipeModel> get filteredRecipes {
    return recipes.where((r) {
      final matchesSearch = searchTerm.isEmpty ||
          r.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
          r.description.toLowerCase().contains(searchTerm.toLowerCase());

      final matchesCategory = selectedCategory == 'All' || r.name == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Recipe Management Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage, search, and organize your favorite recipes seamlessly.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search recipes...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => searchTerm = value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Name',
                      border: OutlineInputBorder(),
                    ),
                    items: categoryOptions
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedCategory = value ?? 'All'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(recipe.name),
                      subtitle: Text(recipe.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => executeRecipe(recipe),
                            child: const Text('Execute'),
                          ),
                          TextButton(
                            onPressed: () => editRecipe(recipe),
                            child: const Text('Edit'),
                          ),
                          TextButton(
                            onPressed: () => setState(() => recipeToDelete = recipe),
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (recipeToDelete != null)
              AlertDialog(
                title: const Text('Delete Recipe'),
                content: Text('Are you sure you want to delete "${recipeToDelete!.name}"? This action cannot be undone.'),
                actions: [
                  TextButton(onPressed: cancelDelete, child: const Text('Cancel')),
                  TextButton(onPressed: deleteRecipe, child: const Text('Delete', style: TextStyle(color: Colors.red))),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
