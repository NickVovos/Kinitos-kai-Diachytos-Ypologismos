import 'package:recipemanagement/models/recipe_image.dart';
import 'package:recipemanagement/models/step_model.dart';

class RecipeModel {
  final int id;
  final String name;
  final String description;
  final List<RecipeImage> images;
  final List<StepModel> steps;
  final String categoryName;
  final int difficulty;

  RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.steps,
    required this.categoryName,
    required this.difficulty,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryName: json['categoryName'], // ✅ correct key
      difficulty: json['difficulty'],
      images: (json['images'] as List<dynamic>?)
              ?.map((img) => RecipeImage.fromJson(img))
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((step) => StepModel.fromJson(step))
              .toList() ??
          [],
    );
  }
}
