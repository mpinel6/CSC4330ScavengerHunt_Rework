import 'package:flutter/material.dart';

class TutorialDialog extends StatefulWidget {
  const TutorialDialog({super.key});

  @override
  State<TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<TutorialPage> _pages = [
    TutorialPage(
      title: 'Welcome to PFT Scavenger Hunt!',
      description: 'Your guide to navigating the Patrick F. Taylor Hall.',
      icon: Icons.waving_hand,
    ),
    TutorialPage(
      title: 'Interactive Map',
      description:
          'Explore the building layout with our interactive map. Zoom, pan, and tap on the icon to learn more.',
      icon: Icons.map,
    ),
    TutorialPage(
      title: 'Location Guide',
      description:
          'Find detailed information about rooms, offices, and facilities. Search by room number or description.',
      icon: Icons.location_on,
    ),
    TutorialPage(
      title: 'Games Library',
      description:
          'Play a collection of games to earn hints to assist you in unlocking the next step in the scavenger hunt!',
      icon: Icons.games,
    ),
    TutorialPage(
      title: 'Help & Support',
      description: 'Access help resources and contact support when needed.',
      icon: Icons.help,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 300,
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
                        : const Color(0xFF8B7F9C).withOpacity(0.3),
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
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF461D7C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(_currentPage < _pages.length - 1
                      ? 'Next'
                      : 'Get Started!'),
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
          size: 80,
          color: const Color(0xFF461D7C),
        ),
        const SizedBox(height: 24),
        Text(
          page.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF461D7C),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          page.description,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ),
          textAlign: TextAlign.center,
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
