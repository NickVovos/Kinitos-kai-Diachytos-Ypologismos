import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class RecipeApiService {
  static const String _baseUrl = 'http://localhost:5230/api/Recipe';
  static const String _baseUrlCat = 'http://localhost:5230/api/Category';

  // static const String _baseUrl =
  //     'https://20250406recipesapi.azurewebsites.net/api/Recipe';

  /// Fetch all recipes from the API
  Future<List<RecipeModel>> getAllRecipes() async {
    final uri = Uri.parse(_baseUrl);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) {
        return RecipeModel(
          id: json['id'] ?? 0,
          name: json['name']?.toString() ?? 'Untitled',
          description: json['description']?.toString() ?? '',
          images: [],
          steps: [],
          difficulty: 0,
          categoryName: json['categoryName']?.toString() ?? 'none',
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

  Future<RecipeModel> getRecipeById(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return RecipeModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load recipe with id $id');
    }
  }

  Future<bool> updateRecipe(int id, Map<String, dynamic> json) async {
    final url = Uri.parse('$_baseUrl/$id');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(json),
    );

    return response.statusCode == 200;
  }

  Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse(_baseUrlCat));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<String>((item) => item['name'].toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
