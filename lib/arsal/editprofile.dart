import 'package:flutter/material.dart';

// --- Color Constants ---
const Color kPrimaryNavy = Color(0xFF0A2472);
const Color kSecondaryBlue = Color(0xFF0E6BA8);
const Color kAccentTeal = Color(0xFF00B4D8);
const Color kLightBlue = Color(0xFFA6E1FA);
const Color kWhite = Color(0xFFFFFFFF);
const Color kLightGray = Color(0xFFF5F5F5);
const Color kMediumGray = Color(0xFFE0E0E0);
const Color kDarkGray = Color(0xFF9E9E9E);
const Color kErrorRed = Color(0xFFE53935);
const Color kSuccessGreen = Color(0xFF4CAF50);

// --- Text Styles ---
const TextStyle kAppBarTitleStyle = TextStyle(
  color: kPrimaryNavy,
  fontFamily: 'Inter',
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

const TextStyle kSectionLabelStyle = TextStyle(
  color: kPrimaryNavy,
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const TextStyle kInputTextStyle = TextStyle(
  color: Colors.black87,
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

const TextStyle kInputHintStyle = TextStyle(
  color: kDarkGray,
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

const TextStyle kButtonTextStyle = TextStyle(
  color: kWhite,
  fontFamily: 'Inter',
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  List<String> _selectedMentalHealthTags = ['Anxiety', 'Mindfulness'];

  @override
  void initState() {
    super.initState();
    // Initialize with placeholder data
    _nameController.text = 'Sarah Johnson';
    _emailController.text = 'sarah@mentalwellness.com';
    _bioController.text = 'Mental health advocate | Self-care enthusiast';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          backgroundColor: kSuccessGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedMentalHealthTags.contains(tag)) {
        _selectedMentalHealthTags.remove(tag);
      } else {
        _selectedMentalHealthTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile', style: kAppBarTitleStyle),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              'Save',
              style: TextStyle(
                color: kAccentTeal,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kLightBlue,
                        border: Border.all(color: kPrimaryNavy, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage('https://placehold.co/120x120/0A2472/FFFFFF?text=SJ'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          // Image picker functionality would go here
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: kAccentTeal,
                            shape: BoxShape.circle,
                            border: Border.all(color: kWhite, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: kWhite,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _bioController,
                label: 'Bio',
                hint: 'Tell us about yourself',
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _passwordController,
                label: 'New Password',
                hint: 'Leave blank to keep current',
                obscureText: _obscureText,
                isPassword: true,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Mental Health Interests',
                style: kSectionLabelStyle,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Anxiety',
                  'Depression',
                  'Stress',
                  'Mindfulness',
                  'Self-Care',
                  'Therapy',
                  'Meditation',
                  'Support Groups',
                ].map((tag) => FilterChip(
                  label: Text(tag),
                  selected: _selectedMentalHealthTags.contains(tag),
                  onSelected: (selected) => _toggleTag(tag),
                  selectedColor: kAccentTeal,
                  backgroundColor: kLightGray,
                  labelStyle: TextStyle(
                    color: _selectedMentalHealthTags.contains(tag)
                        ? kWhite
                        : kPrimaryNavy,
                  ),
                )).toList(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentTeal,
                    foregroundColor: kWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: Text('Save Changes', style: kButtonTextStyle),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    bool isPassword = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kSectionLabelStyle),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: kInputTextStyle,
          cursorColor: kPrimaryNavy,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: kInputHintStyle,
            filled: true,
            fillColor: kLightGray,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryNavy, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kErrorRed, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kErrorRed, width: 2),
            ),
            errorStyle: const TextStyle(
              color: kErrorRed,
              fontWeight: FontWeight.w500,
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: kPrimaryNavy,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
          validator: validator,
        ),
      ],
    );
  }
}