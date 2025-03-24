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
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

  final double _imageAspectRatio = 2647 / 2200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: const EdgeInsets.all(100.0),
          minScale: 0.5,
          maxScale: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 150),
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
                            'assets/images/pftmap.png',
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
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _expandedHalls = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Widget> _buildFilteredLocations() {
    final List<Widget> allLocations = [
      _buildLocationSection(
        'First Floor',
        [
          _buildHallSection(
            '1100s Hall',
            [
              _buildLocationTile(
                'Reception Area (1101)',
                'Main entrance and information desk',
                'Located at the front of the building, near the main doors.',
              ),
              _buildLocationTile(
                'Conference Room A (1102)',
                'Large meeting space',
                'Capacity: 20 people. Equipped with projector and whiteboard.',
              ),
            ],
          ),
          _buildHallSection(
            '1200s Hall',
            [
              _buildLocationTile(
                'Break Room (1201)',
                'Employee lounge and kitchen',
                'Features vending machines, microwave, and seating area.',
              ),
              _buildLocationTile(
                'IT Department (1202)',
                'Technical support and equipment',
                'Computer repair and maintenance services.',
              ),
            ],
          ),
          _buildHallSection(
            '1300s Hall',
            [
              _buildLocationTile(
                'Security Office (1301)',
                'Building security and access control',
                '24/7 monitoring and badge access management.',
              ),
              _buildLocationTile(
                'Mail Room (1302)',
                'Mail and package handling',
                'Central mail distribution and package receiving.',
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildLocationSection(
        'Second Floor',
        [
          _buildHallSection(
            '2100s Hall',
            [
              _buildLocationTile(
                'HR Office (2101)',
                'Human Resources Department',
                'Employee records and personnel management.',
              ),
              _buildLocationTile(
                'Training Room (2102)',
                'Professional development space',
                'Equipped with interactive learning tools.',
              ),
            ],
          ),
          _buildHallSection(
            '2200s Hall',
            [
              _buildLocationTile(
                'Executive Offices (2201)',
                'Senior management workspace',
                'Private offices for department heads.',
              ),
              _buildLocationTile(
                'Board Room (2202)',
                'Executive meeting space',
                'High-level meetings and presentations.',
              ),
            ],
          ),
          _buildHallSection(
            '2300s Hall',
            [
              _buildLocationTile(
                'Marketing Department (2301)',
                'Marketing and communications',
                'Creative workspace and meeting areas.',
              ),
              _buildLocationTile(
                'Client Meeting Room (2302)',
                'Client consultation space',
                'Professional meeting environment for client interactions.',
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildLocationSection(
        'Third Floor',
        [
          _buildHallSection(
            '3100s Hall',
            [
              _buildLocationTile(
                'Research Lab (3101)',
                'Innovation and development center',
                'State-of-the-art equipment and testing facilities.',
              ),
              _buildLocationTile(
                'Lab Office (3102)',
                'Research administration',
                'Research documentation and analysis.',
              ),
            ],
          ),
          _buildHallSection(
            '3200s Hall',
            [
              _buildLocationTile(
                'Data Center (3201)',
                'Server and network infrastructure',
                'Climate-controlled environment for critical systems.',
              ),
              _buildLocationTile(
                'Network Operations (3202)',
                'Network management center',
                'Network monitoring and maintenance.',
              ),
            ],
          ),
          _buildHallSection(
            '3300s Hall',
            [
              _buildLocationTile(
                'Archives (3301)',
                'Document storage and records',
                'Secure storage for historical documents.',
              ),
              _buildLocationTile(
                'Records Office (3302)',
                'Records management',
                'Document processing and management.',
              ),
            ],
          ),
        ],
      ),
    ];

    if (_searchQuery.isEmpty) {
      return allLocations;
    }

    // Filter locations based on search query
    final query = _searchQuery.toLowerCase();
    final List<Widget> filteredLocations = [];

    for (var location in allLocations) {
      if (location is Column) {
        final children = location.children;
        if (children.length >= 2 && children[1] is Card) {
          final card = children[1] as Card;
          final cardChildren = card.child as Column;
          final List<Widget> matchingLocations = [];

          for (var hall in cardChildren.children) {
            if (hall is ExpansionTile) {
              final hallTitle = hall.title as Text;
              final hallLocations = hall.children;

              for (var locationTile in hallLocations) {
                if (locationTile is ExpansionTile) {
                  final title = locationTile.title as Text;
                  final subtitle = locationTile.subtitle as Text;
                  final padding = locationTile.children[0] as Padding;
                  final column = padding.child as Column;
                  final description = column.children[0] as Text;

                  if (title.data?.toLowerCase().contains(query) == true ||
                      subtitle.data?.toLowerCase().contains(query) == true ||
                      description.data?.toLowerCase().contains(query) == true ||
                      hallTitle.data?.toLowerCase().contains(query) == true) {
                    matchingLocations.add(locationTile);
                  }
                }
              }
            }
          }

          if (matchingLocations.isNotEmpty) {
            filteredLocations.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      ((children[0] as Padding).child as Text).data ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Column(
                      children: matchingLocations,
                    ),
                  ),
                ],
              ),
            );
          }
        }
      }
    }

    return filteredLocations;
  }

  void _updateExpandedHalls(String query) {
    _expandedHalls.clear();
    if (query.isNotEmpty) {
      // Mark all halls as expanded when searching
      for (var location in _buildFilteredLocations()) {
        if (location is Column) {
          final children = location.children;
          if (children.length >= 2 && children[1] is Card) {
            final card = children[1] as Card;
            final cardChildren = card.child as Column;
            for (var hall in cardChildren.children) {
              if (hall is ExpansionTile) {
                final hallTitle = hall.title as Text;
                _expandedHalls[hallTitle.data ?? ''] = true;
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Locations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by room number, name, or description...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _expandedHalls.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _updateExpandedHalls(value);
                });
              },
            ),
          ),
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Showing ${_buildFilteredLocations().length} results',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
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
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: Column(
            children: halls,
          ),
        ),
      ],
    );
  }

  Widget _buildHallSection(String title, List<Widget> locations) {
    return ExpansionTile(
      initiallyExpanded: _searchQuery.isNotEmpty,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
      children: [
        const Divider(height: 1),
        ...locations,
      ],
    );
  }

  Widget _buildLocationTile(String title, String subtitle, String description) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Implement navigation to map with location marker
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('View on Map'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Games Screen'),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Help Screen'),
    );
  }
}
