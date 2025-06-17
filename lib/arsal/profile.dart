import 'package:flutter/material.dart';
import 'dart:math'; // For random image selection

// --- Theme Color Constants ---
const Color kPrimaryNavy = Color(0xFF0A2472);
const Color kSecondaryBlue = Color(0xFF0E6BA8);
const Color kAccentTeal = Color(0xFF00B4D8);
const Color kLightBlue = Color(0xFFA6E1FA);
const Color kWhite = Color(0xFFFFFFFF);
const Color kLightGray = Color(0xFFF5F5F5);
const Color kMediumGray = Color(0xFFE0E0E0);
const Color kDarkGray = Color(0xFF9E9E9E);
const Color kErrorRed = Color(0xFFE53935);

// --- Text Styles ---
final TextStyle kAppBarTitleStyle = TextStyle(
  color: kPrimaryNavy,
  fontFamily: 'Inter',
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

final TextStyle kProfileNameStyle = TextStyle(
  color: kPrimaryNavy,
  fontFamily: 'Inter',
  fontSize: 26,
  fontWeight: FontWeight.bold,
);

final TextStyle kCardTitleStyle = TextStyle(
  color: kPrimaryNavy,
  fontFamily: 'Inter',
  fontSize: 18,
  fontWeight: FontWeight.w600,
  height: 1.3,
);

final TextStyle kCardSubtitleStyle = TextStyle(
  color: kDarkGray,
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  height: 1.4,
);

final TextStyle kBodyTextStyle = TextStyle(
  color: Colors.black87,
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.normal,
  height: 1.5,
);

final TextStyle kButtonTextStyle = TextStyle(
  color: kWhite,
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

final TextStyle kTabBarLabelStyle = TextStyle(
  color: kPrimaryNavy,
  fontFamily: 'Inter',
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

final TextStyle kTabBarUnselectedLabelStyle = TextStyle(
  color: kDarkGray,
  fontFamily: 'Inter',
  fontSize: 15,
  fontWeight: FontWeight.normal,
);

// Consistent Bottom Nav Label Style (from Dashboard/Groups/Exercises)
const TextStyle kBottomNavLabelStyle = TextStyle(
  fontSize: 12, // Adjusted to match Dashboard
  fontFamily: 'Inter',
);

// --- Profile Screen (Main Screen) ---
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 3; // Profile tab is index 3

  final Random _random = Random();

  // Function to generate a random Lorem Picsum URL
  String _getRandomInternetImageUrl({int width = 400, int height = 300}) {
    return 'https://picsum.photos/seed/${_random.nextInt(1000)}/$width/$height';
  }

  // Updated posts with random images
  late final List<Map<String, String>> posts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    posts = [
      {
        'user': 'Muhammad Arsal', // Updated
        'avatar': 'assets/images/profile.jpg', // Updated
        'time': '2h ago',
        'content': 'Today I practiced mindfulness for 15 minutes. Feeling more centered and present. #mentalhealth #selfcare',
        'image': _getRandomInternetImageUrl(width: 600, height: 400) // Random image
      },
      {
        'user': 'Muhammad Arsal', // Updated
        'avatar': 'assets/images/profile.jpg', // Updated
        'time': '1d ago',
        'content': 'Attended a virtual support group session. So grateful for this community where we can share our experiences openly.',
      },
      {
        'user': 'Muhammad Arsal', // Updated
        'avatar': 'assets/images/profile.jpg', // Updated
        'time': '2d ago',
        'content': 'Journaling has been really helpful for processing my emotions. Here are some prompts that worked for me...',
        'image': _getRandomInternetImageUrl(width: 600, height: 400) // Random image
      },
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGray,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryNavy),
          onPressed: () {
            // Use pushReplacementNamed to navigate back to dashboard
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
        title: Text('My Profile', style: kAppBarTitleStyle),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: kPrimaryNavy),
            onPressed: () {
              // Share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share Profile functionality coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: kPrimaryNavy),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileWidget()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded( // Make the entire body scrollable
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header Section
                  Container(
                    color: kWhite,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kLightBlue,
                                border: Border.all(color: kPrimaryNavy, width: 2),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/profile.jpg'), // Use local asset
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: kWhite,
                                shape: BoxShape.circle,
                                border: Border.all(color: kPrimaryNavy),
                              ),
                              child: const Icon(Icons.camera_alt, size: 16, color: kPrimaryNavy),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Muhammad Arsal', style: kProfileNameStyle), // Updated Name
                        const SizedBox(height: 8),
                        Text('Mental Health Advocate | Self-care Enthusiast',
                            style: kCardSubtitleStyle.copyWith(color: kSecondaryBlue)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem('12', 'Posts'),
                            _buildStatItem('45', 'Connections'),
                            _buildStatItem('5', 'Groups'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bio Section
                  Container(
                    color: kWhite,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About Me', style: kCardTitleStyle),
                        const SizedBox(height: 8),
                        Text(
                          'Passionate about mental health awareness and creating safe spaces for open conversations. '
                              'I share my journey and resources that have helped me along the way.',
                          style: kBodyTextStyle,
                        ),
                      ],
                    ),
                  ),

                  // Tab Bar
                  Container(
                    color: kWhite,
                    margin: const EdgeInsets.only(top: 8),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: kAccentTeal,
                      labelColor: kPrimaryNavy,
                      unselectedLabelColor: kDarkGray,
                      labelStyle: kTabBarLabelStyle,
                      unselectedLabelStyle: kTabBarUnselectedLabelStyle,
                      tabs: const [
                        Tab(text: 'Posts'),
                        Tab(text: 'Resources'),
                        Tab(text: 'Activities'),
                      ],
                    ),
                  ),

                  // Tab Bar View (wrapped in a SizedBox to give it a constrained height)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5, // Adjust height as needed
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPostsList(),
                        _buildResourcesList(),
                        _buildActivitiesList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccentTeal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostWidget()),
          );
        },
        child: const Icon(Icons.add, color: kWhite),
      ),
      bottomNavigationBar: _buildBottomNavBar(), // Add the consistent bottom nav bar
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: TextStyle(
          color: kPrimaryNavy,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        )),
        Text(label, style: TextStyle(
          color: kDarkGray,
          fontSize: 14,
        )),
      ],
    );
  }

  Widget _buildPostsList() {
    if (posts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No posts yet. Share your thoughts or experiences!',
            style: kBodyTextStyle.copyWith(color: kDarkGray),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: kMediumGray, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: kLightBlue,
                      backgroundImage: AssetImage(post['avatar']!), // Use AssetImage for local
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['user']!,
                            style: kBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            post['time']!,
                            style: kCardSubtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz, color: kDarkGray),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('More post options coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (post['image'] != null && post['image']!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        post['image']!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            color: kLightGray,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                                color: kPrimaryNavy,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: kMediumGray,
                            child: const Center(
                              child: Icon(Icons.broken_image, color: kDarkGray, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                Text(
                  post['content']!,
                  style: kBodyTextStyle,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: kPrimaryNavy),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Like functionality coming soon!')),
                        );
                      },
                    ),
                    const Text('24', style: TextStyle(color: kDarkGray)),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: kPrimaryNavy),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comment functionality coming soon!')),
                        );
                      },
                    ),
                    const Text('8', style: TextStyle(color: kDarkGray)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResourcesList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildResourceCard(
          'Mindfulness Exercises',
          'Guided meditations and breathing techniques',
          Icons.self_improvement,
        ),
        _buildResourceCard(
          'Crisis Hotlines',
          'Immediate help when you need it most',
          Icons.emergency,
        ),
        _buildResourceCard(
          'Therapist Directory',
          'Find licensed professionals near you',
          Icons.medical_services,
        ),
        _buildResourceCard(
          'Support Groups',
          'Connect with others who understand',
          Icons.group,
        ),
      ],
    );
  }

  Widget _buildResourceCard(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: kMediumGray, width: 1),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kLightBlue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: kPrimaryNavy),
        ),
        title: Text(title, style: kCardTitleStyle),
        subtitle: Text(subtitle, style: kCardSubtitleStyle),
        trailing: const Icon(Icons.chevron_right, color: kPrimaryNavy),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title tapped!')),
          );
        },
      ),
    );
  }

  Widget _buildActivitiesList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActivityItem('Mindfulness Challenge', '5 day streak', Icons.emoji_events, kAccentTeal),
        _buildActivityItem('Journal Entries', '12 this month', Icons.book, kSecondaryBlue),
        _buildActivityItem('Support Groups', '3 attended', Icons.group, kPrimaryNavy),
        _buildActivityItem('Therapy Sessions', '4 completed', Icons.medical_services, Colors.green),
      ],
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: kMediumGray, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: kCardTitleStyle),
                  Text(subtitle, style: kCardSubtitleStyle),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: kDarkGray),
          ],
        ),
      ),
    );
  }

  // --- Bottom Navigation Bar (Copied from DashboardScreen for consistency) ---
  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: kWhite,
      elevation: 8,
      selectedItemColor: kPrimaryNavy, // Using kPrimaryNavy for selected items
      unselectedItemColor: kDarkGray,    // Using kDarkGray for unselected items
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
            case 2: // Exercises
              Navigator.pushReplacementNamed(context, '/exercise'); // Assuming '/exercise' is your ExercisesScreen route
              break;
            case 3: // Profile (this screen)
            // We are already on the profile screen, no navigation needed
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

// --- Create Post Widget ---
class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({super.key});

  @override
  _CreatePostWidgetState createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final TextEditingController _postTextController = TextEditingController();
  bool _isAnonymous = false;

  @override
  void dispose() {
    _postTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.close, color: kPrimaryNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create Post', style: kAppBarTitleStyle),
        actions: [
          TextButton(
            onPressed: () {
              print('Post button pressed with text: ${_postTextController.text}');
              Navigator.pop(context);
            },
            child: Text('POST', style: kButtonTextStyle.copyWith(color: kAccentTeal)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: kLightBlue,
                  backgroundImage: AssetImage('assets/images/profile.jpg'), // Updated to local asset
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Muhammad Arsal', // Updated
                      style: kBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Public',
                      style: kCardSubtitleStyle,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _postTextController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: kBodyTextStyle,
              cursorColor: kPrimaryNavy,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: kCardSubtitleStyle.copyWith(fontSize: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text('Post Anonymously', style: kBodyTextStyle),
              subtitle: Text('Your name and photo won\'t be shown', style: kCardSubtitleStyle),
              value: _isAnonymous,
              onChanged: (value) {
                setState(() {
                  _isAnonymous = value;
                });
              },
              activeColor: kAccentTeal,
            ),
            const SizedBox(height: 20),
            Text('Add to your post', style: kCardTitleStyle),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAddOption(Icons.photo_library_outlined, 'Photo', kAccentTeal),
                _buildAddOption(Icons.videocam_outlined, 'Video', kSecondaryBlue),
                _buildAddOption(Icons.emoji_emotions_outlined, 'Feeling', kPrimaryNavy),
                _buildAddOption(Icons.location_on_outlined, 'Location', Colors.green),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: kCardSubtitleStyle),
      ],
    );
  }
}

// --- Edit Profile Widget ---
class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  bool _obscurePassword = true;
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Muhammad Arsal'); // Updated Name
    _bioController = TextEditingController(text: 'Mental Health Advocate | Self-care Enthusiast');
    _emailController = TextEditingController(text: 'arsalchaddhar@gmail.com'); // Updated Email
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile', style: kAppBarTitleStyle),
        actions: [
          TextButton(
            onPressed: () {
              print('Save Changes button pressed');
              // You would typically save data here
              Navigator.pop(context);
            },
            child: Text('SAVE', style: kButtonTextStyle.copyWith(color: kAccentTeal)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                      border: Border.all(color: kPrimaryNavy, width: 2),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile.jpg'), // Use local asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: kWhite,
                        shape: BoxShape.circle,
                        border: Border.all(color: kPrimaryNavy),
                      ),
                      child: const Icon(Icons.camera_alt, size: 20, color: kPrimaryNavy),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Display Name', style: kCardTitleStyle),
            const SizedBox(height: 8),
            _buildTextField(_nameController, 'Enter your name'),
            const SizedBox(height: 24),
            Text('Bio', style: kCardTitleStyle),
            const SizedBox(height: 8),
            _buildTextField(_bioController, 'Tell others about yourself'),
            const SizedBox(height: 24),
            Text('Email', style: kCardTitleStyle),
            const SizedBox(height: 8),
            _buildTextField(_emailController, 'Enter your email', TextInputType.emailAddress),
            const SizedBox(height: 24),
            Text('Password', style: kCardTitleStyle),
            const SizedBox(height: 8),
            _buildPasswordField(),
            const SizedBox(height: 40),
            Text('Mental Health Preferences', style: kCardTitleStyle),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip('Anxiety'),
                _buildChip('Depression', isSelected: true), // Example selected chip
                _buildChip('Stress Management'),
                _buildChip('Mindfulness', isSelected: true),
                _buildChip('Self-Care'),
                _buildChip('Add Tag +'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, [TextInputType? keyboardType]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: kBodyTextStyle,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: kCardSubtitleStyle,
        filled: true,
        fillColor: kLightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: kBodyTextStyle,
      decoration: InputDecoration(
        hintText: 'Enter new password (optional)',
        hintStyle: kCardSubtitleStyle,
        filled: true,
        fillColor: kLightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: kDarkGray,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    // This is a stateless widget; its 'isSelected' state should be managed by the parent
    // or by converting this to a StatefulWidget if internal state is needed.
    // For now, I'm assuming 'isSelected' is passed correctly.
    // If you want interactive chips, you'd need to lift the state or make this stateful.
    return FilterChip(
      label: Text(label, style: TextStyle(color: isSelected ? kWhite : kPrimaryNavy)),
      selected: isSelected,
      onSelected: (bool selected) {
        // This won't update the UI directly if 'isSelected' is final.
        // For interactive chips, you'd typically have a state variable in the parent
        // or convert _buildChip to a StatefulWidget.
        print('$label chip selected: $selected');
      },
      backgroundColor: kWhite,
      selectedColor: kPrimaryNavy,
      shape: StadiumBorder(side: BorderSide(color: kPrimaryNavy)),
    );
  }
}