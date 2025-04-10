import 'package:flutter/material.dart';
import 'package:recipemanagement/pages/recipe_execution_page.dart';
import 'package:recipemanagement/pages/recipe_management_page.dart';
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
        '/recipeManagement': (context) => RecipeManagementPage(),
        '/recipeExecution': (context) => RecipeExecutionPage(),
      },
    );
  }
}
