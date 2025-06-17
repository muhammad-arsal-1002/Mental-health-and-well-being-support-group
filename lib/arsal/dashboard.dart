// dashboard_screen.dart (Updated Social Media Dashboard with Navigation)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome
import 'dart:math'; // For random image selection

// --- NEW THEME Color Constants: Bright White and Navy Blue ---
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or AI messages
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
const Color kErrorRed = Colors.redAccent; // Keeping red for errors

// --- Data Models ---
class Story {
  final String userName;
  final bool isViewed;
  final String? imageUrl; // Can be a local asset path or an internet URL

  Story({
    required this.userName,
    this.isViewed = false,
    this.imageUrl,
  });
}

class Post {
  final String userName;
  final String timeAgo;
  final String content;
  final String? imageUrl; // Now directly holds the image URL (from internet or local)
  int likes;
  int comments;
  bool isLiked;

  Post({
    required this.userName,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });
}

// --- Main Dashboard Widget ---
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Random _random = Random();

  // Function to generate a random Lorem Picsum URL
  String _getRandomInternetImageUrl({int width = 400, int height = 300}) {
    return 'https://picsum.photos/seed/${_random.nextInt(1000)}/$width/$height';
  }

  late final List<Story> _stories;
  late final List<Post> _posts;

  int _currentBottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set status bar icons to dark for light app bar background
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      statusBarColor: kBrightWhite,
    ));

    // Initialize stories with random internet images, and your profile pic
    _stories = [
      Story(userName: 'You', imageUrl: 'assets/images/profile.jpg'), // Your profile pic
      Story(userName: 'Sarah', imageUrl: _getRandomInternetImageUrl()),
      Story(userName: 'Mike', isViewed: true, imageUrl: _getRandomInternetImageUrl()),
      Story(userName: 'Laura', imageUrl: _getRandomInternetImageUrl()),
      Story(userName: 'David', imageUrl: _getRandomInternetImageUrl()),
      Story(userName: 'Emily', imageUrl: _getRandomInternetImageUrl()),
      Story(userName: 'John', imageUrl: _getRandomInternetImageUrl()),
    ];

    // Initialize posts with random internet images where applicable
    _posts = [
      Post(
        userName: 'Wellness Hub',
        timeAgo: '2h ago',
        content: 'Just a reminder that you are strong and can overcome this. Take deep breaths and focus on the present. #Mindfulness #Strength',
        likes: 120,
        comments: 15,
      ),
      Post(
        userName: 'Mental Health Matters',
        timeAgo: '5h ago',
        content: 'It\'s okay not to be okay. Reach out if you need someone to talk to. We have a supportive community waiting for you. Link in bio.',
        imageUrl: _getRandomInternetImageUrl(width: 600, height: 400),
        likes: 256,
        comments: 32,
        isLiked: true,
      ),
      Post(
        userName: 'Meditation Zone',
        timeAgo: '1 day ago',
        content: 'Join our daily meditation session at 7 PM to find inner peace. Today\'s focus: Gratitude. 🙏',
        likes: 98,
        comments: 7,
      ),
      Post(
        userName: 'Support Group Connect',
        timeAgo: '12h ago',
        content: 'Our weekly Anxiety & Depression Support Group meets tonight at 8 PM EST on Zoom. It\'s a safe space to share and listen. DM for link! #SupportGroup #Community',
        imageUrl: _getRandomInternetImageUrl(width: 600, height: 400),
        likes: 75,
        comments: 10,
      ),
      Post(
        userName: 'Fitness for Mind',
        timeAgo: '1 day ago',
        content: 'Morning stretch routine for mental clarity! Try 10 minutes of gentle yoga. It helps release tension and improves focus. #Exercise #Wellbeing #Yoga',
        imageUrl: _getRandomInternetImageUrl(width: 600, height: 400),
        likes: 150,
        comments: 20,
      ),
      Post(
        userName: 'Calm Corner',
        timeAgo: '2 days ago',
        content: 'Discover the power of progressive muscle relaxation. Tense and release different muscle groups to calm your body and mind. A great exercise before sleep! #Relaxation #StressRelief',
        imageUrl: _getRandomInternetImageUrl(width: 600, height: 400),
        likes: 110,
        comments: 12,
      ),
      Post(
        userName: 'Anxiety Busters',
        timeAgo: '2 days ago',
        content: 'Sharing my favorite breathing technique: Inhale for 4, hold for 7, exhale for 8. It really helps calm the nerves. Try it out!',
        likes: 180,
        comments: 22,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kLightBlueAccent.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: kBrightWhite,
        elevation: 1.0,
        title: Text(
          'Mental Health Support App',
          style: TextStyle(
            color: kNavyBlue,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.055,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: kDarkGreyText, size: screenWidth * 0.065),
            onPressed: () {
              // --- Navigation for Search ---
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: Icon(Icons.menu, color: kDarkGreyText, size: screenWidth * 0.065),
            onPressed: () {
              // If you have a Drawer in your Scaffold, uncomment the line below.
              // Scaffold.of(context).openEndDrawer();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu functionality coming soon!')),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _buildStoriesSection(screenWidth),
          ),
          SliverToBoxAdapter(
            child: _buildCreatePostPlaceholder(screenWidth),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return PostWidget(post: _posts[index], screenWidth: screenWidth);
              },
              childCount: _posts.length,
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            // --- Navigation for Talk to AI ---
            Navigator.pushNamed(context, '/Aitalk');
          },
          icon: Icon(Icons.chat_bubble_outline, size: screenWidth * 0.05, color: kBrightWhite),
          label: Text(
            'Talk to AI',
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: kBrightWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kNavyBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.025),
            elevation: 4.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNavigationBar(screenWidth),
    );
  }

  Widget _buildStoriesSection(double screenWidth) {
    return Container(
      color: kBrightWhite,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      height: screenWidth * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          return StoryWidget(story: _stories[index], screenWidth: screenWidth);
        },
      ),
    );
  }

  Widget _buildCreatePostPlaceholder(double screenWidth) {
    return Container(
      color: kBrightWhite,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: screenWidth * 0.05,
            backgroundColor: kLightBlueAccent.withOpacity(0.3),
            child: Icon(Icons.person, color: kMediumGreyText, size: screenWidth * 0.06),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "What's on your mind, Arsal?",
                hintStyle: TextStyle(fontSize: screenWidth * 0.038, color: kMediumGreyText),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: kLightBlueAccent.withOpacity(0.3),
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 0),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create post functionality coming soon!')),
                );
              },
              readOnly: true,
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          IconButton(
            icon: Icon(Icons.photo_library, color: kNavyBlue, size: screenWidth * 0.065),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adding photo functionality coming soon!')),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(double screenWidth) {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: (index) {
        setState(() {
          _currentBottomNavIndex = index;
        });
        switch (index) {
          case 0:
          // Already on Home/Feed, no specific navigation needed
            break;
          case 1:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigating to Groups...')),
            );
             Navigator.pushNamed(context, '/group1');
            break;
          case 2:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigating to Exercises...')),
            );
             Navigator.pushNamed(context, '/exercise');
            break;
          case 3:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigating to Profile...')),
            );
             Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kNavyBlue,
      unselectedItemColor: kMediumGreyText,
      selectedFontSize: screenWidth * 0.03,
      unselectedFontSize: screenWidth * 0.028,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Exercises'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

// --- Story Widget ---
class StoryWidget extends StatelessWidget {
  final Story story;
  final double screenWidth;

  const StoryWidget({Key? key, required this.story, required this.screenWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      width: screenWidth * 0.2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: story.isViewed ? kMediumGreyText : kNavyBlue,
                width: 2.5,
              ),
            ),
            child: CircleAvatar(
              radius: screenWidth * 0.07,
              backgroundColor: kLightBlueAccent.withOpacity(0.3),
              backgroundImage: story.imageUrl != null
                  ? story.imageUrl!.startsWith('assets/')
                  ? AssetImage(story.imageUrl!) as ImageProvider<Object>?
                  : NetworkImage(story.imageUrl!) as ImageProvider<Object>?
                  : null,
              child: story.imageUrl == null
                  ? Text(
                story.userName.substring(0, 1).toUpperCase(),
                style: TextStyle(color: kDarkGreyText, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
              )
                  : null,
            ),
          ),
          SizedBox(height: screenWidth * 0.015),
          Text(
            story.userName,
            style: TextStyle(fontSize: screenWidth * 0.03, color: kDarkGreyText),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// --- Post Widget ---
class PostWidget extends StatefulWidget {
  final Post post;
  final double screenWidth;

  const PostWidget({Key? key, required this.post, required this.screenWidth}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: EdgeInsets.all(widget.screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header (Avatar, Name, Time)
            Row(
              children: [
                CircleAvatar(
                  radius: widget.screenWidth * 0.05,
                  backgroundColor: kLightBlueAccent.withOpacity(0.3),
                  child: Text(
                    widget.post.userName.substring(0, 1).toUpperCase(),
                    style: TextStyle(color: kDarkGreyText, fontWeight: FontWeight.bold, fontSize: widget.screenWidth * 0.035),
                  ),
                ),
                SizedBox(width: widget.screenWidth * 0.025),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.screenWidth * 0.04,
                          color: kDarkGreyText,
                        ),
                      ),
                      Text(
                        widget.post.timeAgo,
                        style: TextStyle(fontSize: widget.screenWidth * 0.03, color: kMediumGreyText),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: kMediumGreyText, size: widget.screenWidth * 0.06),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('More options coming soon!')),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: widget.screenWidth * 0.03),

            // Post Content
            Text(
              widget.post.content,
              style: TextStyle(fontSize: widget.screenWidth * 0.038, height: 1.4, color: kDarkGreyText),
            ),
            if (widget.post.imageUrl != null) ...[
              SizedBox(height: widget.screenWidth * 0.03),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.post.imageUrl!,
                  width: double.infinity,
                  height: widget.screenWidth * 0.5,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: widget.screenWidth * 0.5,
                      color: kLightBlueAccent.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                          color: kNavyBlue,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: kLightBlueAccent.withOpacity(0.3),
                      height: widget.screenWidth * 0.5,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: widget.screenWidth * 0.2,
                          color: kMediumGreyText,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: widget.screenWidth * 0.025),

            // Post Stats (Likes, Comments)
            Row(
              children: [
                Icon(Icons.thumb_up_alt_rounded, size: widget.screenWidth * 0.04, color: kNavyBlue),
                SizedBox(width: widget.screenWidth * 0.01),
                Text(
                  '${widget.post.likes}',
                  style: TextStyle(fontSize: widget.screenWidth * 0.032, color: kDarkGreyText),
                ),
                const Spacer(),
                Text(
                  '${widget.post.comments} Comments',
                  style: TextStyle(fontSize: widget.screenWidth * 0.032, color: kMediumGreyText),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 0.5),

            // Post Actions (Like, Comment, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPostActionButton(
                  screenWidth: widget.screenWidth,
                  icon: widget.post.isLiked ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                  label: 'Like',
                  color: widget.post.isLiked ? kNavyBlue : kMediumGreyText,
                  onTap: () {
                    setState(() {
                      widget.post.isLiked = !widget.post.isLiked;
                      if (widget.post.isLiked) {
                        widget.post.likes++;
                      } else {
                        widget.post.likes--;
                      }
                    });
                  },
                ),
                _buildPostActionButton(
                  screenWidth: widget.screenWidth,
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Comment',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Comment functionality coming soon!')),
                    );
                  },
                ),
                _buildPostActionButton(
                  screenWidth: widget.screenWidth,
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share functionality coming soon!')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostActionButton({
    required double screenWidth,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025, horizontal: screenWidth * 0.03),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: screenWidth * 0.05, color: color ?? kMediumGreyText),
            SizedBox(width: screenWidth * 0.02),
            Text(
              label,
              style: TextStyle(color: color ?? kMediumGreyText, fontWeight: FontWeight.w500, fontSize: screenWidth * 0.035),
            ),
          ],
        ),
      ),
    );
  }
}