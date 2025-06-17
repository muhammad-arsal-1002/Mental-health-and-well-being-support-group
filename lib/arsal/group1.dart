import 'package:flutter/material.dart';

// --- NEW THEME Color Constants: Bright White and Navy Blue ---
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or AI messages
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
const Color kErrorRed = Colors.redAccent; // Keeping red for errors

// --- Reusable Text Styles (Adjusted for the new theme) ---
const String _kFontFamily = 'Inter'; // Define font family once

// Removed _kAppBarTitleTextStyle as it was for a dark app bar,
// now using inline TextStyle for the AppBar title with kNavyBlue.

TextStyle get _kSectionTitleTextStyle => const TextStyle(
  color: kNavyBlue, // Navy blue for section titles
  fontFamily: _kFontFamily,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  height: 1.5,
);

TextStyle get _kInputHintTextStyle => const TextStyle(
  color: kMediumGreyText, // Medium grey hint text
  fontFamily: _kFontFamily,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  height: 1.25,
);

TextStyle get _kInputTextStyle => const TextStyle(
  color: kDarkGreyText, // Dark text on light field background
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

const TextStyle kCardTitleTextStyle = TextStyle(
  color: kDarkGreyText, // Titles on white background
  fontFamily: _kFontFamily,
  fontSize: 18,
  fontWeight: FontWeight.w700,
  height: 1.3,
);

const TextStyle kCardSubtitleTextStyle = TextStyle(
  color: kMediumGreyText, // Subtitles on white background
  fontFamily: _kFontFamily,
  fontSize: 14,
  fontWeight: FontWeight.normal,
  height: 1.4,
);

const TextStyle kBodyTextStyle = TextStyle(
  color: kDarkGreyText, // General body text
  fontFamily: _kFontFamily,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  height: 1.5,
);

const TextStyle kSearchHintStyle = TextStyle(
  color: kMediumGreyText,
  fontFamily: _kFontFamily,
  fontSize: 16,
);

const TextStyle kChipLabelStyle = TextStyle(
  fontFamily: _kFontFamily,
  fontSize: 13,
);

const TextStyle kViewButtonTextStyle = TextStyle(
  fontFamily: _kFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 13,
);

const TextStyle kBottomNavLabelStyle = TextStyle(
  fontSize: 12, // Adjusted to match Dashboard
  fontFamily: _kFontFamily,
);

// --- Mock Data Structures ---
class Group {
  final String id;
  final String name;
  final String imageUrl; // Can be a local asset path or a network URL
  final String memberCount;
  final String category;
  final bool isMyGroup; // Added to identify user's created groups

  Group({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.memberCount,
    required this.category,
    this.isMyGroup = false, // Default to false
  });
}

class CategoryChip {
  final String label;
  final IconData icon;

  CategoryChip({required this.label, required this.icon});
}


// --- GroupScreen ---
class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  // Use the same _currentBottomNavIndex logic as DashboardScreen
  int _currentBottomNavIndex = 1; // Groups tab is index 1 in the new dashboard nav

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showMyGroups = false; // New state variable to toggle between all groups and my groups

  // Updated categories for a mental health support app
  final List<CategoryChip> _categories = [
    CategoryChip(label: 'All', icon: Icons.list_alt_outlined),
    CategoryChip(label: 'Anxiety', icon: Icons.sentiment_neutral_outlined),
    CategoryChip(label: 'Depression', icon: Icons.mood_bad_outlined),
    CategoryChip(label: 'Stress', icon: Icons.self_improvement_outlined),
    CategoryChip(label: 'Grief', icon: Icons.spa_outlined),
    CategoryChip(label: 'Mindfulness', icon: Icons.psychology_outlined),
    CategoryChip(label: 'Support', icon: Icons.people_outline),
  ];

  // Updated mock data for mental health support groups
  final List<Group> _allGroups = [
    Group(id: '1', name: 'Coping with Anxiety', imageUrl: 'assets/images/anxiety_group.png', memberCount: '45 members', category: 'Anxiety', isMyGroup: true), // Marked as my group
    Group(id: '2', name: 'Daily Depression Support', imageUrl: 'assets/images/depression_group.png', memberCount: '30 members', category: 'Depression'),
    Group(id: '3', name: 'Stress Reduction Techniques', imageUrl: 'assets/images/stress_group.png', memberCount: '25 members', category: 'Stress'),
    Group(id: '4', name: 'Navigating Grief Together', imageUrl: 'assets/images/grief_group.png', memberCount: '20 members', category: 'Grief'),
    Group(id: '5', name: 'Mindful Living Community', imageUrl: 'assets/images/mindfulness_group.png', memberCount: '50 members', category: 'Mindfulness', isMyGroup: true), // Marked as my group
    Group(id: '6', name: 'General Peer Support', imageUrl: 'assets/images/support_group.png', memberCount: '60 members', category: 'Support'),
    Group(id: '7', name: 'Overcoming Social Anxiety', imageUrl: 'assets/images/social_anxiety_group.png', memberCount: '18 members', category: 'Anxiety'),
    Group(id: '8', name: 'Finding Joy in Recovery', imageUrl: 'assets/images/recovery_group.png', memberCount: '22 members', category: 'Depression'),
  ];

  List<Group> get _filteredGroups {
    List<Group> groups = _allGroups;

    if (_showMyGroups) {
      groups = groups.where((group) => group.isMyGroup).toList();
    } else {
      if (_selectedCategory != 'All') {
        groups = groups.where((group) => group.category == _selectedCategory).toList();
      }
    }

    if (_searchQuery.isNotEmpty) {
      groups = groups.where((group) => group.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing, similar to Dashboard
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBrightWhite, // Changed to white background
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(), // Changed to use Dashboard's nav bar style
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kBrightWhite, // White app bar background
      elevation: 1.0, // Slight elevation
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: kNavyBlue), // Navy blue back icon
        onPressed: () {
          // Navigate to the dashboard and remove all routes until then
          Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
          debugPrint("Back arrow pressed, navigating to Dashboard.");
        },
      ),
      title: const Text("Support Groups", style: TextStyle(
        color: kNavyBlue, // Navy blue title
        fontFamily: _kFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      )),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, color: kDarkGreyText, size: 28), // Dark grey bell icon
          onPressed: () {
            debugPrint("Notifications pressed");
            // Handle notifications action
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: kDarkGreyText, size: 28), // Dark grey more icon
          onPressed: () {
            debugPrint("More options pressed");
            // Handle more options action (e.g., PopupMenuButton)
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        _buildSearchBar(),
        _buildCategoryChips(),
        _buildMyGroupsButton(), // New button for "View My Created Groups"
        Expanded(
          child: _filteredGroups.isEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                _searchQuery.isNotEmpty || _selectedCategory != 'All' || _showMyGroups
                    ? 'No support groups match your criteria.\nTry adjusting your filters.'
                    : 'No groups available right now.\nStart by creating one to connect with others!', // Updated empty message
                style: kBodyTextStyle.copyWith(color: kMediumGreyText, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: _filteredGroups.length,
            itemBuilder: (context, index) {
              return _buildGroupCard(_filteredGroups[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: _kInputTextStyle.copyWith(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search for support groups or topics...',
          hintStyle: kSearchHintStyle,
          prefixIcon: Icon(Icons.search, color: kMediumGreyText.withOpacity(0.8), size: 24),
          filled: true,
          fillColor: kLightBlueAccent.withOpacity(0.3), // Changed to subtle light blue accent
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: kLightBlueAccent, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: kNavyBlue, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    if (_showMyGroups) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemBuilder: (context, index) {
          final category = _categories[index];
          bool isSelected = _selectedCategory == category.label;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      size: 18,
                      color: isSelected ? kBrightWhite : kNavyBlue.withOpacity(0.8), // Navy blue for unselected icon
                    ),
                    const SizedBox(width: 8),
                    Text(category.label, style: kChipLabelStyle),
                  ],
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  _selectedCategory = selected ? category.label : 'All';
                });
              },
              backgroundColor: kLightBlueAccent.withOpacity(0.3), // Light blue accent for unselected chip
              selectedColor: kNavyBlue,
              labelStyle: kChipLabelStyle.copyWith(
                color: isSelected ? kBrightWhite : kDarkGreyText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(
                  color: isSelected ? kNavyBlue : kLightBlueAccent,
                  width: 1,
                ),
              ),
              elevation: isSelected ? 3 : 0,
              pressElevation: 5,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyGroupsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _showMyGroups = !_showMyGroups;
            _selectedCategory = 'All';
            _searchQuery = '';
          });
          debugPrint('Toggled "View My Created Groups" to: $_showMyGroups');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _showMyGroups ? kNavyBlue : kBrightWhite,
          foregroundColor: _showMyGroups ? kBrightWhite : kNavyBlue,
          minimumSize: const Size.fromHeight(55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: _showMyGroups ? Colors.transparent : kNavyBlue,
              width: 1,
            ),
          ),
          elevation: _showMyGroups ? 5 : 2,
          shadowColor: _showMyGroups ? Colors.black.withOpacity(0.3) : Colors.transparent,
        ),
        child: Text(
          _showMyGroups ? 'Show All Groups' : 'View My Created Groups',
          style: _kButtonTextStyle.copyWith(
            color: _showMyGroups ? kBrightWhite : kNavyBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard(Group group) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          debugPrint('Card tapped for group: ${group.name}, ID: ${group.id}');
          Navigator.pushNamed(
            context,
            '/groupdetail',
            arguments: {
              'groupId': group.id,
              'groupName': group.name,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  group.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: kLightBlueAccent.withOpacity(0.3),
                      child: const Icon(Icons.group_work_outlined, color: kMediumGreyText, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(group.name, style: kCardTitleTextStyle),
                    const SizedBox(height: 6),
                    Text(group.memberCount, style: kCardSubtitleTextStyle),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (group.isMyGroup && _showMyGroups)
                            TextButton(
                              onPressed: () {
                                debugPrint('View Requests button pressed for ${group.name}');
                                Navigator.pushNamed(context, '/requests', arguments: {'groupId': group.id});
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                backgroundColor: kLightBlueAccent.withOpacity(0.3),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                foregroundColor: kNavyBlue,
                              ),
                              child: const Text('Requests', style: kViewButtonTextStyle),
                            )
                          else
                            ElevatedButton(
                              onPressed: () {
                                debugPrint('View button pressed for ${group.name}');
                                Navigator.pushNamed(
                                  context,
                                  '/groupdetail',
                                  arguments: {
                                    'groupId': group.id,
                                    'groupName': group.name,
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kNavyBlue,
                                foregroundColor: kBrightWhite,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                elevation: 3,
                              ),
                              child: const Text('View', style: kViewButtonTextStyle),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        debugPrint('Create New Group FAB pressed');
        Navigator.pushNamed(context, '/creategroup'); // Ensure '/creategroup' route is defined
      },
      backgroundColor: kNavyBlue,
      foregroundColor: kBrightWhite,
      child: const Icon(Icons.add_circle_outline_rounded, size: 30),
      tooltip: 'Create Group',
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  // --- NEW Bottom Navigation Bar (Matching DashboardScreen) ---
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
            case 0: // Dashboard
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1: // Groups (this screen)
            // We are already on the groups screen,
            // but still update the index for visual consistency
            // If you had sub-routes for groups, you might pop to root here.
              break;
            case 2: // Exercises
              Navigator.pushReplacementNamed(context, '/exercise');
              break;
            case 3: // Profile
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined), // Consistent outlined icon style
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_outlined), // Consistent outlined icon style
          activeIcon: Icon(Icons.group),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center_outlined), // Consistent outlined icon style
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