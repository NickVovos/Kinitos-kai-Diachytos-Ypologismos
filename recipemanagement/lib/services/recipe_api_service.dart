import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class RecipeApiService {
  static const String _baseUrl = 'https://20250406recipesapi.azurewebsites.net/api/Recipe';

  /// Fetch all recipes from the API
  Future<List<RecipeModel>> getAllRecipes() async {
    final uri = Uri.parse(_baseUrl);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) {
        return RecipeModel(
          id:  json['id'] ?? 0,
          name: json['name']?.toString() ?? 'Untitled',
          description: json['description']?.toString() ?? '',
          images: [],
          steps: [],
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch recipes: ${response.statusCode}');
    }
  }

  /// Delete a recipe by its ID
  Future<bool> deleteRecipe(int id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final response = await http.delete(uri);

    return response.statusCode == 200 || response.statusCode == 204;
  }

  /// Create a recipe (already implemented earlier)
  Future<bool> createRecipe(Map<String, dynamic> json) async {
    final uri = Uri.parse(_baseUrl);

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(json),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
