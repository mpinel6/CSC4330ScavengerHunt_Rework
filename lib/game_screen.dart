import 'package:flutter/material.dart';
import 'dart:async';
import 'map_screen.dart'; 

class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  void _showTutorial(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MazeTutorialDialog(
        onTutorialComplete: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

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
                Color(0xFF5A2B8C),
                Color(0xFF461D7C),
                Color(0xFF3A1B6C),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF461D7C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final completed = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (context) => const MazeGame()),
                );
                if (completed == true) {
                  MapScreenState.availableHints++;
                }
              },
              child: const Text(
                'Play Maze Game',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF461D7C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _showTutorial(context),
              child: const Text(
                'How to Play',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The MazeGame widget – plays the memory game and returns true when completed successfully.
class MazeGame extends StatefulWidget {
  const MazeGame({Key? key}) : super(key: key);

  @override
  _MazeGameState createState() => _MazeGameState();
}

class _MazeGameState extends State<MazeGame> {
  static int _gamesCompleted = 0;

  static final List<List<List<int>>> _allMazes = [
    // Maze 1 (5x5 - easiest)
    [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 1, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
    ],
    // Maze 2 (5x5)
    [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 1, 1],
      [1, 0, 1, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
    ],
    // Maze 3 (6x6)
    [
      [1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 0, 1],
      [1, 0, 1, 0, 0, 1],
      [1, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1],
    ],
    // Maze 4 (6x6)
    [
      [1, 1, 1, 1, 1, 1],
      [1, 0, 0, 1, 0, 1],
      [1, 0, 0, 0, 1, 1],
      [1, 1, 1, 0, 0, 1],
      [1, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1],
    ],
    // Maze 5 (7x7)
    [
      [1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1, 1, 1],
      [1, 0, 1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1],
    ],
    // Maze 6 (7x7)
    [
      [1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 1, 0, 0, 1],
      [1, 0, 1, 0, 0, 1, 1],
      [1, 0, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 1, 0, 1],
      [1, 1, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1],
    ],
    // Maze 7 (8x8)
    [
      [1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 1],
      [1, 0, 1, 1, 1, 0, 0, 1],
      [1, 0, 0, 0, 1, 0, 1, 1],
      [1, 0, 1, 0, 0, 0, 0, 1],
      [1, 1, 0, 0, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1],
    ],
    // Maze 8 (8x8)
    [
      [1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 1, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 1, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1],
    ],
    // Maze 9 (9x9)
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 1, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
    ],
    // Maze 10 (9x9)
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 1, 0, 1, 0, 1],
      [1, 1, 0, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 1, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
    ],
    // Maze 11 (9x9)
    [
      [1,1,1,1,1,1,1,1,1],
      [1,0,0,0,1,0,0,0,1],
      [1,1,1,0,1,0,1,0,1],
      [1,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,0,1],
      [1,1,1,0,1,1,1,0,1],
      [1,0,0,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,1,1],
    ],
    // Maze 12 (9x9)
    [
      [1,1,1,1,1,1,1,1,1],
      [1,0,1,0,0,0,1,0,1],
      [1,0,1,0,1,0,1,0,1],
      [1,0,0,0,1,0,0,0,1],
      [1,1,1,0,1,1,1,0,1],
      [1,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,1,1],
    ],
    // Maze 13 (10x10)
    [
      [1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,1,0,0,0,0,1],
      [1,0,1,0,1,0,1,1,0,1],
      [1,0,1,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,1,0,1,0,1],
      [1,1,1,1,0,1,0,1,0,1],
      [1,0,0,1,0,0,0,0,0,1],
      [1,0,0,0,0,1,1,1,0,1],
      [1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 14 (10x10)
    [
      [1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,1,0,0,1],
      [1,0,1,1,1,0,1,0,1,1],
      [1,0,1,0,0,0,1,0,0,1],
      [1,0,1,0,1,1,1,1,0,1],
      [1,0,0,0,1,0,0,1,0,1],
      [1,1,1,0,1,0,1,1,0,1],
      [1,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,0,1],
      [1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 15 (10x10)
    [
      [1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,0,1],
      [1,0,1,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,1,0,1],
      [1,1,1,0,1,0,1,1,0,1],
      [1,0,0,0,0,0,1,0,0,1],
      [1,0,1,1,1,0,0,0,0,1],
      [1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 16 (10x10)
    [
      [1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,1,0,0,0,1],
      [1,0,1,1,0,1,0,1,0,1],
      [1,0,1,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,1,0,1],
      [1,1,1,1,1,0,1,1,0,1],
      [1,0,0,0,1,0,0,0,0,1],
      [1,0,1,0,1,1,1,1,0,1],
      [1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 17 (11x11)
    [
      [1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,0,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,0,1,0,1],
      [1,0,1,0,1,0,1,0,1,0,1],
      [1,0,1,0,0,0,1,0,0,0,1],
      [1,0,1,1,1,0,1,1,1,0,1],
      [1,0,0,0,0,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 18 (11x11)
    [
      [1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,0,1,0,1],
      [1,0,1,0,1,0,1,0,1,0,1],
      [1,0,1,0,0,0,1,0,1,0,1],
      [1,0,1,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 19 (11x11)
    [
      [1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,0,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,0,1,0,1],
      [1,0,1,1,1,0,1,0,1,0,1],
      [1,0,0,0,0,0,1,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,0,1],
      [1,0,0,0,0,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 20 (11x11)
    [
      [1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,0,1,0,1],
      [1,0,1,0,1,0,1,0,1,0,1],
      [1,0,1,0,0,0,1,0,1,0,1],
      [1,0,1,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 21 (12x12)
    [
      [1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,0,1,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,1,0,1,0,1],
      [1,0,1,0,1,0,0,1,0,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 22 (12x12)
    [
      [1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,1,0,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,1,0,0,0,1,0,0,1,0,1],
      [1,0,1,1,1,1,1,0,1,1,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 23 (12x12)
    [
      [1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,0,1,1,1,0,0,1],
      [1,0,1,0,0,0,0,0,1,0,1,1],
      [1,0,1,0,1,1,1,0,1,0,0,1],
      [1,0,0,0,1,0,0,0,1,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,1,0,0,0,1,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 24 (12x12)
    [
      [1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,0,1,1,1,0,1,0,1],
      [1,0,1,0,0,0,0,1,0,1,0,1],
      [1,0,1,0,1,1,0,1,0,1,0,1],
      [1,0,0,0,1,0,0,1,0,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 25 (12x12)
    [
      [1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,0,1,1,0,1],
      [1,0,1,0,0,0,1,0,0,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,0,0,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 26 (12x12)
    [
      [1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,1,0,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 27 (12x12)
    [
      [1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,1,0,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 28 (12x12)
    [
      [1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,1,0,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 29 (12x12)
    [
      [1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,1,0,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1],
    ],
    // Maze 30 (12x12 - hardest)
    [
      [1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,1,1,1,0,1,0,1],
      [1,0,0,0,1,0,0,1,0,1,0,1],
      [1,0,1,0,1,0,1,1,0,1,0,1],
      [1,0,1,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1],
    ],
  ];

  late List<List<int>> _maze;
  int _playerRow = 1;
  int _playerCol = 1;
  late int _exitRow;
  late int _exitCol;
  bool _hasReachedExit = false;
  int _timeElapsed = 0;
  int _memorizeCountdown = 5;
  // _showMaze controls the color of path cells: white during memorization, black afterward.
  bool _showMaze = true;
  bool _isMemorizing = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final difficultyIndex = _gamesCompleted.clamp(0, _allMazes.length - 1);
    _maze = _allMazes[difficultyIndex].map((row) => List<int>.from(row)).toList();
    _exitRow = _maze.length - 2;
    _exitCol = _maze[0].length - 2;

    // Show a "Ready to start?" popup before beginning the memorize timer.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showReadyPopup();
    });
  }

  void _showReadyPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ready to start?'),
          content: const Text(
              'Press "Start" when you are ready to begin memorizing the maze.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                startMemorizationTimer();
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );
  }

  void startMemorizationTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
        if (_memorizeCountdown > 0) {
          _memorizeCountdown--;
          if (_memorizeCountdown == 0) {
            _isMemorizing = false;
            _showMaze = false;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _movePlayer(int deltaRow, int deltaCol) {
    if (_isMemorizing) return;
    final newRow = _playerRow + deltaRow;
    final newCol = _playerCol + deltaCol;
    if (newRow < 0 ||
        newRow >= _maze.length ||
        newCol < 0 ||
        newCol >= _maze[0].length ||
        _maze[newRow][newCol] == 1) {
      _showFailDialog();
      return;
    }
    setState(() {
      _playerRow = newRow;
      _playerCol = newCol;
    });
    if (_playerRow == _exitRow && _playerCol == _exitCol) {
      setState(() {
        _hasReachedExit = true;
      });
      _showClueDialog();
    }
  }

  void _showFailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFA39AAC),
          title: const Text(
            'You failed!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF461D7C),
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: Color(0xFF000000),
                ),
              ],
            ),
          ),
          content: const Text(
            'Try again!',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF333333),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFFDD023),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _playerRow = 1;
      _playerCol = 1;
      _hasReachedExit = false;
      _memorizeCountdown = 5;
      _showMaze = true;
      _isMemorizing = true;
      _timeElapsed = 0;
    });
    // Optionally, you can show the Ready popup again here if desired.
    _showReadyPopup();
  }

  void _showClueDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Completed!'),
          content: const Text(
            'You earned +1 hint.\nUse it in the Map screen!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      _gamesCompleted = (_gamesCompleted + 1).clamp(0, _allMazes.length - 1);
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA39AAC),
      appBar: AppBar(
        title: const Text(
          'Memory Maze',
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                _isMemorizing
                    ? 'Memorize: $_memorizeCountdown s'
                    : 'Time: $_timeElapsed s',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFDD023),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMazeGrid()),
          _buildControlPanel(),
        ],
      ),
    );
  }

  Widget _buildMazeGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _maze[0].length,
      ),
      itemCount: _maze.length * _maze[0].length,
      itemBuilder: (context, index) {
        final row = index ~/ _maze[0].length;
        final col = index % _maze[0].length;
        return _buildMazeCell(row, col);
      },
    );
  }

  Widget _buildMazeCell(int row, int col) {
    if (row == _playerRow && col == _playerCol) {
      return Container(
        margin: const EdgeInsets.all(2),
        color: const Color(0xFF461D7C),
      );
    }
    if (row == _exitRow && col == _exitCol) {
      return Container(
        margin: const EdgeInsets.all(2),
        color: const Color(0xFFFDD023),
      );
    }
    if (_maze[row][col] == 1) {
      return Container(
        margin: const EdgeInsets.all(2),
        color: Colors.black,
      );
    }
    return Container(
      margin: const EdgeInsets.all(2),
      color: _showMaze ? Colors.white : Colors.black,
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _movePlayer(-1, 0),
                style: _controlButtonStyle(),
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.black, // LSU Black color
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _movePlayer(0, -1),
                style: _controlButtonStyle(),
                child: const Icon(
                  Icons.arrow_left,
                  color: Colors.black, // LSU Black color
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _movePlayer(0, 1),
                style: _controlButtonStyle(),
                child: const Icon(
                  Icons.arrow_right,
                  color: Colors.black, // LSU Black color
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _movePlayer(1, 0),
                style: _controlButtonStyle(),
                child: const Icon(
                  Icons.arrow_downward,
                  color: Colors.black, // LSU Black color
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ButtonStyle _controlButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF461D7C),
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class MazeTutorialDialog extends StatefulWidget {
  final VoidCallback onTutorialComplete;

  const MazeTutorialDialog({Key? key, required this.onTutorialComplete})
      : super(key: key);

  @override
  State<MazeTutorialDialog> createState() => _MazeTutorialDialogState();
}

class _MazeTutorialDialogState extends State<MazeTutorialDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<TutorialPage> _pages = [
    TutorialPage(
      title: 'Welcome to the Maze Memory Game!',
      description:
          'You have 5 seconds to memorize the maze. Once it disappears, use arrow buttons to move the purple square.',
      icon: Icons.games,
    ),
    TutorialPage(
      title: 'Memorize the Path',
      description:
          'If you hit a wall or go out of bounds, you must start over and try to remember the maze again.',
      icon: Icons.timer,
    ),
    TutorialPage(
      title: 'Objective',
      description:
          'Reach the yellow square without a wrong move. Then you\'ll get your clue!',
      icon: Icons.lightbulb,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 450,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? const Color(0xFF461D7C)
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Previous'),
                  )
                else
                  const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      widget.onTutorialComplete();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF461D7C),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Next' : 'Got it!',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(TutorialPage page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          page.icon,
          size: 60,
          color: const Color(0xFF461D7C),
        ),
        const SizedBox(height: 24),
        Text(
          page.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF461D7C),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class TutorialPage {
  final String title;
  final String description;
  final IconData icon;

  TutorialPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}
