import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  MapIcon? _selectedIcon;
  bool _isClosing = false;
  final TextEditingController _answerController = TextEditingController();
  bool _isCorrect = false;
  bool _hasAnswered = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _showVolumeSlider = false;
  double _volume = 0.25;
  int _hintsUsed = 0;

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
        answer: '15',
        newPosition: const Offset(0.5, 0.5),
        hint:
            'Count the number of power outlets in the room. Look for the standard wall outlets.',
      ),
      MapIcon(
        position: const Offset(0.25, 0.5),
        icon: Icons.location_on,
        color: Colors.red,
        title: 'Chevron Center',
        description:
            'The Chevron Center supports the Communication Across the Curriculum program, '
            'offering resources like 3D printers, large format printers, and rentable electronic '
            'devices for student projects. It features vending machines, a microwave, and a '
            'seating area, providing a collaborative space for engineering students.',
        imagePath: 'assets/images/chevron_center.jpg',
        answer: '3D printers',
        newPosition: const Offset(0.75, 0.75),
        hint:
            'What technology is mentioned first in the description that students can use for their projects?',
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

  @override
  void initState() {
    super.initState();
  }

  void _closeArticle() {
    setState(() {
      _isClosing = true;
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
        final correctAnswers = ['15', '15 outlets'];
        _isCorrect = correctAnswers.contains(userAnswer);

        if (_isCorrect) {
          _hasAnswered = true;
          // Update the icon color to purple and add a new green icon
          final floorIcons = _floorIcons[_currentFloor];
          if (floorIcons != null) {
            final index =
                floorIcons.indexWhere((icon) => icon == _selectedIcon);
            if (index != -1) {
              // Update the original icon to purple
              floorIcons[index] = MapIcon(
                position: _selectedIcon!.position,
                icon: _selectedIcon!.icon,
                color: const Color(0xFF461D7C),
                title: _selectedIcon!.title,
                description: _selectedIcon!.description,
                imagePath: _selectedIcon!.imagePath,
                answer: _selectedIcon!.answer,
                newPosition: _selectedIcon!.newPosition,
                audioPath: _selectedIcon!.audioPath,
              );
              // Add a new green icon at the new position
              floorIcons.add(MapIcon(
                position: _selectedIcon!.newPosition,
                icon: _selectedIcon!.icon,
                color: Colors.green,
                title: _selectedIcon!.title,
                description: _selectedIcon!.description,
                imagePath: _selectedIcon!.imagePath,
                answer: _selectedIcon!.answer,
                newPosition: _selectedIcon!.newPosition,
                audioPath: _selectedIcon!.audioPath,
              ));
            }
          }
          // Close the article after a short delay
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
                                    ?.map((icon) => Positioned(
                                          left: width * icon.position.dx,
                                          top: height * icon.position.dy,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedIcon = icon;
                                              });
                                            },
                                            child: Tooltip(
                                              message: icon.title,
                                              child: Icon(
                                                icon.icon,
                                                color: icon.color,
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
                        });
                      },
                      backgroundColor: const Color(0xFF461D7C),
                      child: const Icon(
                        Icons.layers,
                        color: Color(0xFFFDD023),
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
      tween: Tween(begin: 1.0, end: _isClosing ? 0.0 : 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 300 * (1 - value)),
          child: child,
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
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
        child: SingleChildScrollView(
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
                      image: AssetImage(_selectedIcon!.imagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                borderSide:
                                    const BorderSide(color: Color(0xFF333333)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFF333333)),
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
                        IconButton(
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  color: _hintsUsed > 0
                                      ? const Color(0xFF461D7C)
                                      : Colors.grey),
                              if (_hintsUsed > 0)
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
                                      _hintsUsed.toString(),
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
                          onPressed: _hintsUsed > 0
                              ? () {
                                  setState(() {
                                    _hintsUsed--;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Hint'),
                                      content: Text(
                                        _selectedIcon?.hint ??
                                            'Look carefully at the description for clues about the answer.',
                                        style: const TextStyle(
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
                                }
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('No Hints Available'),
                                      content: const Text(
                                        'You need to win games in the Games section to earn hints!',
                                        style:
                                            TextStyle(color: Color(0xFF333333)),
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
            ],
          ),
        ),
      ),
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

class MapIcon {
  final Offset position;
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String imagePath;
  final String answer;
  final Offset newPosition;
  final String? audioPath;
  final String? hint;

  MapIcon({
    required this.position,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.answer,
    required this.newPosition,
    this.audioPath,
    this.hint,
  });
}
