import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PFT Scavenger Hunt',
      theme: ThemeData(
        fontFamily: 'ProximaNova',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    MapScreen(),
    LocationsScreen(),
    GamesScreen(),
    HelpScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA39AAC),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5A2B8C), // Lighter purple for top
              Color(0xFF461D7C), // Main purple for middle
              Color(0xFF3A1B6C), // Darker purple for bottom
            ],
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFFFDD023),
          unselectedItemColor: const Color(0xFFD29F13),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Locations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.games),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help),
              label: 'Help',
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TransformationController _transformationController =
      TransformationController();
  bool _showFloorButtons = false;
  String _currentFloor = 'First Floor';

  String _getMapImagePath() {
    switch (_currentFloor) {
      case 'First Floor':
        return 'assets/images/pftfirstfloormap.png';
      case 'Second Floor':
        return 'assets/images/pftsecondfloormap.png';
      case 'Third Floor':
        return 'assets/images/pftthirdfloormap.png';
      default:
        return 'assets/images/pftfirstfloormap.png';
    }
  }

  final double _imageAspectRatio = 2647 / 2200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text(
          'Patrick F. Taylor Hall Map',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFDD023),
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Color(0xFF000000),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF5A2B8C), // Lighter purple for top
                Color(0xFF461D7C), // Main purple for middle
                Color(0xFF3A1B6C), // Darker purple for bottom
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.all(100.0),
              minScale: 0.5,
              maxScale: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 175),
                  AspectRatio(
                    aspectRatio: _imageAspectRatio,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final height = constraints.maxHeight;

                        return Stack(
                          children: [
                            SizedBox(
                              width: width,
                              height: height,
                              child: Image.asset(
                                _getMapImagePath(),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              left: width * 0.3,
                              top: height * 0.4,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 32,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 175),
                ],
              ),
            ),
          ),
          if (_showFloorButtons)
            Positioned(
              left: 16,
              bottom: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFloorButton('First Floor', Icons.looks_one),
                  const SizedBox(height: 8),
                  _buildFloorButton('Second Floor', Icons.looks_two),
                  const SizedBox(height: 8),
                  _buildFloorButton('Third Floor', Icons.looks_3),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _showFloorButtons = !_showFloorButtons;
            });
          },
          backgroundColor: const Color(0xFF461D7C),
          child: const Icon(
            Icons.layers,
            color: Color(0xFFFDD023),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildFloorButton(String floor, IconData icon) {
    final isSelected = _currentFloor == floor;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 4,
      child: InkWell(
        onTap: () {
          setState(() {
            _currentFloor = floor;
            _transformationController.value = Matrix4.identity();
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF461D7C) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF461D7C) : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                floor,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF461D7C) : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationInfo {
  final String floor;
  final String hall;
  final String title;
  final String subtitle;
  final String description;

  LocationInfo({
    required this.floor,
    required this.hall,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<LocationInfo> allLocationData = [
    LocationInfo(
      floor: 'First Floor',
      hall: '1100s Hall',
      title: 'Reception Area (1101)',
      subtitle: 'Main entrance and information desk',
      description: 'Located at the front of the building, near the main doors.',
    ),
    LocationInfo(
      floor: 'First Floor',
      hall: '1100s Hall',
      title: 'Conference Room A (1102)',
      subtitle: 'Large meeting space',
      description:
          'Capacity: 20 people. Equipped with projector and whiteboard.',
    ),
    LocationInfo(
      floor: 'First Floor',
      hall: '1200s Hall',
      title: 'Break Room (1201)',
      subtitle: 'Employee lounge and kitchen',
      description: 'Features vending machines, microwave, and seating area.',
    ),
    LocationInfo(
      floor: 'Second Floor',
      hall: '2100s Hall',
      title: 'HR Office (2101)',
      subtitle: 'Human Resources Department',
      description: 'Employee records and personnel management.',
    ),
    LocationInfo(
      floor: 'Third Floor',
      hall: '3100s Hall',
      title: 'Misc Office (3100)',
      subtitle: 'Blank',
      description: 'Blank',
    ),
  ];

  List<LocationInfo> get filteredData {
    if (_searchQuery.isEmpty) return allLocationData;
    final query = _searchQuery.toLowerCase();
    return allLocationData.where((loc) {
      return loc.title.toLowerCase().contains(query) ||
          loc.subtitle.toLowerCase().contains(query) ||
          loc.description.toLowerCase().contains(query);
    }).toList();
  }

  List<Widget> _buildFilteredLocations() {
    if (_searchQuery.isNotEmpty) {
      final groupedByFloor = <String, List<LocationInfo>>{};
      for (final loc in filteredData) {
        groupedByFloor.putIfAbsent(loc.floor, () => []).add(loc);
      }
      return groupedByFloor.entries.map((entry) {
        return _buildLocationSection(
          entry.key,
          entry.value.map((loc) => _buildFlatLocationTile(loc)).toList(),
        );
      }).toList();
    }

    final grouped = <String, Map<String, List<LocationInfo>>>{};
    for (final loc in allLocationData) {
      grouped.putIfAbsent(loc.floor, () => {});
      grouped[loc.floor]!.putIfAbsent(loc.hall, () => []);
      grouped[loc.floor]![loc.hall]!.add(loc);
    }
    return grouped.entries.map((floorEntry) {
      final floor = floorEntry.key;
      final halls = floorEntry.value;
      return _buildLocationSection(
        floor,
        halls.entries.map((hallEntry) {
          return _buildHallSection(
            hallEntry.key,
            hallEntry.value.map(_buildLocationTile).toList(),
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA39AAC),
      appBar: AppBar(
        title: const Text(
          'Locations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFDD023),
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Color(0xFF000000),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF5A2B8C),
                Color(0xFF461D7C),
                Color(0xFF3A1B6C),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFFA39AAC),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by room number, name, or description...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF333333)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF333333)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF333333)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF333333)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF333333), width: 2),
                ),
                filled: true,
                fillColor: const Color(0xFF8B7F9C),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                hintStyle: const TextStyle(color: Color(0xFF333333)),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Found ${filteredData.length} matching location${filteredData.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Color(0xFF461D7C),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: _buildFilteredLocations(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(String title, List<Widget> halls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF461D7C),
            ),
          ),
        ),
        Card(
          elevation: 2,
          color: const Color(0xFFF5F3F7),
          child: Column(
            children: halls,
          ),
        ),
      ],
    );
  }

  Widget _buildHallSection(String title, List<Widget> locations) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF461D7C),
            ),
          ),
        ),
        Column(
          children: locations,
        ),
      ],
    );
  }

  Widget _buildLocationTile(LocationInfo loc) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF461D7C),
        ),
      ),
      child: ExpansionTile(
        title: Text(
          loc.title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Color(0xFF333333)),
        ),
        subtitle: Text(
          loc.subtitle,
          style: const TextStyle(color: Color(0xFF461D7C)),
        ),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              loc.description,
              style: const TextStyle(color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlatLocationTile(LocationInfo loc) {
    return ListTile(
      title: Text(
        loc.title,
        style: const TextStyle(
            fontWeight: FontWeight.w600, color: Color(0xFF333333)),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.subtitle, style: const TextStyle(color: Color(0xFF461D7C))),
          const SizedBox(height: 4),
          Text(loc.description,
              style: const TextStyle(color: Color(0xFF333333))),
        ],
      ),
      isThreeLine: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA39AAC),
      appBar: AppBar(
        title: const Text(
          'Games',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFDD023),
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Color(0xFF000000),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF5A2B8C), // Lighter purple for top
                Color(0xFF461D7C), // Main purple for middle
                Color(0xFF3A1B6C), // Darker purple for bottom
              ],
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Games Screen'),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA39AAC),
      appBar: AppBar(
        title: const Text(
          'Help',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFDD023),
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Color(0xFF000000),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF5A2B8C), // Lighter purple for top
                Color(0xFF461D7C), // Main purple for middle
                Color(0xFF3A1B6C), // Darker purple for bottom
              ],
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Help Screen'),
      ),
    );
  }
}
