import 'ingredient_model.dart';
import 'recipe_image.dart';

class StepModel {
  int id;
  String title;
  String description;
  int duration;
  int order;
  List<IngredientModel> ingredients;
  List<RecipeImage> images;

  StepModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.order,
    required this.ingredients,
    required this.images,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      order: json['order'],
      ingredients:
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => IngredientModel.fromJson(e))
              .toList() ??
          [],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => RecipeImage.fromJson(e))
              .toList() ??
          [],
    );
  }
}
