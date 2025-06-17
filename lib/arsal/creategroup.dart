import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome
// import 'dart:io'; // Only needed if you are actually loading File images

// --- NEW THEME Color Constants: Bright White and Navy Blue ---
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or AI messages
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
const Color kErrorRed = Colors.redAccent; // Keeping red for errors

// --- Reusable Text Styles (Adjusted for the new theme) ---
const String _kFontFamily = 'Inter'; // Define font family once

TextStyle get _kAppBarTitleTextStyle => const TextStyle(
  color: kBrightWhite, // White text on navy blue app bar
  fontFamily: _kFontFamily,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

TextStyle get _kSectionTitleTextStyle => const TextStyle(
  color: kNavyBlue, // Navy blue for section titles
  fontFamily: _kFontFamily,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  height: 1.5,
);

TextStyle get _kInputHintTextStyle => const TextStyle(
  color: kMediumGreyText, // Medium grey for hint text
  fontFamily: _kFontFamily,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  height: 1.25,
);

TextStyle get _kInputTextStyle => const TextStyle(
  color: kDarkGreyText, // Dark grey text on light background
  fontFamily: _kFontFamily,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

TextStyle get _kButtonTextStyle => const TextStyle(
  color: kBrightWhite, // White text on navy blue button
  fontFamily: _kFontFamily,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  height: 1.375,
);

TextStyle get _kChipTextStyle => const TextStyle(
  fontFamily: _kFontFamily,
  fontSize: 15,
  fontWeight: FontWeight.normal,
);

// --- Data Model for the new group ---
class Group {
  final String id;
  final String name;
  final String imageUrl;
  final String memberCount;
  final String category;
  final String? description;
  final String? location;

  Group({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.memberCount,
    required this.category,
    this.description,
    this.location,
  });
}

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _groupNameController;
  late TextEditingController _groupDescriptionController;
  late TextEditingController _locationController;

  String? _selectedSport; // This variable will now hold the selected category
  // File? _pickedImage; // If you plan to implement image picking
  final List<String?> _imagePlaceholders = [null, null, null]; // For multiple images

  // Updated categories for a mental health support app
  final List<String> _categoryTypes = ['Anxiety', 'Depression', 'Stress', 'Grief', 'Mindfulness', 'Support', 'Well-being'];

  @override
  void initState() {
    super.initState();
    // Set status bar icons to white for dark app bar background
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light, // For Android (light icons for dark app bar)
      statusBarBrightness: Brightness.dark,      // For iOS (dark content on light background)
      statusBarColor: kNavyBlue,      // Consistent status bar color
    ));
    _groupNameController = TextEditingController();
    _groupDescriptionController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupDescriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _createGroup() {
    // Basic validation for category type (formKey doesn't cover ChoiceChips directly)
    bool isCategorySelected = _selectedSport != null;

    if (_formKey.currentState!.validate() && isCategorySelected) {
      final newGroup = Group(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _groupNameController.text.trim(),
        description: _groupDescriptionController.text.trim(),
        imageUrl: 'assets/images/default_group_placeholder.png', // Placeholder
        memberCount: '1 member', // Default for new group creator
        category: _selectedSport!, // Safe to use ! because we checked isCategorySelected
        location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : 'Not specified',
      );

      print('New Group Created: ${newGroup.name}, Category: ${newGroup.category}, Location: ${newGroup.location}');
      Navigator.pop(context, newGroup); // Pass the new group back if needed

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newGroup.name} group created successfully!', style: const TextStyle(color: kBrightWhite)),
          backgroundColor: kNavyBlue, // Use navy blue for success snackbar
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      String errorMessage = '';
      if (!isCategorySelected) {
        errorMessage += 'Please select a category. ';
      }
      if (!_formKey.currentState!.validate()) {
        errorMessage += 'Please fill all required fields.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage.trim(), style: const TextStyle(color: kBrightWhite)),
          backgroundColor: kErrorRed, // Use error red
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrightWhite, // Scaffold background is bright white
      appBar: AppBar(
        backgroundColor: kNavyBlue, // Navy blue app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kBrightWhite), // White icon
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Create Group', style: _kAppBarTitleTextStyle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                Text('Group Images (Optional)', style: _kSectionTitleTextStyle),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(3, (index) => _buildImagePlaceholder(index)),
                ),
                const SizedBox(height: 32),

                Text('Group Name', style: _kSectionTitleTextStyle),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _groupNameController,
                  hintText: 'Enter group name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Group name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                Text('Description', style: _kSectionTitleTextStyle),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _groupDescriptionController,
                  hintText: 'Tell us about your group (e.g., goals, activities)',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Group description is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                Text('Category', style: _kSectionTitleTextStyle),
                const SizedBox(height: 12),
                _buildCategoryChips(),
                const SizedBox(height: 24),

                Text('Location (Optional)', style: _kSectionTitleTextStyle),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _locationController,
                  hintText: 'Search for a location (e.g., city, park)',
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildCreateGroupButton(context),
    );
  }

  Widget _buildImagePlaceholder(int index) {
    return GestureDetector(
      onTap: () {
        print('Select image $index');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image picker for slot ${index + 1} coming soon!', style: const TextStyle(color: kBrightWhite)),
            backgroundColor: kNavyBlue, // Use navy blue
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: kLightBlueAccent.withOpacity(0.3), // Light blue background for placeholder
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kNavyBlue.withOpacity(0.5), width: 1.5), // Navy blue border
        ),
        child: _imagePlaceholders[index] == null
            ? Icon(Icons.add_a_photo_outlined, color: kNavyBlue.withOpacity(0.8), size: 35) // Navy blue icon
            : ClipRRect(
          borderRadius: BorderRadius.circular(16),
          // child: Image.file(File(_imagePlaceholders[index]!), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: _kInputTextStyle, // Dark grey text
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: _kInputHintTextStyle,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: kMediumGreyText) : null, // Medium grey for icon
        filled: true,
        fillColor: kLightBlueAccent.withOpacity(0.3), // Input field background is light blue accent
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none, // No border by default
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: kLightBlueAccent, width: 1), // Light blue accent outline
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kNavyBlue, width: 2), // Navy blue for focused outline
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kErrorRed, width: 1.0), // Error red
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kErrorRed, width: 2), // Error red
        ),
        errorStyle: const TextStyle(color: kErrorRed, fontWeight: FontWeight.w500), // Error red
      ),
      validator: validator,
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: _categoryTypes.map((category) {
        bool isSelected = _selectedSport == category;
        return ChoiceChip(
          label: Text(
              category,
              style: _kChipTextStyle.copyWith(
                color: isSelected ? kBrightWhite : kNavyBlue, // White for selected, Navy Blue for unselected text
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              )
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              _selectedSport = selected ? category : null; // Allows deselection if tapped again
            });
          },
          backgroundColor: isSelected ? kNavyBlue : kLightBlueAccent.withOpacity(0.3), // Navy blue for selected, light blue accent for unselected
          selectedColor: kNavyBlue, // Navy blue for selected chip
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: isSelected ? kNavyBlue : kNavyBlue.withOpacity(0.5), // Border matches fill for selected, subtle navy blue for unselected
              width: 1.5,
            ),
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          pressElevation: 0,
        );
      }).toList(),
    );
  }

  Widget _buildCreateGroupButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 24,
          top: 16
      ),
      decoration: const BoxDecoration(
        color: kBrightWhite, // White background for the bottom bar
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Softer shadow
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kNavyBlue, // Navy blue button
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          minimumSize: const Size(double.infinity, 56),
          elevation: 5,
        ),
        onPressed: _createGroup,
        child: Text('Create Group', style: _kButtonTextStyle),
      ),
    );
  }
}