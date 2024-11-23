import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:kindkarma/view/friendmessages.dart';
import 'package:kindkarma/view/mainpage.dart';
import 'package:kindkarma/view/profile.dart';
import 'package:kindkarma/view/addcontent.dart';
import 'package:kindkarma/view/myposts.dart';
import 'package:kindkarma/view/search.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  // Move constants to a separate class for better organization
  static const _UIConstants = _HomePageUIConstants();
  
  late final PageController _pageController;
  late final NotchBottomBarController _bottomBarController;
  
  int _currentPage = 0;
  bool _isPageViewAnimating = false;

  // Define pages and navigation items as static const for better performance
  static const List<Widget> _pages = [
    MainPage(),
    Search(),
    AddContent(),
    Myposts(),
    Profile(),
  ];

  static const List<NavigationItemData> _navigationItems = [
    NavigationItemData(
      activeIcon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      label: 'Home'
    ),
    NavigationItemData(
      activeIcon: Icons.search_rounded,
      inactiveIcon: Icons.search_outlined,
      label: 'Search'
    ),
    NavigationItemData(
      activeIcon: Icons.add_circle_rounded,
      inactiveIcon: Icons.add_circle_outline_rounded,
      label: 'Add'
    ),
    NavigationItemData(
      activeIcon: Icons.bookmark_rounded,
      inactiveIcon: Icons.bookmark_outline,
      label: 'My Posts'
    ),
    NavigationItemData(
      activeIcon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      label: 'Profile'
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _bottomBarController = NotchBottomBarController(index: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bottomBarController.dispose();
    super.dispose();
  }

  Future<void> _handlePageChange(int index) async {
    if (_isPageViewAnimating) return;
    
    setState(() {
      _isPageViewAnimating = true;
      _currentPage = index;
    });

    try {
      await _pageController.animateToPage(
        index,
        duration: _UIConstants.animationDuration,
        curve: Curves.easeInOut,
      );
    } catch (e) {
      debugPrint('Error during page animation: $e');
    } finally {
      if (mounted) {
        setState(() => _isPageViewAnimating = false);
      }
    }
  }

  void _handleMessageTap() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => const Friendmessages()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: ThemeColors.surfaceColor,
      title: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: ThemeColors.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeColors.accentColor.withOpacity(0.3)),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.volunteer_activism,
                color: ThemeColors.primaryGreen,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Charitex',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        _MessageButton(onTap: _handleMessageTap),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildBottomBar() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            ThemeColors.darkBackground.withOpacity(0.9),
          ],
        ),
      ),
      child: AnimatedNotchBottomBar(
        color: ThemeColors.surfaceColor,
        durationInMilliSeconds: _UIConstants.animationDuration.inMilliseconds,
        notchBottomBarController: _bottomBarController,
        blurOpacity: 0,
        bottomBarHeight: _UIConstants.bottomBarHeight,
        bottomBarWidth: MediaQuery.of(context).size.width,
        kBottomRadius: _UIConstants.bottomRadius,
        kIconSize: _UIConstants.iconSize,
        onTap: _handlePageChange,
        bottomBarItems: _navigationItems
            .map((item) => _buildBottomBarItem(item.activeIcon, item.inactiveIcon))
            .toList(),
      ),
    );
  }

  BottomBarItem _buildBottomBarItem(IconData activeIcon, IconData inactiveIcon) {
    return BottomBarItem(
      inActiveItem: Icon(
        inactiveIcon,
        color: Colors.white.withOpacity(0.5),
      ),
      activeItem: Icon(
        activeIcon,
        color: ThemeColors.primaryGreen,
      ),
      itemLabel: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.darkBackground,
      appBar: _buildAppBar(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: _pages,
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}

// Separate class for UI constants
class _HomePageUIConstants {
  final double bottomBarHeight = 75;
  final double bottomRadius = 28;
  final double iconSize = 24;
  final Duration animationDuration = const Duration(milliseconds: 300);

  const _HomePageUIConstants();
}

class NavigationItemData {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const NavigationItemData({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}


class _MessageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _MessageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.message_outlined,
            color: Colors.white,
            size: 24,
          ),
          onPressed: onTap,
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: ThemeColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '2',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ThemeColors {
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color darkBackground = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color accentColor = Color(0xFF2E7D32);
  static const Color cardColor = Color(0xFF252525);

  const ThemeColors._();
}