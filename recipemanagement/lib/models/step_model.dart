import 'ingredient_model.dart';
import 'dart:typed_data';

class StepModel {
  String title;
  String description;
  int duration;
  List<IngredientModel> ingredients;
  List<Uint8List>? images;

  StepModel({
    required this.title,
    required this.description,
    required this.duration,
    required this.ingredients,
    this.images,
  });
}
