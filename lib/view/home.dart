import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:kindkarma/view/profile.dart';
import 'package:kindkarma/view/addcontent.dart';
import 'package:kindkarma/view/notificationpage.dart';
import 'package:kindkarma/view/search.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  static const double _kBottomBarHeight = 75;
  static const double _kBottomRadius = 28;
  static const double _kIconSize = 24;
  static const Duration _kAnimationDuration = Duration(milliseconds: 300);
  late final PageController _pageController;
  late final NotchBottomBarController _bottomBarController;
  
  int _currentPage = 0;
  bool _isPageViewAnimating = false;

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


  final List<Widget> _pages = const [
    Center(
      child: Text('Home'),
    ),
    Search(),
    Addcontent(),
    Notificationpage(),
    Profile(),
  ];


  final List<({IconData activeIcon, IconData inactiveIcon, String label})> _navigationItems = const [
    (activeIcon: Icons.home_rounded, inactiveIcon: Icons.home_outlined, label: 'Home'),
    (activeIcon: Icons.search_rounded, inactiveIcon: Icons.search_outlined, label: 'Search'),
    (activeIcon: Icons.add_circle_rounded, inactiveIcon: Icons.add_circle_outline_rounded, label: 'Add'),
    (activeIcon: Icons.notifications_rounded, inactiveIcon: Icons.notifications_outlined, label: 'Notifications'),
    (activeIcon: Icons.person_rounded, inactiveIcon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  Future<void> _handlePageChange(int index) async {
    if (_isPageViewAnimating) return;
    
    setState(() {
      _isPageViewAnimating = true;
      _currentPage = index;
    });

    try {
      await _pageController.animateToPage(
        index,
        duration: _kAnimationDuration,
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: ThemeColors.surfaceColor,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ThemeColors.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeColors.accentColor.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.volunteer_activism,
              color: ThemeColors.primaryGreen,
              size: 24,
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
        _buildMessageButton(),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildMessageButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.message_outlined,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => _handleMessageTap(),
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

  void _handleMessageTap() {
    
    debugPrint('Message button tapped');
  }

  Widget _buildBottomBar() {
    return Container(
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
        durationInMilliSeconds: _kAnimationDuration.inMilliseconds,
        notchBottomBarController: _bottomBarController,
        blurOpacity: 0,
        bottomBarHeight: _kBottomBarHeight,
        bottomBarWidth: MediaQuery.of(context).size.width,
        kBottomRadius: _kBottomRadius,
        kIconSize: _kIconSize,
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

class ThemeColors {
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color darkBackground = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color accentColor = Color(0xFF2E7D32);
  static const Color cardColor = Color(0xFF252525);

  const ThemeColors._(); 
}