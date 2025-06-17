import 'package:flutter/material.dart';
import 'dart:math'; // For generating random content

// --- NEW THEME Color Constants: Bright White and Navy Blue ---
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or AI messages
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
const Color kErrorRed = Colors.redAccent; // Keeping red for errors

// --- Reusable Text Styles (Adjusted for the new theme) ---
const String _kFontFamily = 'Inter';

TextStyle get _kAppBarTitleTextStyle => const TextStyle(
  color: kBrightWhite, // AppBar title is white on navy blue
  fontFamily: _kFontFamily,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

TextStyle get _kGroupTitleTextStyle => const TextStyle(
  color: kDarkGreyText, // Group name on bright white background is dark grey
  fontFamily: _kFontFamily,
  fontSize: 28,
  fontWeight: FontWeight.bold,
  height: 1.25,
);

TextStyle get _kSectionTitleTextStyle => const TextStyle(
  color: kNavyBlue, // Section titles are navy blue
  fontFamily: _kFontFamily,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  height: 1.6,
);

TextStyle get _kItemTitleTextStyle => const TextStyle(
  color: kDarkGreyText, // Item titles on bright white background are dark grey
  fontFamily: _kFontFamily,
  fontSize: 16,
  fontWeight: FontWeight.w500,
  height: 1.5,
);

TextStyle get _kItemSubtitleTextStyle => const TextStyle(
  color: kMediumGreyText, // Item subtitles are medium grey
  fontFamily: _kFontFamily,
  fontSize: 14,
  fontWeight: FontWeight.normal,
  height: 1.4285714285714286,
);

TextStyle get _kPostContentTextStyle => const TextStyle(
  color: kDarkGreyText, // Post content on white/light gray cards should be dark grey
  fontFamily: _kFontFamily,
  fontSize: 15,
  height: 1.4,
);

TextStyle get _kPostMetaTextStyle => const TextStyle(
  color: kMediumGreyText, // Post meta info on white/light gray cards should be medium grey
  fontFamily: _kFontFamily,
  fontSize: 12,
);

TextStyle get _kButtonTextStyle => const TextStyle(
  color: kBrightWhite, // White text on navy blue button
  fontFamily: _kFontFamily,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  height: 1.375,
);


class GroupDetail extends StatefulWidget {
  const GroupDetail({Key? key}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  // --- Placeholder Data ---
  final String _groupName = 'Nature Lovers Club';
  final String _groupDescription =
      'Join us for monthly hikes and outdoor adventures! We explore local trails, share nature photography, and promote conservation. All skill levels welcome.';
  final String _groupCoverImageUrl = ''; // Keep as empty string to show placeholder
  final String _adminName = 'John Doe';
  final String _adminRole = 'Hiking Enthusiast (Admin)';
  final String _member1Name = 'Jane Smith';
  final String _member1Role = 'Outdoor Explorer';
  final String _member2Name = 'Mike Green';
  final String _member2Role = 'Bird Watcher';

  // Example state for the button
  bool _isJoined = false;

  // Random posts data
  final List<Map<String, String>> _posts = [
    {
      'author': 'John Doe',
      'time': '2 hours ago',
      'content': 'Had an amazing hike on the Skyline Trail today! The views were breathtaking. Don\'t forget to stay hydrated!',
      'image': 'https://picsum.photos/seed/hike1/400/300', // Example random image
    },
    {
      'author': 'Jane Smith',
      'time': 'Yesterday',
      'content': 'Spotted a rare blue jay during my morning walk. Nature always has surprises in store! 🐦',
      'image': 'https://picsum.photos/seed/bird2/400/300',
    },
    {
      'author': 'Mike Green',
      'time': '3 days ago',
      'content': 'Planning a campfire and stargazing night next month. Who\'s in? ✨',
      'image': '', // No image for this post
    },
    {
      'author': 'John Doe',
      'time': '1 week ago',
      'content': 'Just a reminder about our upcoming meetup on October 15th at City Park. See you all there!',
      'image': '',
    },
  ];

  void _onJoinGroupPressed() {
    setState(() {
      _isJoined = !_isJoined;
    });
    print(_isJoined ? 'Joined $_groupName' : 'Left $_groupName');

    if (_isJoined) {
      // You might want to show a SnackBar or confirmation here instead of popping immediately
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have joined $_groupName!')),
      );
      // Navigator.pop(context); // Optional: go back after joining, depends on UX
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have left $_groupName.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrightWhite, // **Applied white background here**
      appBar: AppBar(
        backgroundColor: kNavyBlue, // Navy blue app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kBrightWhite), // White back icon
          onPressed: () {
            Navigator.pop(context); // Use pop for back navigation
          },
        ),
        title: Text(
          'Group Details',
          style: _kAppBarTitleTextStyle, // White title
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Adjusted padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Group Cover Image / Placeholder ---
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _groupCoverImageUrl.isNotEmpty
                    ? Image.network(
                  _groupCoverImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: kLightBlueAccent.withOpacity(0.3), // Themed placeholder
                    child: Center(
                      child: Icon(Icons.photo_library, size: 80, color: kNavyBlue), // Themed icon
                    ),
                  ),
                )
                    : Container(
                  height: 200,
                  width: double.infinity,
                  color: kLightBlueAccent.withOpacity(0.3), // Themed placeholder
                  child: Center(
                    child: Icon(Icons.photo_library, size: 80, color: kNavyBlue), // Themed icon
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // More space after image

            // --- Group Name & Description ---
            Text(
              _groupName,
              style: _kGroupTitleTextStyle, // Dark grey text
            ),
            const SizedBox(height: 10), // Adjusted spacing
            Text(
              _groupDescription,
              style: _kItemSubtitleTextStyle.copyWith(color: kDarkGreyText.withOpacity(0.7)), // Dark grey description
            ),
            const SizedBox(height: 24), // More space

            // --- Location Info ---
            _buildInfoRow(Icons.location_on_outlined, 'Location', 'City Park, Main Entrance'),
            const SizedBox(height: 16), // Adjusted spacing
            // --- Next Meetup Info ---
            _buildInfoRow(Icons.calendar_today_outlined, 'Next Meetup', 'October 15, 2023'),
            const SizedBox(height: 24),

            // --- Divider ---
            const Divider(color: kLightBlueAccent, thickness: 0.5), // Light blue accent divider
            const SizedBox(height: 20),

            // --- Members Section ---
            Text('Members', style: _kSectionTitleTextStyle), // Navy blue title
            const SizedBox(height: 12),
            _buildUserChip(_adminName, _adminRole),
            const SizedBox(height: 12),
            _buildUserChip(_member1Name, _member1Role),
            const SizedBox(height: 12),
            _buildUserChip(_member2Name, _member2Role),
            const SizedBox(height: 32),

            // --- Join Group Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isJoined ? kMediumGreyText : kNavyBlue, // Medium grey when joined, navy blue when not
                  foregroundColor: kBrightWhite, // White text
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: _isJoined ? 0 : 4,
                ),
                onPressed: _onJoinGroupPressed,
                child: Text(
                  _isJoined ? 'Joined' : 'Join Group',
                  style: _kButtonTextStyle, // White text
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- Divider ---
            const Divider(color: kLightBlueAccent, thickness: 0.5), // Light blue accent divider
            const SizedBox(height: 20),

            // --- Posts Section ---
            Text('Posts', style: _kSectionTitleTextStyle), // Navy blue title
            const SizedBox(height: 16), // Adjusted spacing
            // Iterate through posts and build them
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return _buildPostCard(
                  post['author']!,
                  post['time']!,
                  post['content']!,
                  post['image']!,
                );
              },
            ),
            const SizedBox(height: 20), // Spacing at the bottom
          ],
        ),
      ),
    );
  }

  // Helper widget for info rows
  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: kNavyBlue), // Navy blue icon
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: _kItemTitleTextStyle), // Dark grey text
              const SizedBox(height: 2),
              Text(subtitle, style: _kItemSubtitleTextStyle), // Medium grey text
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget for member chips
  Widget _buildUserChip(String name, String role, {String? avatarUrl}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: kLightBlueAccent.withOpacity(0.3), // Light blue accent with opacity
          backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty) ? NetworkImage(avatarUrl) : null,
          child: (avatarUrl == null || avatarUrl.isEmpty)
              ? Text(name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: TextStyle(color: kDarkGreyText, fontWeight: FontWeight.bold)) // Dark grey text
              : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: _kItemTitleTextStyle), // Dark grey text
            Text(role, style: _kItemSubtitleTextStyle), // Medium grey text
          ],
        ),
      ],
    );
  }

  // Helper widget for building a post card
  Widget _buildPostCard(String author, String time, String content, String imageUrl) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4, // Increased elevation for better pop on light background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: kBrightWhite, // Post card background is bright white
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: kLightBlueAccent.withOpacity(0.3), // Light blue accent with opacity
                  child: Text(author[0].toUpperCase(), style: TextStyle(color: kDarkGreyText, fontWeight: FontWeight.bold)), // Dark grey text
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: _kPostContentTextStyle.copyWith(fontWeight: FontWeight.bold)), // Author name dark grey
                    Text(time, style: _kPostMetaTextStyle), // Post meta info medium grey
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: _kPostContentTextStyle, // Post content dark grey
            ),
            if (imageUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 160,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: kLightBlueAccent.withOpacity(0.3), // Placeholder background light blue accent
                    child: Center(
                      child: Icon(Icons.broken_image, size: 50, color: kMediumGreyText), // Placeholder icon medium grey
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Example of post actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPostAction(Icons.thumb_up_alt_outlined, 'Like'),
                _buildPostAction(Icons.comment_outlined, 'Comment'),
                _buildPostAction(Icons.share_outlined, 'Share'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostAction(IconData icon, String text) {
    return InkWell(
      onTap: () {
        print('$text action tapped');
        // Implement actual action (e.g., like, comment, share)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$text action coming soon!')),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 18, color: kNavyBlue), // Icon color navy blue
            const SizedBox(width: 4),
            Text(text, style: _kPostMetaTextStyle.copyWith(color: kNavyBlue)), // Text color navy blue
          ],
        ),
      ),
    );
  }
}