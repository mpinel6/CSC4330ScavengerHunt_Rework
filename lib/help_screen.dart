import 'package:flutter/material.dart';
import 'tutorial_dialog.dart';
import 'game_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How do I start playing the Maze Game?',
      answer:
          'Go to the Games tab at the bottom navigation, pick any Location to play for, and memorize the maze within 5 seconds!',
    ),
    FAQItem(
      question: 'What happens if I fail the maze?',
      answer:
          'If you hit a wall or go out of bounds, you must start over, but you get another 5-second memorization period.',
    ),
    FAQItem(
      question: 'How do I get a hint after solving the maze?',
      answer:
          'Once you reach the green square, you unlock a clue about the selected Location. Each time you succeed, the maze gets harder!',
    ),
  ];

  void _showMainTutorial() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const TutorialDialog(), 
    );
  }

  void _showMazeTutorial() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MazeTutorialDialog(
          onTutorialComplete: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

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
                Color(0xFF5A2B8C),
                Color(0xFF461D7C),
                Color(0xFF3A1B6C),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 24,
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
              const SizedBox(height: 12),
              _buildFAQSection(),
              const SizedBox(height: 24),
              const Divider(thickness: 1, color: Color(0xFF461D7C)),
              const SizedBox(height: 12),
              const Text(
                'Replay Tutorials',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF461D7C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Need a refresher on how to use the app or the maze game? Tap any tutorial below.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showMainTutorial,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF461D7C),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Replay Main Tutorial'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _showMazeTutorial,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF461D7C),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Replay Maze Tutorial'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Card(
      color: const Color.fromARGB(255, 233, 225, 240),
      child: Column(
        children: _faqs.map((item) => _buildFAQTile(item)).toList(),
      ),
    );
  }

  Widget _buildFAQTile(FAQItem item) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF461D7C),
        ),
      ),
      child: ExpansionTile(
        title: Text(
          item.question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              item.answer,
              style: const TextStyle(color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
