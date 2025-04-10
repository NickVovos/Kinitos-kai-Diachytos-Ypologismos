class RecipeModel {
  final int id;
  final String name;
  final String description;
  final List<String> images;
  final List<RecipeStep> steps;

  RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.steps,
  });
}

class RecipeStep {
  final String title;
  final String description;
  final int duration;
  final List<String> images;
  final List<StepIngredient> ingredients;

  RecipeStep({
    required this.title,
    required this.description,
    required this.duration,
    required this.images,
    required this.ingredients,
  });
}

class StepIngredient {
  final String name;
  final String quantity;

  StepIngredient({required this.name, required this.quantity});
}
