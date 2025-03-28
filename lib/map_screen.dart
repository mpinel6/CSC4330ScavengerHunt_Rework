import 'package:flutter/material.dart';

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
                            Positioned(
                              left: width * 0.75,
                              top: height * 0.325,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 26,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 2.0,
                                    color: Color(0xFF000000),
                                  ),
                                ],
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
