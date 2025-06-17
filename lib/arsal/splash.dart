import 'package:flutter/material.dart';
import 'dart:async'; // Required for Timer

// --- NEW THEME Color Constants: Bright White and Navy Blue ---
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or AI messages
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
// const Color kErrorRed = Colors.redAccent; // Keeping red for errors - Not used in this file

// --- Reusable Text Styles (Adjusted for the new theme) ---
const String _kFontFamily = 'Inter'; // Define font family once

TextStyle get _kTitleSplashTextStyle => const TextStyle( // Specific for splash screen title
  color: kNavyBlue, // Navy blue for title
  fontFamily: _kFontFamily,
  fontSize: 48,
  fontWeight: FontWeight.bold,
  letterSpacing: -1.5, // Tighter letter spacing for a modern look
);

TextStyle get _kSubtitleSplashTextStyle => const TextStyle( // Specific for splash screen subtitle
  color: kMediumGreyText, // Medium grey for subtitle
  fontFamily: _kFontFamily,
  fontSize: 18,
  height: 1.4,
);

// Removed _kStatusBarTextStyle as AppBar is being removed.
// Status bar content will be handled by the system or global theme if needed.


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // Added key

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer for 5 seconds
    Timer(const Duration(seconds: 5), () {
      // After 5 seconds, navigate to the 'getstarted' route
      if (mounted) { // Check if the widget is still in the tree
        Navigator.pushReplacementNamed(context, '/getstarted');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for basic responsiveness (optional for splash, but good practice)
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBrightWhite, // Overall background is bright white
      body: SafeArea( // Using SafeArea to avoid system UI intrusions
        child: Center( // Center content in the middle of the screen
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Vertically center the column
            children: <Widget>[
              // MindCircle Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'MindCircle',
                  textAlign: TextAlign.center,
                  style: _kTitleSplashTextStyle,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle - Your Safe Space for Mental Wellness
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Text(
                  'Your Safe Space for Mental Wellness',
                  textAlign: TextAlign.center,
                  style: _kSubtitleSplashTextStyle,
                ),
              ),
              const SizedBox(height: 40), // Spacing before the image

              // Image/illustration area
              Container(
                height: 220, // Keep fixed or make responsive e.g. screenHeight * 0.3
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  // Optional: if your image doesn't have a background or you want a fallback
                  // color: kLightBlueAccent.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect( // Ensures the image respects the border radius
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/mindcircle.jpg', // Use the local image
                    fit: BoxFit.cover, // How the image should be inscribed into the space allocated during layout.
                    // BoxFit.contain would show the whole image, potentially leaving empty space.
                    // BoxFit.fill would stretch the image.
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if the image fails to load
                      print('Error loading splash image: $error');
                      return Container(
                        color: kLightBlueAccent.withOpacity(0.2),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 80,
                            color: kMediumGreyText,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40), // Spacing after the image

              // Placeholder for the "circle" element (Styled as a Floating Action Button)
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: kBrightWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: kLightBlueAccent,
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.favorite_outline, // Heart icon for mental wellness
                    size: 36,
                    color: kNavyBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}