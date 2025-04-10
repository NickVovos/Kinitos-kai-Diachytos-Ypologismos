import 'package:flutter/material.dart';
import 'package:recipemanagement/models/recipe_model.dart';
import 'step_execution_page.dart';

class RecipeExecutionPage extends StatefulWidget {
  @override
  _RecipeExecutionPageState createState() => _RecipeExecutionPageState();
}

class _RecipeExecutionPageState extends State<RecipeExecutionPage> {
  List<RecipeModel> allRecipes = []; // Populate from your data source
  RecipeModel? selectedRecipe;

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  void loadRecipes() {
    // Replace this with your DB/API call
    setState(() {
      allRecipes = [
        RecipeModel(
          id: 1,
          name: 'Spaghetti Carbonara',
          description: 'Creamy pasta with pancetta',
          images: ['assets/images/carbonara1.jpg', 'assets/images/carbonara2.jpg'],
          steps: [],
        ),
        RecipeModel(
          id: 2,
          name: 'Greek Salad',
          description: 'Fresh veggies with feta',
          images: ['assets/images/salad.jpg'],
          steps: [],
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipe Execution")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Recipe Execution',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Dropdown
              DropdownButton<RecipeModel>(
                value: selectedRecipe,
                hint: const Text('Select a Recipe'),
                items: allRecipes
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text('${r.name} - ${r.description}'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedRecipe = value);
                },
              ),
              const SizedBox(height: 20),

              if (selectedRecipe != null && selectedRecipe!.images.isNotEmpty)
                SizedBox(
                  height: 250,
                  child: PageView(
                    children: selectedRecipe!.images
                        .map((img) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  img,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),

              if (selectedRecipe != null)
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StepExecutionPage(recipe: selectedRecipe!),
                        ),
                      );
                    },
                    child: const Text("Begin Recipe"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
