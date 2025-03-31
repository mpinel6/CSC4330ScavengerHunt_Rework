import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  // Global hints counter accessible from the game screen.
  static int availableHints = 0;

  final TransformationController _transformationController =
      TransformationController();
  bool _showFloorButtons = false;
  String _currentFloor = 'First Floor';
  MapIcon? _selectedIcon;
  bool _isClosing = false;
  final TextEditingController _answerController = TextEditingController();
  bool _isCorrect = false;
  bool _hasAnswered = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final bool _isPlaying = false;
  final bool _showVolumeSlider = false;
  final double _volume = 0.25;
  final List<String> _answeredIcons = [];

  // Add these new state variables
  bool _showLayersNotification = false;
  bool _showSecondFloorNotification = false;

  // Map of icons for each floor
  final Map<String, List<MapIcon>> _floorIcons = {
    'First Floor': [
      MapIcon(
        position: const Offset(0.75, 0.325),
        icon: Icons.location_on,
        color: Colors.green,
        title: 'Capstone Gallery',
        description:
            '    Welcome to Patrick F. Taylor Hall, home to the LSU College of Engineering. '
            'Named after 1959 petroleum engineering graduate, Patrick F. Taylor, it is the '
            'largest academic building in the state of Louisiana and one of the largest '
            'free-standing College of Engineering buildings in the United States. '
            'As a result of our recent \$114-million renovation and expansion, this building '
            'is now more than 400,000 square feet and provides students and faculty with '
            'state-of-the-art classrooms and labs. It also serves as the central hub for '
            'the College of Engineering\'s eight academic departments, which educate thousands '
            'of undergraduate and graduate students each year.\n\n'
            '    As you explore, keep an eye on how power flows through the building — '
            'sometimes it\'s easy to overlook what\'s right beneath your feet.',
        imagePath: 'assets/images/capstonegallery.png',
        answers: ['14 outlets', '14'],
        newPosition: const Offset(0.5, 0.5),
        hints: [
          'Energy is all around, often hiding in plain sight. Some sources are closer than you think — maybe even lining your path.',
          'Sometimes, the most useful connections are right at your feet. Consider where students might need a little extra power.',
          'The Capstone steps offer a great place to gather, but they\'re also equipped for those needing a quick recharge. Count carefully!',
        ],
      ),
      MapIcon(
        position: const Offset(0.75, 0.65),
        icon: Icons.location_on,
        color: Colors.green,
        title: 'Cambre Atrium & Donor Wall',
        description:
            '    The Cambre Atrium is one of three main common spaces in Patrick F. Taylor Hall. '
            'It connects what was the existing old building to a newly built, three-story lab annex. '
            'A number of chemical engineering labs run the length of the Cambre Atrium on one side, '
            'and classrooms line the other, ranging in size from about 30 seats up to 150 seats. '
            'The largest classroom space in the building is the RoyOMartin Auditorium, which holds '
            'up to 250 students. Across from the doors to the RoyOMartin Auditorium, you\'ll find '
            'the Donor Wall, which recognizes the names of donors and industry partners who, along '
            'with funds from the state of Louisiana, helped make the renovation of Patrick F. Taylor '
            'Hall possible.\n\n'
            '    The Donor Wall is a display of appreciation, but not all names are alike.',
        imagePath: 'assets/images/cambreatrium.png',
        answers: ['8 purple donors', '8'],
        newPosition: const Offset(0.75, 0.75),
        hints: [
          'Colors often carry meaning.',
          'Some names shine brighter than others, not just in generosity but in hue.',
          'While yellow dominates, purple isn\'t just a choice — it\'s a distinction. Seek out those who stand apart.',
        ],
      ),
      MapIcon(
        position: const Offset(0.6, 0.67),
        icon: Icons.location_on,
        color: Colors.green,
        title: 'Dow Chemical Unit Operations Lab',
        description:
            '    The Dow Chemical Unit Operations Laboratory is a learning lab housed within '
            'the Cain Department of Chemical Engineering. It contains various pieces of equipment '
            'that are designed to complete specific "unit operations." A unit operation is a '
            'single step in a chemical process, such as separation, crystallization, oxidation, '
            'etc. For instance, the first machine on the left is an Ethylene Oxidation Reactor, '
            'which, as the name suggests, oxidizes ethylene into ethylene oxide, a common compound '
            'found in laundry detergents. Much of the equipment in this space has been donated or '
            'funded by industry partners and gives students in the chemical engineering program '
            'valuable hands-on experience with industry-grade equipment. To the right of the lab, '
            'is a distillation column, which can be viewed better from the second floor. This unit '
            'separates components--water and a series of glycols--into pure or near pure components '
            'by the differences in the vapor pressure of the components. Students have the chance '
            'to work on a distillation unit that is a true commercial analog of those they will be '
            'expected to operate when they enter the workforce as chemical engineers. This unit '
            'would not be out of place at a commercial pharmaceutical or specialty chemical facility '
            'that operates in the commercial world. It is built to those specifications and design '
            'criteria. Students will physically interact with equipment in their junior-year lab '
            'and then learn to run the equipment from the adjacent control room as seniors.\n\n'
            '    Before stepping into certain areas, it\'s wise to check for any precautions. The right clue will be staring you in the face — if you\'re paying attention.',
        imagePath: 'assets/images/dowchemical.png',
        answers: ['Eye Protection', 'Caution: Eye Protection'],
        newPosition: const Offset(0.75, 0.75),
        hints: [
          'Laboratories are places of discovery, but also of caution.',
          'Warnings aren\'t just words; they\'re a visual reminder.',
          'Before you cross the threshold, consider what might protect the most sensitive part of yourself.',
        ],
      ),
      MapIcon(
        position: const Offset(0.33, 0.67),
        icon: Icons.location_on,
        color: Colors.green,
        title: 'BASF Sustainable Living Lab',
        description:
            '    The BASF Sustainable Living Laboratory was funded by a \$1 million donation '
            'from BASF. The flooring, paint, and ceiling in this lab are all made from BASF '
            'products. The lab space is dedicated to research investigating sustainable solutions '
            'to meet global challenges. The current researcher-in-residence, Dr. Jimmy Lawrence, '
            'studies and develops new functional polymers and nanoscale composites for healthcare, '
            'energy, environmental, and other industrial applications.\n\n'
            '    This challenge is about keeping your eyes open for details that others might miss.'
            'Don\'t rush; let your surroundings speak to you.',
        imagePath: 'assets/images/basflab.png',
        answers: ['BASF Performance Flooring'],
        newPosition: const Offset(0.55, 0.75),
        hints: [
          'Not every message is loud.',
          'Somewhere near, a quiet message waits — a simple statement that holds the answer.',
          'A speech bubble by a door has a few words that may just point you in the right direction.',
        ],
      ),
      MapIcon(
        position: const Offset(0.27, 0.33),
        icon: Icons.location_on,
        color: Colors.green,
        title: 'The Commons',
        description:
            '    This atrium space is aptly named "The Commons" and serves as the main gathering '
            'space for everyone in Patrick F. Taylor Hall. Students frequent this space between '
            'classes, not only because of the Panera Bread, but also because of the nearby Dow '
            'Student Leadership Incubator, which serves as a meeting and storage space for the '
            'more than 40 student organizations that are part of our college.\n\n'
            '    The Commons isn\'t just a place to gather; it\'s where appetites meet satisfaction.',
        imagePath: 'assets/images/commons.png',
        answers: ['Mac and Cheese', 'Mac', 'Macaroni and Cheese'],
        newPosition: const Offset(0.55, 0.75),
        hints: [
          'Look for the familiar comforts of a well-known spot, and you might just find your answer on the menu.',
          'Creamy, cheesy, and iconic — it\'s often hard to resist.',
          'Pasta',
        ],
      ),
      MapIcon(
        position: const Offset(0.36, 0.19),
        icon: Icons.location_on,
        color: Colors.green,
        title: 'Mechanical Engineering Labs',
        description:
            '    This section of Patrick F. Taylor Hall is home to many student-focused lab '
            'spaces for mechanical and industrial engineering, including the human factors, '
            'thermal systems, materials, and instrumentation labs. Within these labs, you '
            'will find equipment like a wind tunnel, tensile strength testers, and 3D-motion '
            'analysis systems.\n\n'
            '    In this challenge, numbers are your guide.'
            ' The key lies in understanding where these labs come together.',
        imagePath: 'assets/images/mechlabs.png',
        answers: ['1300\'s Hall', '1300'],
        newPosition: const Offset(0.55, 0.75),
        hints: [
          'Mechanical and industrial engineering labs are scattered throughout, but they all share a common thread.',
          'Every lab has a home, and for mechanical engineering, the location is no accident. Consider the common space where their work thrives.',
          'When in doubt, follow the numbers. The right hall is waiting for you to make the connection.',
        ],
      ),
      MapIcon(
        position: const Offset(0.68, 0.1),
        icon: Icons.location_on,
        color: Colors.green,
        title: 'Civil Engineering Labs',
        description:
            '    In this section of Patrick F. Taylor Hall, you will find most of our civil '
            'engineering student labs. Here, our students test concrete for strength and damage, '
            'test and create asphalt, test the chemical composition and strength of soils, and '
            'study the strength of metal and timber.\n\n'
            '    Civil engineering is all about strength and precision, and so is this task.',
        imagePath: 'assets/images/civillabs.png',
        answers: ['10 Civil Engineering Labs', '10'],
        newPosition: const Offset(0.55, 0.75),
        hints: [
          'Keep your focus sharp and count carefully — the answer is laid out right in front of you.',
          'This challenge is about understanding the layout and the connections between labs.',
          'Each lab has a purpose, from concrete testing to soil analysis. How many different tasks need dedicated spaces?',
        ],
      ),
      MapIcon(
        position: const Offset(0.74, 0.3),
        icon: Icons.location_on,
        color: Colors.green,
        title: 'Robotics Lab',
        description:
            '    The College of Engineering offers a minor in robotics and provides a lab '
            'space to support this program. Some of the equipment housed in this lab include '
            'a hydraulic robotic arm; robotic vehicles, such as spiders and crawlers; and a '
            'mini humanoid robot named "Darwin."\n\n'
            '    This challenge is all about machines and the minds behind them.',
        imagePath: 'assets/images/robotlab.png',
        answers: ['Bengal Bots'],
        newPosition: const Offset(0.55, 0.75),
        hints: [
          'Robots like spiders, crawlers, and humanoids are their specialty. Who commands these creations?',
          'The Robotics Lab is alive with innovation, and the ones responsible have a name that reflects their fierce spirit.',
          'What club leads the charge in the world of robotics here?',
        ],
      ),
      MapIcon(
        position: const Offset(0.75, 0.38),
        icon: Icons.location_on,
        color: Colors.green,
        title: 'Chevron Center for Engineering Education',
        description:
            '    The Chevron Center for Engineering Education is one of three studios that '
            'support a university-wide program called Communication Across the Curriculum, which '
            'was started in 2005 by a chemical engineering alum. The program focuses on improving '
            'four areas of communication: written, spoken, visual, and technological, while '
            'deepening student learning of course content. This space has 3D printers, large '
            'format printers, and many electronic devices that students may rent to complete '
            'class projects. Students who take the required number of communication-intensive '
            'courses and complete a senior portfolio can graduate as a Distinguished Communicator. '
            'The College of Engineering is proud to graduate the most Distinguished Communicators '
            'each year, thanks in large part to this space and the professional staff who run it.\n\n'
            '    In the Chevron Center, innovation and creation are at your fingertips — for a price.',
        imagePath: 'assets/images/chevcenter.png',
        answers: [
          '0.15 per mL for 3D printing',
          '0.15',
          '0.15 per ml',
          '0.15 per'
        ],
        newPosition: const Offset(0.55, 0.75),
        hints: [
          'When working with 3D printers, materials are measured carefully.',
          'The key to this question lies in understanding just how much a small amount can cost.',
          'The cost isn\'t calculated per project or per hour. It\'s all about volume.',
        ],
      ),
    ],
    'Second Floor': [
      MapIcon(
        position: const Offset(0.683, 0.18), // Adjust coordinates as needed
        icon: Icons.location_on,
        color: Colors.green,
        title: 'BIM Lab',
        description:
            '    The MMR Building Information Modeling Laboratory is utilized by construction '
            'management students and was specially designed and constructed by our faculty. '
            'The lab space consists of 4K displays that allow for three-dimensional and '
            'computer-generated views of building plans. This allows students and faculty to '
            'virtually visit building sites to make assessments, alter plans, and consider '
            'concerns like safety and maintenance. In addition to this unique lab space, the '
            'Bert S. Turner Department of Construction Management has several labs and classrooms '
            'on the third floor, including an estimating and scheduling lab, a room with several '
            'CATS equipment simulators, and an advanced materials lab.\n\n'
            '    The BIM Lab is where construction plans come to life, viewed in stunning detail.',
        imagePath: 'assets/images/bimlab.png',
        answers: ['44 screens', '44'],
        newPosition: const Offset(0.5, 0.5),
        hints: [
          'The lab\'s 4K displays offer a larger-than-life view of projects.',
          'This isn\'t just one screen — it\'s a full-scale experience. Think about how many it would take to simulate an entire site.',
          'How many screens make this immersive experience possible? The answer is there — if you can count it.',
        ],
      ),
    ],
  };

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

  void _closeArticle() {
    setState(() {
      _isClosing = true;
      // Reset the text input and button states
      _answerController.clear();
      _isCorrect = false;
      _hasAnswered = false;
      // Decrement available hints when moving to a new article
      if (MapScreenState.availableHints > 0) {
        MapScreenState.availableHints--;
      }
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _selectedIcon = null;
          _isClosing = false;
        });
      }
    });
  }

  void _checkAnswer() {
    if (_selectedIcon != null) {
      setState(() {
        final userAnswer = _answerController.text.toLowerCase().trim();
        _isCorrect = _selectedIcon!.answers
            .map((a) => a.toLowerCase())
            .contains(userAnswer);

        if (_isCorrect) {
          _hasAnswered = true;
          _answeredIcons.add(_selectedIcon!.title);

          // Check if this was the last first floor article
          if (_currentFloor == 'First Floor' &&
              _floorIcons['First Floor']!
                  .every((icon) => _answeredIcons.contains(icon.title))) {
            _showLayersNotification = true;
            _showSecondFloorNotification = true;
          }

          final floorIcons = _floorIcons[_currentFloor];
          if (floorIcons != null) {
            final index =
                floorIcons.indexWhere((icon) => icon == _selectedIcon);
            if (index != -1) {
              floorIcons[index] = MapIcon(
                position: _selectedIcon!.position,
                icon: _selectedIcon!.icon,
                color: const Color(0xFF461D7C),
                title: _selectedIcon!.title,
                description: _selectedIcon!.description,
                imagePath: _selectedIcon!.imagePath,
                answers: _selectedIcon!.answers,
                newPosition: _selectedIcon!.newPosition,
                audioPath: _selectedIcon!.audioPath,
                hints: _selectedIcon!.hints,
              );
            }
          }
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _closeArticle();
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                Color(0xFF5A2B8C),
                Color(0xFF461D7C),
                Color(0xFF3A1B6C),
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
                                _getMapImagePath(),
                                fit: BoxFit.fill,
                              ),
                            ),
                            ..._floorIcons[_currentFloor]
                                    ?.asMap()
                                    .entries
                                    .where((entry) {
                                  if (entry.key == 0) return true;
                                  final previousIcon = _floorIcons[
                                      _currentFloor]![entry.key - 1];
                                  return _answeredIcons
                                      .contains(previousIcon.title);
                                }).map((entry) => Positioned(
                                          left: width * entry.value.position.dx,
                                          top: height * entry.value.position.dy,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedIcon = entry.value;
                                              });
                                            },
                                            child: Tooltip(
                                              message: entry.value.title,
                                              child: Icon(
                                                entry.value.icon,
                                                color: entry.value.color,
                                                size: 26,
                                                shadows: const [
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 2.0,
                                                    color: Color(0xFF000000),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )) ??
                                [],
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
          if (_selectedIcon != null)
            GestureDetector(
              onTap: _closeArticle,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Stack(
                  children: [
                    _buildArticlePopup(),
                  ],
                ),
              ),
            ),
          if (_showFloorButtons)
            Positioned(
              left: 16,
              bottom: 80,
              child: TweenAnimationBuilder<double>(
                tween:
                    Tween(begin: 0.0, end: _selectedIcon != null ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 100 * value),
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
                  );
                },
              ),
            ),
          Positioned(
            left: 16,
            bottom: 16,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: _selectedIcon != null ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 100 * value),
                  child: Container(
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
                          // Clear notification when layers button is clicked
                          _showLayersNotification = false;
                        });
                      },
                      backgroundColor: const Color(0xFF461D7C),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.layers,
                            color: Color(0xFFFDD023),
                          ),
                          if (_showLayersNotification)
                            Positioned(
                              right: -19,
                              top: -19,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlePopup() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _isClosing ? 0.0 : 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, MediaQuery.of(context).size.height * (1 - value)),
          child: child,
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedIcon?.title ?? '',
                        style: const TextStyle(
                          color: Color(0xFFFDD023),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Color(0xFF000000),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFFFDD023)),
                      onPressed: _closeArticle,
                    ),
                  ],
                ),
              ),
              if (_selectedIcon?.imagePath != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_selectedIcon!.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedIcon?.description ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _answerController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your answer...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF333333)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF333333)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF461D7C), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                onSubmitted: (_) => _checkAnswer(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Available hint button using the global availableHints
                            IconButton(
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              icon: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(Icons.lightbulb_outline,
                                      color: MapScreenState.availableHints > 0
                                          ? const Color(0xFF461D7C)
                                          : Colors.grey),
                                  if (MapScreenState.availableHints > 0)
                                    Positioned(
                                      right: -8,
                                      top: -8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF461D7C),
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 18,
                                          minHeight: 18,
                                        ),
                                        child: Text(
                                          MapScreenState.availableHints
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              onPressed: MapScreenState.availableHints > 0
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Available Hints'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Show all hints up to the number of available hints
                                              for (int i = 0;
                                                  i <
                                                          _selectedIcon!
                                                              .hints.length &&
                                                      i <
                                                          MapScreenState
                                                              .availableHints;
                                                  i++)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Text(
                                                    'Hint ${i + 1}: ${_selectedIcon!.hints[i]}',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF333333)),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  : () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text('No Hints Available'),
                                          content: const Text(
                                            'You need to win games in the Games section to earn hints!',
                                            style: TextStyle(
                                                color: Color(0xFF333333)),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _checkAnswer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF461D7C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _isCorrect ? 'Correct!' : 'Submit Answer',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloorButton(String floor, IconData icon) {
    final isSelected = _currentFloor == floor;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          elevation: 4,
          child: InkWell(
            onTap: () {
              setState(() {
                _currentFloor = floor;
                _transformationController.value = Matrix4.identity();
                // Clear notification when second floor is selected
                if (floor == 'Second Floor') {
                  _showSecondFloorNotification = false;
                }
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFF461D7C) : Colors.transparent,
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
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (floor == 'Second Floor' && _showSecondFloorNotification)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MapIcon {
  final Offset position;
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String imagePath;
  final List<String> answers;
  final Offset newPosition;
  final String? audioPath;
  final List<String> hints;

  MapIcon({
    required this.position,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.answers,
    required this.newPosition,
    this.audioPath,
    this.hints = const [],
  });
}
