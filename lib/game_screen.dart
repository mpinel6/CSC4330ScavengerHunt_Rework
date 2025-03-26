import 'package:flutter/material.dart';
import 'dart:async';

class GamesScreen extends StatefulWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GamesScreen> {
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

  Timer? _timer;
  int _timeElapsed = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _movePlayer(int deltaRow, int deltaCol) {
    final newRow = _playerRow + deltaRow;
    final newCol = _playerCol + deltaCol;
    if (newRow >= 0 &&
        newRow < _maze.length &&
        newCol >= 0 &&
        newCol < _maze[0].length &&
        _maze[newRow][newCol] == 0) {
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
  }

  void _showClueDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clue Unlocked!'),
          content: const Text('CLUE HERE'),
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
        title: const Text('Maze Game'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Time: $_timeElapsed s',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMazeGrid(),
          ),
          _buildControlPanel(),
        ],
      ),
    );
  }

  Widget _buildMazeGrid() {
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
