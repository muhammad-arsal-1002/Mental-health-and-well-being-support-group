import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  // String _userType = 'client'; // REMOVED: User type selection
  bool _isLoading = false; // To show loading indicator

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- Theme Colors: Navy Blue and Bright White ---
  static const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
  static const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
  static const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or lighter elements
  static const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
  static const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
  static const Color kErrorRed = Colors.redAccent; // Keeping red for errors

  // --- Controllers for TextFields ---
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // User signed in successfully
        if (mounted && userCredential.user != null) {
          // --- NAVIGATION MODIFIED ---
          // Since user type is removed, navigate to a default dashboard or home screen.
          // Replace '/dashboard' with your actual default route after login.
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          String errorMessage = "An error occurred. Please try again.";
          if (e.code == 'user-not-found') {
            errorMessage = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            errorMessage = 'Wrong password provided for that user.';
          } else if (e.code == 'invalid-email') {
            errorMessage = 'The email address is not valid.';
          } else if (e.code == 'invalid-credential') {
            errorMessage = 'Invalid login credentials. Please check your email and password.';
          } else if (e.code == 'network-request-failed') {
            errorMessage = 'Network error. Please check your connection.';
          }
          print("Firebase Auth Error (Login): CODE: ${e.code} MESSAGE: ${e.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: kErrorRed,
            ),
          );
        }
      } catch (e, s) {
        if (mounted) {
          print("Generic Login error: $e");
          print("Stack trace: $s");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("An unexpected error occurred. Please try again."),
              backgroundColor: kErrorRed,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _forgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address to reset password.'),
          backgroundColor: kLightBlueAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent. Please check your inbox.'),
            backgroundColor: kNavyBlue,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage = "Failed to send reset email. Please try again.";
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: kErrorRed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An unexpected error occurred. Please try again."),
            backgroundColor: kErrorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrightWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 80,
                  color: kNavyBlue,
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kNavyBlue,
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Login to continue your journey',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kMediumGreyText,
                    fontFamily: 'Inter',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),

                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 24),

                // REMOVED: User Type Selector
                // _buildUserTypeSelector(),
                // const SizedBox(height: 24),

                _buildLoginButton(),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/resetpassword');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: kNavyBlue,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: kMediumGreyText, fontFamily: 'Inter'),
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: kNavyBlue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // REMOVED: _buildUserTypeSelector() method was here

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: kDarkGreyText, fontFamily: 'Inter'),
      decoration: InputDecoration(
        hintText: 'Enter your email',
        hintStyle: TextStyle(color: kMediumGreyText, fontFamily: 'Inter'),
        prefixIcon: Icon(Icons.email_outlined, color: kNavyBlue.withOpacity(0.8)),
        filled: true,
        fillColor: kLightBlueAccent.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kLightBlueAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kLightBlueAccent, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kNavyBlue, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kErrorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kErrorRed, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      enabled: !_isLoading,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(color: kDarkGreyText, fontFamily: 'Inter'),
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: TextStyle(color: kMediumGreyText, fontFamily: 'Inter'),
        prefixIcon: Icon(Icons.lock_outline, color: kNavyBlue.withOpacity(0.8)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: kNavyBlue.withOpacity(0.8),
          ),
          onPressed: _isLoading ? null : () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: kLightBlueAccent.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kLightBlueAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kLightBlueAccent, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kNavyBlue, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kErrorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kErrorRed, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
      enabled: !_isLoading,
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kNavyBlue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        shadowColor: kNavyBlue.withOpacity(0.4),
      ),
      onPressed: _isLoading ? null : _loginUser,
      child: _isLoading
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: kBrightWhite,
          strokeWidth: 3,
        ),
      )
          : Container( // Ensures the text 'Login' is vertically centered like the CircularProgressIndicator
        height: 24, // Match height of SizedBox for CircularProgressIndicator
        alignment: Alignment.center,
        child: const Text('Login', style: TextStyle(color: kBrightWhite)),
      ),
    );
  }
}