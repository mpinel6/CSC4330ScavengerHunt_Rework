import 'package:flutter/material.dart';

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

  // Make this static so it can be updated from anywhere
  static final List<LocationInfo> allLocationData = [
    LocationInfo(
      floor: 'First Floor',
      hall: '1100s Hall',
      title: 'Auditorium (1100)',
      subtitle: 'Roy O. Martin Auditorium',
      description:
          'Capacity: 250 students. Equipped with projectors and whiteboard.',
    ),
    LocationInfo(
      floor: 'First Floor',
      hall: '1100s Hall',
      title: 'DOW Chemical Unit Operations Lab (1114)',
      subtitle: 'Chemical Engineering Laboratory',
      description:
          'The Dow Chemical Unit Operations Lab offers chemical engineering'
          'students hands-on experience with industry-grade equipment. Key features'
          'include an Ethylene Oxidation Reactor for producing ethylene oxide and a'
          'distillation column for separating components by vapor pressure. Students'
          'apply their knowledge in a practical setting, preparing for real-world engineering'
          'challenges.',
    ),
    LocationInfo(
      floor: 'First Floor',
      hall: '1100s Hall',
      title: 'BASF Sustainable Living Lab (1154)',
      subtitle: 'Innovating for a Sustainable Future',
      description:
          'Funded by a \$1 million donation from BASF, this lab focuses on research for'
          ' sustainable solutions. Researcher-in-residence Dr. Jimmy Lawrence develops polymers'
          '  and nanoscale composites for healthcare, energy, and environmental applications. The'
          ' lab’s flooring, paint, and ceiling are made from BASF products, demonstrating their'
          ' commitment to sustainability.',
    ),
    LocationInfo(
      floor: 'First Floor',
      hall: '1200s Hall',
      title: 'The Chevron Center (1269)',
      subtitle: 'Center for Engineering Education',
      description:
          'The Chevron Center supports the Communication Across the Curriculum program,'
          ' offering resources like 3D printers, large format printers, and rentable electronic'
          ' devices for student projects. It features vending machines, a microwave, and a seating area,'
          ' providing a collaborative space for engineering students.',
    ),
    LocationInfo(
      floor: 'First Floor',
      hall: '1200s Hall',
      title: 'The Commons (1278)',
      subtitle: 'Collaborative Space for Engineering Students',
      description:
          'The Commons serves as the central gathering space in Patrick F. Taylor Hall,'
          ' popular among students for its Panera Bread and comfortable seating. Nearby is'
          ' the Dow Student Leadership Incubator, providing meeting and storage space for over 40'
          ' student organizations. This vibrant space fosters collaboration and community within the college.',
    ),
    LocationInfo(
      floor: 'First Floor',
      hall: '1300s Hall',
      title: 'Robotics Lab (1300)',
      subtitle: 'Home of Robotics',
      description:
          'Supporting the College of Engineering’s robotics minor, this lab features equipment'
          ' like a hydraulic robotic arm, robotic vehicles including spiders and crawlers, and a mini'
          ' humanoid robot named “Darwin.” Students gain hands-on experience in robotics design,'
          ' programming, and control through practical projects and research.',
    ),
    LocationInfo(
      floor: 'First Floor',
      hall: '1300s Hall',
      title: 'Civil Engineering Labs (1323)',
      subtitle: 'Applied Civil Engineering Research',
      description:
          'This area contains most of the civil engineering student labs, where students conduct'
          ' hands-on testing and research. Activities include testing concrete strength, creating and'
          ' analyzing asphalt, examining soil composition, and evaluating the strength of metal and'
          ' timber. These labs provide valuable practical experience in civil engineering applications.',
    ),
    LocationInfo(
      floor: 'First Floor',
      hall: '1300s Hall',
      title: 'Mechanical Engineering Labs (1354)',
      subtitle: 'Hands-On Engineering Learning',
      description:
          'This section houses student-focused labs for mechanical and industrial engineering,'
          ' including human factors, thermal systems, materials, and instrumentation labs. Equipment such as'
          ' a wind tunnel, tensile strength testers, and 3D-motion analysis systems support hands-on learning'
          ' and research. Students gain practical experience applying engineering concepts in real-world scenarios.',
    ),
    LocationInfo(
      floor: 'Second Floor',
      hall: '2100s Hall',
      title: 'Annex/Drilling Fluids Lab (2147)',
      subtitle: 'Chemical Engineering Annex',
      description:
          'The Chemical Engineering Annex, built during the recent renovation and expansion,'
          ' houses state-of-the-art laboratories. Spanning three floors, it includes labs for'
          ' chemical, construction management, civil, environmental, and petroleum engineering.'
          ' This space supports innovative research and hands-on learning.',
    ),
    LocationInfo(
      floor: 'Second Floor',
      hall: '2200s Hall',
      title: 'Civil Engineering Driving Simulator Lab (2215)',
      subtitle: 'Researching Driving Behaviors',
      description:
          'This lab allows students and faculty to study driving behaviors, environments,'
          ' and traffic using advanced simulation technology. Equipped with multiple screens,'
          ' projectors, and blackout curtains, it enables realistic driving scenarios to evaluate '
          'driver reactions. Research topics include distracted driving, weather impacts, and'
          ' interactions with semi-autonomous systems.',
    ),
    LocationInfo(
      floor: 'Second Floor',
      hall: '2200s Hall',
      title: 'Brookshire Student Services Suite (2228)',
      subtitle: 'Student Support and Advising',
      description:
          'The Student Services Suite is the primary resource for students needing academic'
          ' or administrative assistance. It offers access to licensed academic advisors, career'
          ' coaching, and support for major changes, minors, and credit transfers. The suite also'
          ' houses recruiting and outreach staff, providing comprehensive support for student success.',
    ),
    LocationInfo(
      floor: 'Second Floor',
      hall: '2200s Hall',
      title: 'Proto Lab (2272)',
      subtitle: 'Microprocessor and Prototyping Labs',
      description:
          'This lab duplex features a microprocessor interfacing lab and a proto'
          'lab for students to fabricate circuit boards and create device prototypes.'
          'Equipped with fume hoods, soldering stations, cutting machines, and 3D printers,'
          'it ensures safe handling of chemicals. UV-filtering lighting and windows protect'
          'the delicate circuitry process.',
    ),
    LocationInfo(
      floor: 'Second Floor',
      hall: '2300s Hall',
      title: 'BIM Lab (2348)',
      subtitle: 'Virtual Reality Construction Management',
      description:
          'Designed for construction management students, this lab features 4K displays'
          'for immersive, 3D views of building plans. It allows students and faculty to virtually'
          'visit sites, assess designs, and address safety and maintenance concerns.',
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
          color: const Color.fromARGB(255, 233, 225, 240),
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
