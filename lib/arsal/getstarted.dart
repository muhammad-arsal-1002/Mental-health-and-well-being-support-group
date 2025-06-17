import 'package:flutter/material.dart';
// import 'dart:io'; // Only needed if you are actually loading File images

// --- NEW THEME Color Constants: Bright White and Navy Blue ---
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or AI messages
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
// const Color kErrorRed = Colors.redAccent; // Keeping red for errors - Not used in this file

// --- Reusable Text Styles (Adjusted for the new theme) ---
const String _kFontFamily = 'Inter'; // Define font family once

// TextStyle get _kAppBarTitleTextStyle => const TextStyle( // Not used in this file
//   color: kBrightWhite,
//   fontFamily: _kFontFamily,
//   fontSize: 24,
//   fontWeight: FontWeight.bold,
// );

// TextStyle get _kSectionTitleTextStyle => const TextStyle( // Not used in this file
//   color: kNavyBlue,
//   fontFamily: _kFontFamily,
//   fontSize: 18,
//   fontWeight: FontWeight.bold,
//   height: 1.5,
// );

// TextStyle get _kInputHintTextStyle => const TextStyle( // Not used in this file
//   color: kMediumGreyText,
//   fontFamily: _kFontFamily,
//   fontSize: 16,
//   fontWeight: FontWeight.normal,
//   height: 1.25,
// );

// TextStyle get _kInputTextStyle => const TextStyle( // Not used in this file
//   color: kDarkGreyText,
//   fontFamily: _kFontFamily,
//   fontSize: 16,
//   fontWeight: FontWeight.normal,
// );

TextStyle get _kButtonTextStyle => const TextStyle(
  color: kBrightWhite, // White text on navy blue button
  fontFamily: _kFontFamily,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  height: 1.375,
);

// TextStyle get _kChipTextStyle => const TextStyle( // Not used in this file
//   fontFamily: _kFontFamily,
//   fontSize: 15,
//   fontWeight: FontWeight.normal,
// );

// Data model for each onboarding page
class OnboardingPageData {
  final String title;
  final String description;
  final Widget imagePlaceholder; // Using a Widget for flexibility
  final String buttonText;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.imagePlaceholder,
    required this.buttonText,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key}); // Added key

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late List<OnboardingPageData> onboardingPages;

  // Helper function to create image placeholders
  Widget _buildImagePlaceholder(String imagePath) {
    return Container(
      height: 230, // Adjusted height slightly for better visual balance with images
      // width: double.infinity, // Container will expand to parent's width in Column
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Optional: add rounded corners to image container
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // Match container's border radius
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover, // Ensures the image covers the container
          errorBuilder: (context, error, stackTrace) {
            // Fallback for image loading errors
            print('Error loading onboarding image $imagePath: $error');
            return Container(
              color: kLightBlueAccent.withOpacity(0.3),
              child: const Center(
                child: Icon(Icons.broken_image_outlined, size: 80, color: kMediumGreyText),
              ),
            );
          },
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          if (_pageController.hasClients && _pageController.page != null) {
            _currentPage = _pageController.page!.round();
          }
        });
      }
    });

    onboardingPages = [
      OnboardingPageData(
        title: 'Find Strength in Supportive Conversations',
        description:
        'Join groups where people understand you. Talk freely and feel heard in a safe, judgment-free space.',
        imagePlaceholder: _buildImagePlaceholder('assets/images/onboard1.jpg'), // Use image
        buttonText: 'Next',
      ),
      OnboardingPageData(
        title: 'Talk Freely in Group Chats with People Who Understand',
        description:
        'Experience a safe space where you can share, learn, and grow together.',
        imagePlaceholder: _buildImagePlaceholder('assets/images/onboard2.jpg'), // Use image
        buttonText: 'Next',
      ),
      OnboardingPageData(
        title: 'Access Stress Relief Exercises, Food Routines & AI Support',
        description:
        'Enhance your well-being with personalized tools designed to support you on your mental health journey.',
        imagePlaceholder: _buildImagePlaceholder('assets/images/onboard3.jpg'), // Use image
        buttonText: 'Get Started',
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for potential responsive adjustments
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBrightWhite,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = onboardingPages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Image Placeholder
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding around the image container
                          child: page.imagePlaceholder,
                        ),
                        const SizedBox(height: 40), // Adjusted spacing
                        // Title
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kNavyBlue,
                            fontFamily: _kFontFamily,
                            fontSize: 26, // Consider making this responsive
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 20), // Adjusted spacing
                        // Description
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kDarkGreyText,
                            fontFamily: _kFontFamily,
                            fontSize: 17, // Consider making this responsive
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page Indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingPages.length, (idx) { // Changed index to idx to avoid conflict
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == idx ? 12.0 : 8.0,
                    height: _currentPage == idx ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      color: _currentPage == idx ? kNavyBlue : kLightBlueAccent,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  );
                }),
              ),
            ),
            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 10),
              child: SizedBox(
                width: double.infinity,
                height: 58, // Consider making this responsive
                child: ElevatedButton(
                  onPressed: _onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNavyBlue,
                    foregroundColor: kBrightWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                    textStyle: _kButtonTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: Text(onboardingPages[_currentPage].buttonText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}