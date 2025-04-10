import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {
      'title': 'Recipe Creation',
      'description': 'Create and save your favorite recipes',
      'icon': FontAwesomeIcons.pencilAlt,
      'route': '/recipeEdit',
    },
    {
      'title': 'Recipe Management',
      'description': 'Organize and edit your recipe collection',
      'icon': FontAwesomeIcons.book,
      'route': '/recipeManagement',
    },
    {
      'title': 'Recipe Execution',
      'description': 'Follow step-by-step cooking instructions',
      'icon': FontAwesomeIcons.playCircle,
      'route': '/recipeExecution',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/a.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Recipe Master',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your personal cooking companion',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 1,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: features.map((feature) {
                    return Card(
                      color: Colors.amber[50],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.amber.withOpacity(0.2),
                              child: FaIcon(
                                feature['icon'],
                                size: 30,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              feature['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              feature['description'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                minimumSize: const Size(double.infinity, 36),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, feature['route']);
                              },
                              child: const Text('Get Started'),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
