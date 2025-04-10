import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/recipe_edit_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(), // Home is specified here
      routes: {
        '/recipeEdit': (context) => RecipeEditPage(),
        // You can add other routes like:
        // '/recipeManagement': (context) => RecipeManagementPage(),
        // '/recipeExecution': (context) => RecipeExecutionPage(),
      },
    );
  }
}
