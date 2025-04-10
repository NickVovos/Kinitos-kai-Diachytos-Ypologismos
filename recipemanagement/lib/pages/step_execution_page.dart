import 'package:flutter/material.dart';
import 'package:recipemanagement/models/recipe_model.dart';

class StepExecutionPage extends StatefulWidget {
  final RecipeModel recipe;

  const StepExecutionPage({Key? key, required this.recipe}) : super(key: key);

  @override
  _StepExecutionPageState createState() => _StepExecutionPageState();
}

class _StepExecutionPageState extends State<StepExecutionPage> {
  int currentStepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final steps = widget.recipe.steps;
    final currentStep = steps.isNotEmpty ? steps[currentStepIndex] : null;

final stepProgress = steps.isNotEmpty
    ? ((currentStepIndex + 1) / steps.length).toDouble()
    : 0.0;

final durationProgress = steps.isNotEmpty
    ? (steps.sublist(0, currentStepIndex + 1).fold<int>(0, (sum, s) => sum + s.duration) /
        steps.fold<int>(0, (sum, s) => sum + s.duration)).toDouble()
    : 0.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Execution')),
      body: Center(
        child: steps.isEmpty
            ? const Text('No steps found.')
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      '${(stepProgress * 100).round()}% Complete (Steps)',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    LinearProgressIndicator(value: stepProgress, color: Colors.amber),
                    const SizedBox(height: 10),
                    Text(
                      '${(durationProgress * 100).round()}% Complete (Duration)',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    LinearProgressIndicator(value: durationProgress, color: Colors.amber),
                    const SizedBox(height: 20),

                    // Step Title
                    Text(
                      currentStep!.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    if (currentStep.images!.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: PageView(
                          children: currentStep.images
                              !.map((img) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(img as String, fit: BoxFit.cover),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        currentStep.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                    if (currentStep.ingredients.isNotEmpty)
                      Column(
                        children: [
                          const Text(
                            'Ingredients for this step:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          ...currentStep.ingredients.map((i) => Text('${i.name} - ${i.quantity}')),
                        ],
                      ),

                    const SizedBox(height: 16),
                    Text('Duration: ${currentStep.duration} minutes',
                        style: const TextStyle(color: Colors.grey)),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: currentStepIndex > 0
                              ? () => setState(() => currentStepIndex--)
                              : null,
                          child: const Text('← Previous'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        ),
                        ElevatedButton(
                          onPressed: currentStepIndex < steps.length - 1
                              ? () => setState(() => currentStepIndex++)
                              : null,
                          child: const Text('Next →'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
