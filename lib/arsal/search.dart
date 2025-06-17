import 'package:flutter/material.dart';

// --- NEW THEME Color Constants: Bright White and Navy Blue ---
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or AI messages
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
const Color kErrorRed = Colors.redAccent; // Keeping red for errors

// --- Reusable Text Styles (Adjusted for the new theme) ---
final TextStyle _kAppBarTitleTextStyle = const TextStyle(
  color: kBrightWhite, // AppBar title is white on navy blue
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
);
final TextStyle _kSectionLabelTextStyle = const TextStyle(
  color: kNavyBlue, // Section labels are navy blue
  fontSize: 18,
  fontWeight: FontWeight.w600,
  fontFamily: 'Inter',
);
final TextStyle _kHintTextStyle = const TextStyle(
  color: kMediumGreyText, // Hints are medium grey
  fontSize: 16,
  fontFamily: 'Inter',
);

final TextStyle _kBodyTextStyle = const TextStyle(
  color: kDarkGreyText, // Default body text is dark grey
  fontSize: 16,
  fontFamily: 'Inter',
  fontWeight: FontWeight.normal,
);

final TextStyle _kResultItemTitleStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: kDarkGreyText, // Result item title is dark grey
  fontFamily: 'Inter',
);
final TextStyle _kResultItemSubtitleStyle = const TextStyle(
  fontSize: 14,
  color: kMediumGreyText, // Result item subtitle is medium grey
  fontFamily: 'Inter',
);

final TextStyle _kButtonTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: kBrightWhite, // Button text is white on navy blue
    fontFamily: 'Inter');
// --- End Reusable Text Styles ---


// --- Data Models ---
enum SearchResultType { group, professional, resource } // Changed types

class SearchResultItem {
  final String id;
  final String name;
  final String? focusArea; // Replaced sportType
  final String? location;
  final String? expertiseLevel; // Replaced skillLevel
  final SearchResultType type;
  final String? avatarUrl;
  final String? details;

  SearchResultItem({
    required this.id,
    required this.name,
    this.focusArea,
    this.location,
    this.expertiseLevel,
    required this.type,
    this.avatarUrl,
    this.details,
  });
}

class Search2Widget extends StatefulWidget {
  const Search2Widget({super.key});

  @override
  _Search2WidgetState createState() => _Search2WidgetState();
}

class _Search2WidgetState extends State<Search2Widget> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFocusArea;
  String? _selectedLocation;
  String? _selectedExpertiseLevel; // Renamed from skillLevel

  // Updated lists for mental health app
  final List<String> _focusAreas = ['Anxiety', 'Depression', 'Stress Management', 'Grief Support', 'Mindfulness', 'Trauma', 'Any'];
  final List<String> _locations = ['Online', 'New York', 'London', 'Paris', 'Remote', 'Any']; // Added Online/Remote
  final List<String> _expertiseLevels = ['Beginner', 'Intermediate', 'Advanced', 'Specialized', 'Any']; // Renamed and adjusted levels

  // Updated mock data for mental health support app
  final List<SearchResultItem> _allSearchableItems = [
    SearchResultItem(
        id: 'g1', name: 'Anxiety Support Group', focusArea: 'Anxiety', location: 'Online', expertiseLevel: 'Beginner', type: SearchResultType.group, details: "A safe space to share and learn coping strategies.", avatarUrl: "https://placehold.co/150/ADD8E6/000080?text=ASG&fontsize=40"),
    SearchResultItem(
        id: 'p1', name: 'Dr. Emily White', focusArea: 'Depression', location: 'London', expertiseLevel: 'Specialized', type: SearchResultType.professional, details: "Licensed therapist specializing in CBT for depression.", avatarUrl: "https://placehold.co/150/ADD8E6/000080?text=EW&fontsize=40"),
    SearchResultItem(
        id: 'r1', name: 'Mindful Living Resource', focusArea: 'Mindfulness', location: 'Online', expertiseLevel: 'Any', type: SearchResultType.resource, details: "Articles, guided meditations, and workshops.", avatarUrl: "https://placehold.co/150/ADD8E6/000080?text=MLR&fontsize=40"),
    SearchResultItem(
        id: 'g2', name: 'Grief & Loss Community', focusArea: 'Grief Support', location: 'Remote', expertiseLevel: 'Any', type: SearchResultType.group, details: "Connect with others experiencing loss and find comfort.", avatarUrl: "https://placehold.co/150/ADD8E6/000080?text=GLC&fontsize=40"),
    SearchResultItem(
        id: 'p2', name: 'Sarah Chen (Coach)', focusArea: 'Stress Management', location: 'New York', expertiseLevel: 'Intermediate', type: SearchResultType.professional, details: "Stress reduction coach for busy professionals.", avatarUrl: "https://placehold.co/150/ADD8E6/000080?text=SC&fontsize=40"),
    SearchResultItem(
        id: 'r2', name: 'Trauma Recovery Toolkit', focusArea: 'Trauma', location: 'Online', expertiseLevel: 'Advanced', type: SearchResultType.resource, details: "Tools and exercises for trauma-informed healing.", avatarUrl: "https://placehold.co/150/ADD8E6/000080?text=TRT&fontsize=40"),
  ];

  List<SearchResultItem> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _performSearch(isInitialLoad: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? currentValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _kSectionLabelTextStyle.copyWith(fontSize: 17)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: kLightBlueAccent.withOpacity(0.2), // Light blue accent for fill
            hintText: hint,
            hintStyle: _kHintTextStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kNavyBlue, width: 1.5), // Navy blue for focus
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          value: currentValue,
          icon: const Icon(Icons.arrow_drop_down, color: kNavyBlue), // Navy blue icon
          isExpanded: true,
          style: _kBodyTextStyle, // Used _kBodyTextStyle for dropdown value
          dropdownColor: kBrightWhite, // Bright white dropdown background
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: _kBodyTextStyle, // Ensured text in dropdown items is _kBodyTextStyle
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _performSearch({bool isInitialLoad = false}) {
    final String query = _searchController.text.toLowerCase().trim();
    bool focusFilterActive = _selectedFocusArea != null;
    bool locationFilterActive = _selectedLocation != null;
    bool expertiseFilterActive = _selectedExpertiseLevel != null;
    bool anyFilterActive = focusFilterActive || locationFilterActive || expertiseFilterActive;

    if (!isInitialLoad && query.isEmpty && !anyFilterActive) {
      setState(() => _searchResults = List.from(_allSearchableItems));
      return;
    }

    _searchResults = _allSearchableItems.where((item) {
      bool matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          (item.details?.toLowerCase().contains(query) ?? false) ||
          (item.focusArea?.toLowerCase().contains(query) ?? false) ||
          (item.location?.toLowerCase().contains(query) ?? false);
      bool matchesFocusArea = _selectedFocusArea == null || item.focusArea == _selectedFocusArea || item.focusArea == 'Any';
      bool matchesLocation = _selectedLocation == null || item.location == _selectedLocation || item.location == 'Any';
      bool matchesExpertise = _selectedExpertiseLevel == null || item.expertiseLevel == _selectedExpertiseLevel || item.expertiseLevel == 'Any';
      return matchesQuery && matchesFocusArea && matchesLocation && matchesExpertise;
    }).toList();
    setState(() {});
  }

  Widget _buildSearchResultsList() {
    bool filtersOrQueryActive = _searchController.text.isNotEmpty ||
        _selectedFocusArea != null ||
        _selectedLocation != null ||
        _selectedExpertiseLevel != null;

    if (_searchResults.isEmpty) {
      if (filtersOrQueryActive) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Center(
            child: Text(
              'No results found matching your criteria.\nTry adjusting your search or filters.',
              style: _kHintTextStyle.copyWith(color: kMediumGreyText), // Explicitly medium grey
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (_allSearchableItems.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Center(
            child: Text(
              'No resources, professionals, or groups available to search at the moment.',
              style: _kHintTextStyle.copyWith(color: kMediumGreyText), // Explicitly medium grey
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        IconData itemIcon;
        String itemTypeLabel;

        if (item.type == SearchResultType.group) {
          itemIcon = Icons.people_alt_outlined;
          itemTypeLabel = 'Support Group';
        } else if (item.type == SearchResultType.professional) {
          itemIcon = Icons.psychology_outlined;
          itemTypeLabel = 'Professional';
        } else { // SearchResultType.resource
          itemIcon = Icons.menu_book_outlined;
          itemTypeLabel = 'Resource';
        }

        return Card(
          color: kBrightWhite, // Card background is bright white
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.1), // Lighter shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: kLightBlueAccent.withOpacity(0.3), // Light blue accent for avatar background
              backgroundImage: item.avatarUrl != null && item.avatarUrl!.startsWith('http')
                  ? NetworkImage(item.avatarUrl!)
                  : null,
              child: item.avatarUrl == null || !item.avatarUrl!.startsWith('http')
                  ? Icon(
                itemIcon, // Use the dynamically determined icon
                color: kNavyBlue, // Navy blue icon
                size: 28,
              )
                  : null,
            ),
            title: Text(item.name, style: _kResultItemTitleStyle), // Dark grey
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.details != null && item.details!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    item.details!,
                    style: _kResultItemSubtitleStyle.copyWith(fontSize: 13.5), // Medium grey
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 5),
                Text(
                  '$itemTypeLabel • ${item.focusArea ?? "Any Focus"} • ${item.location ?? "Any Location"}', // Updated subtitle
                  style: _kResultItemSubtitleStyle.copyWith(
                      fontSize: 12.5, color: kMediumGreyText.withOpacity(0.85)), // Medium grey
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: kNavyBlue), // Navy blue arrow
            onTap: () {
              print('Tapped on: ${item.name} (Type: ${item.type}, ID: ${item.id})');
              // Define navigation based on the new SearchResultType
              if (item.type == SearchResultType.professional) {
                // Navigator.pushNamed(context, '/professional_detail', arguments: item);
                // Placeholder for navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigating to Professional: ${item.name}')),
                );
              } else if (item.type == SearchResultType.group) {
                // Navigator.pushNamed(context, '/group_detail', arguments: item);
                // Placeholder for navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigating to Group: ${item.name}')),
                );
              } else if (item.type == SearchResultType.resource) {
                // Navigator.pushNamed(context, '/resource_detail', arguments: item);
                // Placeholder for navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigating to Resource: ${item.name}')),
                );
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrightWhite, // **Applied white background here**
      appBar: AppBar(
        backgroundColor: kNavyBlue, // Navy blue app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kBrightWhite), // White icon
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // This case might mean it's the root or a direct entry. Adjust as per app flow.
              // For now, it will simply do nothing if no route to pop.
            }
          },
        ),
        title: Text('Find Support', style: _kAppBarTitleTextStyle), // White title
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
            top: 12.0, // Adjusted top padding after app bar
            left: 16.0,
            right: 16.0,
            bottom: 16.0
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _searchController,
              style: _kBodyTextStyle.copyWith(fontSize: 16.5, color: kDarkGreyText), // Dark grey text
              cursorColor: kNavyBlue, // Navy blue cursor
              decoration: InputDecoration(
                hintText: 'Search for groups, professionals, resources...', // Updated hint text
                hintStyle: _kHintTextStyle,
                prefixIcon: const Icon(Icons.search, color: kNavyBlue, size: 22), // Navy blue icon
                filled: true,
                fillColor: kLightBlueAccent.withOpacity(0.2), // Light blue accent fill
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: const BorderSide(color: kNavyBlue, width: 1.5), // Navy blue focus border
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onSubmitted: (_) => _performSearch(),
              onChanged: (text) {
                // _performSearch(); // Uncomment to search as you type (consider debouncing)
              },
            ),
            const SizedBox(height: 24),
            _buildDropdownField(
              label: 'Focus Area',
              hint: 'Any Focus Area',
              currentValue: _selectedFocusArea,
              items: _focusAreas,
              onChanged: (String? newValue) {
                setState(() => _selectedFocusArea = (newValue == 'Any' || newValue == null) ? null : newValue);
                _performSearch(); // Trigger search on filter change
              },
            ),
            const SizedBox(height: 20),
            _buildDropdownField(
              label: 'Location',
              hint: 'Any Location',
              currentValue: _selectedLocation,
              items: _locations,
              onChanged: (String? newValue) {
                setState(() => _selectedLocation = (newValue == 'Any' || newValue == null) ? null : newValue);
                _performSearch(); // Trigger search on filter change
              },
            ),
            const SizedBox(height: 20),
            _buildDropdownField(
              label: 'Expertise Level',
              hint: 'Any Expertise Level',
              currentValue: _selectedExpertiseLevel,
              items: _expertiseLevels,
              onChanged: (String? newValue) {
                setState(() => _selectedExpertiseLevel = (newValue == 'Any' || newValue == null) ? null : newValue);
                _performSearch(); // Trigger search on filter change
              },
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              icon: const Icon(Icons.search_rounded, color: kBrightWhite, size: 22), // White icon
              label: Text('SEARCH', style: _kButtonTextStyle.copyWith(fontSize: 17)),
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavyBlue, // Navy blue button
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                minimumSize: const Size(double.infinity, 52),
                elevation: 3,
              ),
              onPressed: () => _performSearch(isInitialLoad: false),
            ),
            const SizedBox(height: 28),
            if (_searchResults.isNotEmpty || _searchController.text.isNotEmpty || _selectedFocusArea != null || _selectedLocation != null || _selectedExpertiseLevel != null)
              Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                child: Text(
                    _searchResults.isNotEmpty ? 'Results (${_searchResults.length})' : 'Results',
                    style: _kSectionLabelTextStyle.copyWith(fontSize: 19) // Navy blue
                ),
              ),
            _buildSearchResultsList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}