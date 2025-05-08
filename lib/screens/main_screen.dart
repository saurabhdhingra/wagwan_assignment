import 'package:flutter/material.dart';
import 'package:wagwan_assignment/screens/feed_screen.dart';
import 'package:wagwan_assignment/screens/placeholder_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Start with explore page
  final _searchController = TextEditingController();
  bool _showSearchBar = true;
  double _lastScrollPosition = 0;

  final List<Widget> _screens = [
    const PlaceholderScreen(title: 'Home'),
    const FeedScreen(),
    const PlaceholderScreen(title: 'New Post'),
    const PlaceholderScreen(title: 'Reels'),
    const PlaceholderScreen(title: 'Profile'),
  ];

  void _onScroll(double position) {
    if (position > _lastScrollPosition && _showSearchBar) {
      setState(() => _showSearchBar = false);
    } else if (position < _lastScrollPosition && !_showSearchBar) {
      setState(() => _showSearchBar = true);
    }
    _lastScrollPosition = position;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: _currentIndex,
        indicatorColor: Colors.transparent,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: 32),
            selectedIcon: Icon(Icons.home_outlined, size: 32),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.search, size: 32),
            selectedIcon: Icon(Icons.search, size: 32),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline, size: 32),
            selectedIcon: Icon(Icons.add_circle_outline, size: 32),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined, size: 32),
            selectedIcon: Icon(Icons.movie_outlined, size: 32),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined, size: 32),
            selectedIcon: Icon(Icons.account_circle_outlined, size: 32),
            label: '',
          ),
        ],
      ),
    );
  }
}
