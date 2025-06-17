// lib/exercises_screen.dart

import 'package:flutter/material.dart';
import 'package:marsal/arsal/exercisemodel.dart'; // Make sure this path is correct
import 'package:marsal/arsal/exercisedetail.dart';// Make sure this path is correct

// --- NEW THEME Color Constants: Bright White and Navy Blue ---
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or AI messages
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
const Color kErrorRed = Colors.redAccent; // Keeping red for errors

// --- Reusable Text Styles (Copied from Dashboard/Group Screen for consistency) ---
const String _kFontFamily = 'Inter'; // Define font family once

const TextStyle kBottomNavLabelStyle = TextStyle(
  fontSize: 12, // Adjusted to match Dashboard
  fontFamily: _kFontFamily,
);

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  // Use the same _currentBottomNavIndex logic as Dashboard/Group Screen
  // Exercises tab is index 2 in the bottom navigation bar
  int _currentBottomNavIndex = 2;

  // Define your exercises with full details
  final List<Exercise> depressionExercises = [
    Exercise(
      name: 'Mindfulness Meditation',
      description: 'Focuses on bringing awareness to the present moment, observing thoughts and feelings without judgment.',
      steps: [
        'Find a quiet place to sit comfortably.',
        'Close your eyes gently or soften your gaze.',
        'Bring attention to your breath, noticing the sensation of each inhale and exhale.',
        'When your mind wanders, gently bring your attention back to your breath.',
        'Continue for 5-10 minutes, gradually increasing duration.',
      ],
    ),
    Exercise(
      name: 'Aerobic Exercise (Brisk Walking)',
      description: 'Engaging in moderate-intensity physical activity to elevate heart rate and improve mood.',
      steps: [
        'Wear comfortable shoes and clothing.',
        'Start with a 5-minute warm-up of light walking.',
        'Increase your pace to a brisk walk where you can still talk but feel slightly breathless.',
        'Continue for 20-30 minutes.',
        'Cool down for 5 minutes with slower walking and gentle stretches.',
      ],
    ),
    Exercise(
      name: 'Yoga Poses for Mood',
      description: 'Specific yoga postures combined with breathwork to calm the nervous system and lift spirits.',
      steps: [
        'Start with gentle warm-ups like cat-cow stretches.',
        'Practice poses like Child\'s Pose (Balasana) for grounding.',
        'Incorporate gentle backbends like Cobra Pose (Bhujangasana) to open the chest.',
        'End with Savasana (Corpse Pose) for deep relaxation.',
        'Focus on deep, steady breaths throughout the practice.',
      ],
    ),
    Exercise(
      name: 'Journaling for Emotional Release',
      description: 'Writing down thoughts and feelings to gain clarity, process emotions, and reduce stress.',
      steps: [
        'Find a quiet time and space.',
        'Get a notebook and a pen (or use a digital tool).',
        'Start writing whatever comes to mind, without censoring yourself.',
        'Explore your feelings, daily events, or specific concerns.',
        'Don\'t worry about grammar or spelling; focus on expression.',
      ],
    ),
    Exercise(
      name: 'Nature Walks & Forest Bathing',
      description: 'Spending time in natural environments to reduce stress, improve mood, and enhance well-being.',
      steps: [
        'Choose a natural setting like a park, forest, or garden.',
        'Leave your phone on silent or at home.',
        'Walk slowly and mindfully, engaging your senses.',
        'Notice the sights, sounds, smells, and textures of nature.',
        'Find a spot to sit and observe for a few minutes.',
      ],
    ),
  ];

  final List<Exercise> anxietyExercises = [
    Exercise(
      name: 'Diaphragmatic Breathing',
      description: 'Deep breathing from the diaphragm to activate the parasympathetic nervous system, promoting relaxation.',
      steps: [
        'Lie on your back or sit comfortably.',
        'Place one hand on your chest and the other on your belly.',
        'Breathe in slowly through your nose, feeling your belly rise (chest should remain still).',
        'Exhale slowly through pursed lips, feeling your belly fall.',
        'Practice for 5-10 minutes, several times a day.',
      ],
    ),
    Exercise(
      name: 'Guided Imagery',
      description: 'Using visualization and imagination to create a sense of calm and escape from anxious thoughts.',
      steps: [
        'Find a comfortable, quiet place.',
        'Close your eyes and take a few deep breaths.',
        'Imagine a peaceful scene (e.g., a beach, forest, or cozy room).',
        'Engage all your senses in this imagined scene.',
        'Stay in this imagined space until you feel more relaxed.',
      ],
    ),
    Exercise(
      name: 'Tai Chi & Qigong',
      description: 'Ancient Chinese practices involving slow, flowing movements and deep breathing to balance energy and reduce tension.',
      steps: [
        'Find an open space.',
        'Follow introductory videos or classes for basic forms.',
        'Focus on smooth, continuous movements.',
        'Synchronize your movements with your breath.',
        'Practice regularly to build grace and inner calm.',
      ],
    ),
    Exercise(
      name: 'Acupressure Points for Calm',
      description: 'Applying pressure to specific points on the body to alleviate anxiety and promote relaxation.',
      steps: [
        'Locate the "Pericardium 6" (Neiguan) point: three finger widths below the wrist, between the two tendons.',
        'Apply firm, circular pressure for 2-3 minutes.',
        'Locate the "Union Valley" (Hegu) point: in the web between your thumb and index finger.',
        'Apply firm pressure to this point for 2-3 minutes.',
        'Breathe deeply while applying pressure.',
      ],
    ),
    Exercise(
      name: 'Sound Therapy/Music Listening',
      description: 'Using specific sounds or music to influence mood, reduce stress, and promote relaxation.',
      steps: [
        'Choose calming music, nature sounds, or binaural beats.',
        'Find a comfortable listening environment, preferably with headphones.',
        'Close your eyes and focus on the sounds.',
        'Allow the sounds to wash over you, letting go of tension.',
        'Listen for 15-30 minutes.',
      ],
    ),
  ];

  final List<Exercise> stressManagementExercises = [
    Exercise(
      name: 'Time Management Techniques',
      description: 'Structuring your time effectively to reduce feelings of overwhelm and increase productivity.',
      steps: [
        'Identify your priorities and tasks for the day/week.',
        'Break down large tasks into smaller, manageable steps.',
        'Use tools like planners, calendars, or apps.',
        'Allocate specific time blocks for tasks (e.g., Pomodoro Technique).',
        'Learn to say "no" to non-essential commitments.',
      ],
    ),
    Exercise(
      name: 'Boundaries Setting Practice',
      description: 'Establishing clear limits in relationships and commitments to protect your time, energy, and well-being.',
      steps: [
        'Identify areas where your boundaries are weak (e.g., work, family).',
        'Clearly define what you are and are not willing to do.',
        'Communicate your boundaries assertively but respectfully.',
        'Be prepared for initial resistance and stick to your limits.',
        'Practice setting small boundaries first and gradually increase.',
      ],
    ),
    Exercise(
      name: 'Gratitude Practice',
      description: 'Focusing on the positive aspects of life to shift perspective and reduce negative thought patterns.',
      steps: [
        'Daily, write down 3-5 things you are grateful for.',
        'Be specific (e.g., "the warm cup of coffee" instead of "coffee").',
        'Reflect on why you are grateful for each item.',
        'You can also keep a gratitude journal or simply reflect mentally.',
        'Do this consistently, especially when feeling stressed.',
      ],
    ),
    Exercise(
      name: 'Hobby Engagement',
      description: 'Actively participating in enjoyable activities outside of work or daily responsibilities to reduce stress and promote relaxation.',
      steps: [
        'Identify activities you genuinely enjoy or have always wanted to try.',
        'Schedule dedicated time for your hobby regularly.',
        'Immerse yourself fully in the activity; minimize distractions.',
        'Don\'t aim for perfection; focus on the process and enjoyment.',
        'Consider joining a group or class related to your hobby.',
      ],
    ),
    Exercise(
      name: 'Digital Detox Strategies',
      description: 'Intentionally reducing or eliminating screen time to reduce mental fatigue, improve sleep, and increase presence.',
      steps: [
        'Set specific times for checking emails/social media.',
        'Implement "no phone" zones (e.g., bedroom, dinner table).',
        'Turn off non-essential notifications.',
        'Replace screen time with other activities like reading, exercise, or hobbies.',
        'Consider a full digital detox day or weekend periodically.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrightWhite, // Consistent white background
      appBar: AppBar(
        title: const Text(
          'Expert Recommended Exercises',
          style: TextStyle(color: kNavyBlue, fontSize: 24, fontWeight: FontWeight.bold), // Consistent title style
        ),
        backgroundColor: kBrightWhite, // Consistent white app bar
        iconTheme: const IconThemeData(color: kNavyBlue), // Consistent back button color
        elevation: 1.0, // Consistent elevation
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExerciseCategory(
              context,
              'Exercises to Overcome Depression',
              depressionExercises,
            ),
            const SizedBox(height: 30),
            _buildExerciseCategory(
              context,
              'Exercises for Anxiety Relief',
              anxietyExercises,
            ),
            const SizedBox(height: 30),
            _buildExerciseCategory(
              context,
              'Exercises for Stress Management',
              stressManagementExercises,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(), // Added bottom navigation bar
    );
  }

  Widget _buildExerciseCategory(
      BuildContext context, String title, List<Exercise> exercises) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kNavyBlue, // Consistent primary color for titles
          ),
        ),
        const SizedBox(height: 15),
        ...exercises.map((exercise) {
          return Card(
            color: kBrightWhite, // Consistent white card background
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: kNavyBlue.withOpacity(0.3), width: 1), // Lighter border
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDetailScreen(exercise: exercise),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(Icons.directions_run, color: kNavyBlue), // Consistent icon color
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 16,
                          color: kDarkGreyText, // Consistent text color
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 18, color: kNavyBlue.withOpacity(0.7)), // Consistent arrow color
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // --- Bottom Navigation Bar (Copied from DashboardScreen for consistency) ---
  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: kBrightWhite,
      elevation: 8,
      selectedItemColor: kNavyBlue,
      unselectedItemColor: kMediumGreyText,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: kBottomNavLabelStyle.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: kBottomNavLabelStyle,
      currentIndex: _currentBottomNavIndex,
      onTap: (index) {
        // Only navigate if tapping a different tab
        if (index != _currentBottomNavIndex) {
          setState(() {
            _currentBottomNavIndex = index;
          });

          // Use pushReplacementNamed to prevent stacking identical screens
          // This creates a smooth transition between main tabs
          switch (index) {
            case 0: // Home/Dashboard
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1: // Groups
              Navigator.pushReplacementNamed(context, '/group1'); // Assuming '/group1' is your GroupsScreen route
              break;
            case 2: // Exercises (this screen)
            // We are already on the exercises screen, no navigation needed
              break;
            case 3: // Profile
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_outlined),
          activeIcon: Icon(Icons.group),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center_outlined),
          activeIcon: Icon(Icons.fitness_center),
          label: 'Exercises',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}