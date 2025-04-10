import 'dart:typed_data';

import 'package:recipemanagement/models/step_model.dart';

class RecipeViewModel {
  int? id;
  String name;
  String categoryName;
  String difficulty;
  String description;
  List<StepModel> steps;
  List<Uint8List>? images;
  List<String> categories;

  RecipeViewModel({
    this.id,
    required this.name,
    required this.categoryName,
    required this.difficulty,
    required this.description,
    required this.steps,
    this.images,
    required this.categories,
  });
}
