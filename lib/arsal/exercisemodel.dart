// lib/models/exercise.dart

class Exercise {
  final String name;
  final String description;
  final List<String> steps;

  Exercise({
    required this.name,
    required this.description,
    required this.steps,
  });
}