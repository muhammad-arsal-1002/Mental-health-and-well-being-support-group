import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/services.dart'; // Required for SystemChrome

// --- Theme Colors: Navy Blue and Bright White ---
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or lighter elements
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
const Color kErrorRed = Colors.redAccent; // Keeping red for errors

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key}); // Added const constructor

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false; // Added to manage loading state for the button

  @override
  void initState() {
    super.initState();
    // Set status bar icons to dark for light app bar background for consistency
    // CORRECTED LINE: Removed extra 'System'
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarIconBrightness: Brightness.dark, // Dark icons for light status bar
      statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      statusBarColor: kBrightWhite, // Consistent status bar color
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty || !_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
          backgroundColor: kErrorRed, // Themed error color
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset link sent to $email!'),
            backgroundColor: kNavyBlue, // Themed success color
          ),
        );
        // Optionally, you might want to navigate back to the login screen
        // after the link is sent.
        // Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }
      // You can add more error handling based on Firebase Auth error codes

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: kErrorRed, // Themed error color
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred.'),
            backgroundColor: kErrorRed, // Themed error color
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  bool _isValidEmail(String email) {
    // More robust email validation regex
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrightWhite, // Set background to bright white
      appBar: AppBar(
        backgroundColor: kBrightWhite, // Set app bar background to bright white
        elevation: 0, // No shadow for a cleaner look
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kNavyBlue), // Navy blue back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // Removed original status bar time/icons to keep it simple and rely on SystemChrome
        // You can add these back if you specifically need custom status bar elements
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 32),
            Text(
              'Reset Password',
              style: TextStyle(
                color: kNavyBlue, // Set title color to navy blue
                fontFamily: 'Inter',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Enter your email address below to receive a password reset link.',
              style: TextStyle(
                color: kDarkGreyText, // Informative text in dark grey
                fontFamily: 'Inter',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24), // Added some space
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kDarkGreyText, // Text input in dark grey
                fontFamily: 'Inter',
                fontSize: 16,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: kLightBlueAccent.withOpacity(0.1), // Subtle light blue background
                hintText: 'Enter your email',
                hintStyle: const TextStyle(
                  color: kMediumGreyText, // Hint text in medium grey
                  fontFamily: 'Inter',
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kLightBlueAccent), // Light blue border
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kLightBlueAccent, width: 1.0), // Light blue border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kNavyBlue, width: 2.0), // Navy blue on focus
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kErrorRed, width: 1.5), // Red for error
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kErrorRed, width: 2.0), // Red for focused error
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              enabled: !_isLoading, // Disable input when loading
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword, // Disable button when loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: kNavyBlue, // Button background navy blue
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4, // Subtle elevation
                  shadowColor: kNavyBlue.withOpacity(0.4), // Themed shadow
                ),
                child: _isLoading
                    ? const CircularProgressIndicator( // Show loading indicator
                  color: kBrightWhite, // Loading indicator in white
                  strokeWidth: 3,
                )
                    : const Text(
                  'Reset Password',
                  style: TextStyle(
                    color: kBrightWhite, // Text in bright white
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: Container(
                width: 134,
                height: 5,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: kLightBlueAccent, // Bottom bar in light blue accent
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}