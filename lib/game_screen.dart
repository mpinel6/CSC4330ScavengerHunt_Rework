import 'package:flutter/material.dart';
import 'dart:async';

class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MazeGame()),
            );
          },
          child: const Text('Play Maze Game'),
        ),
      ),
    );
  }
}

class MazeGame extends StatefulWidget {
  const MazeGame({Key? key}) : super(key: key);

  @override
  _MazeGameState createState() => _MazeGameState();
}

class _MazeGameState extends State<MazeGame> {
  final List<List<int>> _maze = [
    [1, 1, 1, 1, 1],
    [1, 0, 0, 0, 1],
    [1, 0, 1, 0, 1],
    [1, 0, 0, 0, 1],
    [1, 1, 1, 1, 1],
  ];

  int _playerRow = 1;
  int _playerCol = 1;

  final int _exitRow = 3;
  final int _exitCol = 3;

  bool _hasReachedExit = false;

  int _timeElapsed = 0;

  int _memorizeCountdown = 5;
  bool _showMaze = true; 
  bool _isMemorizing = true; 

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMazeTutorialDialog();
    });
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
      _resetGame();
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
  }

  void _showMazeTutorialDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return MazeTutorialDialog(onTutorialComplete: () {
          Navigator.of(context).pop();
          startMemorizationTimer();
        });
      },
    );
  }

  void _showClueDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clue Unlocked!'),
          content: const Text('You reached the goal!'),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maze Memory Game'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                _isMemorizing
                    ? 'Memorize: $_memorizeCountdown s'
                    : 'Time: $_timeElapsed s',
                style: const TextStyle(fontSize: 16),
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
    if (_showMaze) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _maze.length,
        ),
        itemCount: _maze.length * _maze[0].length,
        itemBuilder: (context, index) {
          final row = index ~/ _maze.length;
          final col = index % _maze.length;
          return _buildMazeCell(row, col);
        },
      );
    } else {
      return Container(color: Colors.black);
    }
  }

  Widget _buildMazeCell(int row, int col) {
    if (row == _playerRow && col == _playerCol) {
      return Container(
        margin: const EdgeInsets.all(2),
        color: Colors.blue,
      );
    } else if (row == _exitRow && col == _exitCol) {
      return Container(
        margin: const EdgeInsets.all(2),
        color: Colors.green,
      );
    } else if (_maze[row][col] == 1) {
      return Container(
        margin: const EdgeInsets.all(2),
        color: Colors.black,
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(2),
        color: Colors.white,
      );
    }
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
                child: const Icon(Icons.arrow_upward),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _movePlayer(0, -1),
                child: const Icon(Icons.arrow_left),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _movePlayer(0, 1),
                child: const Icon(Icons.arrow_right),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _movePlayer(1, 0),
                child: const Icon(Icons.arrow_downward),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MazeTutorialDialog extends StatefulWidget {
  final VoidCallback onTutorialComplete;

  const MazeTutorialDialog({Key? key, required this.onTutorialComplete}) : super(key: key);

  @override
  State<MazeTutorialDialog> createState() => _MazeTutorialDialogState();
}

class _MazeTutorialDialogState extends State<MazeTutorialDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<TutorialPage> _pages = [
    TutorialPage(
      title: 'Welcome to the Maze Memory Game!',
      description: 'You have 5 seconds to memorize the maze. Once it disappears, use arrow buttons to navigate.',
      icon: Icons.games,
    ),
    TutorialPage(
      title: 'Memorize the Path',
      description: 'If you hit a wall or go out of bounds, you must start over and get another 5 seconds.',
      icon: Icons.timer,
    ),
    TutorialPage(
      title: 'Objective',
      description: 'Reach the green square without a wrong move. Then you\'ll see your clue!',
      icon: Icons.lightbulb,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 400, 
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
                        ? Colors.deepPurple
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
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(_currentPage < _pages.length - 1
                      ? 'Next'
                      : 'Got it!'),
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
          color: Colors.deepPurple,
        ),
        const SizedBox(height: 24),
        Text(
          page.title,
          style: const TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
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
