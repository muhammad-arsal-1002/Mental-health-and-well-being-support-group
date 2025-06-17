// lib/exercise_detail_screen.dart
import 'package:marsal/arsal/exercisemodel.dart';
import 'package:flutter/material.dart';
 // Import your Exercise model

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  final Color primaryColor = const Color(0xFF000080); // Navy Blue
  final Color backgroundColor = Colors.white; // Bright White
  final Color textColor = Colors.black; // For general text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.exercise.name, // Display the exercise name in the app bar
          style: TextStyle(color: backgroundColor),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: backgroundColor), // For back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Name (if not in AppBar, or for emphasis)
            Text(
              widget.exercise.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),

            // Description Section
            Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.exercise.description,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            // Steps Section
            Text(
              'How to do it:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            _buildStepsList(widget.exercise.steps),
            const SizedBox(height: 20),

            // Optional: Add a simple icon for visual appeal
            Center(
              child: Icon(
                Icons.fitness_center, // A generic fitness icon
                size: 80,
                color: primaryColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsList(List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.asMap().entries.map((entry) {
        int index = entry.key + 1; // Step number
        String step = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use a numbered icon or just text for the step number
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  step,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}