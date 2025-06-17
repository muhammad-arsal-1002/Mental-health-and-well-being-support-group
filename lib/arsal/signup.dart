import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome

// --- New Color Palette: Bright White and Navy Blue ---
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or AI messages
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
const Color kErrorRed = Colors.redAccent; // Keeping red for errors

// --- Text Styles (Updated for new theme) ---
const TextStyle _kStatusBarTextStyle = TextStyle(
  color: kDarkGreyText, // Status bar text dark grey for bright white background
  fontFamily: 'Roboto',
  fontSize: 14,
  fontWeight: FontWeight.normal,
);

const TextStyle _kTitleTextStyle = TextStyle(
  color: kNavyBlue, // Title in Navy Blue
  fontFamily: 'Inter',
  fontSize: 32,
  fontWeight: FontWeight.bold,
  height: 1,
);

const TextStyle _kLabelTextStyle = TextStyle(
  color: kDarkGreyText, // Labels in Dark Grey
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.normal,
  height: 1.5,
);

const TextStyle _kHintTextStyle = TextStyle(
  color: kMediumGreyText, // Hints in Medium Grey
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.normal,
  height: 1.25,
);

const TextStyle _kButtonTextStyle = TextStyle(
  color: kBrightWhite, // Button text in Bright White
  fontFamily: 'Inter',
  fontSize: 16,
  letterSpacing: 0.5,
  fontWeight: FontWeight.w500,
  height: 1.375,
);

const TextStyle _kTermsTextStyle = TextStyle(
  color: kDarkGreyText, // Terms text in Dark Grey
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.normal,
  height: 1.5,
);


class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _agreeToTerms = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _verificationEmailSent = false;

  @override
  void initState() {
    super.initState();
    _resetState();
    // Set status bar icons to dark for light app bar background for consistency
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.dark, // Dark icons for light status bar
      statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      statusBarColor: kBrightWhite, // Consistent status bar color
    ));
    _auth.signOut(); // Ensure fresh state for demo purposes
  }

  void _resetState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _agreeToTerms = false;
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    _isLoading = false;
    _verificationEmailSent = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kErrorRed, // Themed error color
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kNavyBlue, // Info/success messages in Navy Blue
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields correctly.');
      return;
    }
    if (!_agreeToTerms) {
      _showErrorSnackBar('Please agree to the Terms & Conditions.');
      return;
    }

    setState(() {
      _isLoading = true;
      _verificationEmailSent = false;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.sendEmailVerification();

      if (mounted) {
        setState(() {
          _verificationEmailSent = true;
        });
        _showInfoSnackBar('Account created. Please check your email for verification!');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }
      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkEmailVerificationAndNavigate() async {
    if (!_verificationEmailSent) {
      _showInfoSnackBar('Please create an account first to receive a verification email.');
      return;
    }

    setState(() { _isLoading = true; });
    try {
      await _auth.currentUser?.reload();
      final currentUser = _auth.currentUser;

      if (currentUser != null && currentUser.emailVerified) {
        if (mounted) {
          // Replace '/dashboard' with your actual dashboard route
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        _showInfoSnackBar('Email not yet verified. Please check your inbox or resend the email.');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error checking verification: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (!_verificationEmailSent) {
      _showInfoSnackBar('Please create an account first to resend verification.');
      return;
    }

    setState(() { _isLoading = true; });
    try {
      await _auth.currentUser?.sendEmailVerification();
      _showInfoSnackBar('Verification email re-sent. Please check your inbox.');
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar('Failed to resend email: ${e.message}');
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Current time for status bar (using actual device time, not hardcoded string)
    final now = DateTime.now();
    final String currentTime =
        '${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    final bool canCreateAccount = !_isLoading;
    final bool canInteractWithVerificationButtons = !_isLoading && _verificationEmailSent;

    return Scaffold(
      backgroundColor: kBrightWhite, // Set background to Bright White
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // The system status bar will be handled by SystemChrome.setSystemUIOverlayStyle
            // instead of a custom widget for a more native feel.
            Padding( // Added a simple padding for the top section instead of custom status bar
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: kNavyBlue), // Navy blue back arrow
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Create Your Account',
                textAlign: TextAlign.center,
                style: _kTitleTextStyle,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Email Address', style: _kLabelTextStyle),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text('Password', style: _kLabelTextStyle),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Enter password',
                        isObscured: !_isPasswordVisible,
                        suffixIcon: _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text('Confirm Password', style: _kLabelTextStyle),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm your password',
                        isObscured: !_isConfirmPasswordVisible,
                        suffixIcon: _isConfirmPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildTermsAndConditionsCheckbox(),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                          onPressed: canCreateAccount ? _createAccount : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kNavyBlue, // Button background in Navy Blue
                            disabledBackgroundColor: kNavyBlue.withOpacity(0.5), // Lighter Navy Blue when disabled
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            elevation: 4, // Subtle elevation
                            shadowColor: kNavyBlue.withOpacity(0.4), // Themed shadow
                          ),
                          child: _isLoading && !canInteractWithVerificationButtons
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: kBrightWhite, // Loading indicator in Bright White
                              strokeWidth: 3,
                            ),
                          )
                              : const Text('Create Account', style: _kButtonTextStyle),
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_verificationEmailSent) ...[
                        Center(
                          child: Text(
                            "A verification email has been sent. Please check your inbox.",
                            style: _kLabelTextStyle.copyWith(color: kNavyBlue), // Info text in Navy Blue
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: canInteractWithVerificationButtons
                                ? _checkEmailVerificationAndNavigate : null,
                            child: Text(
                              'I have verified, proceed to Dashboard',
                              style: TextStyle(
                                color: canInteractWithVerificationButtons
                                    ? kNavyBlue : kMediumGreyText, // Link color Navy Blue or Medium Grey
                                decoration: canInteractWithVerificationButtons
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: TextButton(
                            onPressed: canInteractWithVerificationButtons
                                ? _resendVerificationEmail : null,
                            child: Text(
                              'Resend Verification Email',
                              style: TextStyle(
                                color: canInteractWithVerificationButtons
                                    ? kNavyBlue : kMediumGreyText, // Link color Navy Blue or Medium Grey
                                decoration: canInteractWithVerificationButtons
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isObscured = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kLightBlueAccent.withOpacity(0.1), // Subtle light blue background
        border: Border.all(color: kLightBlueAccent, width: 1), // Light blue border
        boxShadow: [ // Add a subtle shadow for elevation
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isObscured,
        style: const TextStyle(
          color: kDarkGreyText, // Text input in Dark Grey
          fontFamily: 'Inter',
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: _kHintTextStyle,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: InputBorder.none, // No default border
          focusedBorder: OutlineInputBorder( // Focused border in Navy Blue
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kNavyBlue, width: 2),
          ),
          errorBorder: OutlineInputBorder( // Error border in Red
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kErrorRed, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder( // Focused error border in Red
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kErrorRed, width: 2),
          ),
          suffixIcon: suffixIcon != null
              ? IconButton(
            icon: Icon(suffixIcon, color: kNavyBlue.withOpacity(0.8)), // Suffix icon in Navy Blue
            onPressed: onSuffixIconPressed,
          )
              : null,
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget _buildTermsAndConditionsCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (bool? newValue) {
              setState(() {
                _agreeToTerms = newValue ?? false;
              });
            },
            activeColor: kNavyBlue, // Checkbox checked color in Navy Blue
            checkColor: kBrightWhite, // Checkmark color in Bright White
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: kLightBlueAccent, width: 1.5), // Checkbox border in Light Blue Accent
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'I agree to the Terms & Conditions and Privacy Policy',
            style: _kTermsTextStyle,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  // Removed _buildStatusBar as SystemChrome handles it for a native look.
  // The back button is added directly in the build method.

  Widget _buildBottomBar() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0, top: 10.0),
        width: 108,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: kNavyBlue, // Bottom bar in Navy Blue
        ),
      ),
    );
  }
}