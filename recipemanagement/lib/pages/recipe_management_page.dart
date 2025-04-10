import 'package:flutter/material.dart';

class Recipe {
  final int id;
  final String name;
  final String category;
  final String description;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
  });
}

class RecipeManagementPage extends StatefulWidget {
  @override
  _RecipeManagementPageState createState() => _RecipeManagementPageState();
}

class _RecipeManagementPageState extends State<RecipeManagementPage> {
  List<Recipe> recipes = [
    Recipe(id: 1, name: 'Spaghetti Carbonara', category: 'Dinner', description: 'Classic Italian pasta dish'),
    Recipe(id: 2, name: 'Pancakes', category: 'Breakfast', description: 'Fluffy pancakes with syrup'),
    Recipe(id: 3, name: 'Greek Salad', category: 'Lunch', description: 'Fresh veggies and feta cheese'),
  ];

  String searchTerm = '';
  String selectedCategory = 'All';
  Recipe? recipeToDelete;

  List<String> get categoryOptions {
    final categories = recipes.map((r) => r.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  List<Recipe> get filteredRecipes {
    return recipes.where((r) {
      final matchesSearch = searchTerm.isEmpty ||
          r.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
          r.description.toLowerCase().contains(searchTerm.toLowerCase());

      final matchesCategory = selectedCategory == 'All' || r.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void confirmDelete(Recipe recipe) {
    setState(() {
      recipeToDelete = recipe;
    });
  }

  void deleteRecipe() {
    setState(() {
      recipes.removeWhere((r) => r.id == recipeToDelete!.id);
      recipeToDelete = null;
    });
  }

  void cancelDelete() {
    setState(() {
      recipeToDelete = null;
    });
  }

  void executeRecipe(Recipe recipe) {
    // Navigate to step execution page (stubbed)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Executing ${recipe.name}')));
  }

  void editRecipe(Recipe recipe) {
    Navigator.pushNamed(context, '/recipeEdit'); // You can pass recipe ID with arguments if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Heading
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

            // Search and Filter
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
                      labelText: 'Filter by Category',
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

            // Recipe List
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(recipe.name),
                      subtitle: Text('${recipe.category} • ${recipe.description}'),
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
                            onPressed: () => confirmDelete(recipe),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Delete Confirmation Modal
            if (recipeToDelete != null)
              AlertDialog(
                title: const Text('Delete Recipe'),
                content: Text(
                  'Are you sure you want to delete "${recipeToDelete!.name}"? This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: cancelDelete,
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: deleteRecipe,
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
