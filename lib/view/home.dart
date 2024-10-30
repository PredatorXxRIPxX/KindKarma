import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:kindkarma/view/profile.dart';
import 'package:kindkarma/view/addcontent.dart';
import 'package:kindkarma/view/mainpage.dart';
import 'package:kindkarma/view/notificationpage.dart';
import 'package:kindkarma/view/search.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  // Custom colors
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color darkBackground = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color accentColor = Color(0xFF2E7D32);
  static const Color cardColor = Color(0xFF252525);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: _buildAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) => setState(() => currentPage = value),
        children: const [
          Mainpage(),
          Search(),
          Addcontent(),
          Notificationpage(),
          Profile(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.volunteer_activism,
              color: primaryGreen,
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
      backgroundColor: surfaceColor,
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(
                Icons.message_outlined,
                color: Colors.white,
                size: 24,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: primaryGreen,
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
          ),
          onPressed: () => print("Message tapped"),
        ),
        const SizedBox(width: 12),
      ],
    );
  }


  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            darkBackground.withOpacity(0.9),
          ],
        ),
      ),
      child: AnimatedNotchBottomBar(
        color: surfaceColor,
        durationInMilliSeconds: 300,
        notchBottomBarController: NotchBottomBarController(index: currentPage),
        blurOpacity: 0,
        bottomBarHeight: 75,
        onTap: (value) {
          setState(() => currentPage = value);
          _pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        kBottomRadius: 28,
        kIconSize: 24,
        bottomBarWidth: MediaQuery.of(context).size.width,
        bottomBarItems: [
          _buildBottomBarItem(Icons.home_rounded, Icons.home_outlined),
          _buildBottomBarItem(Icons.search_rounded, Icons.search_outlined),
          _buildBottomBarItem(Icons.add_circle_rounded, Icons.add_circle_outline_rounded),
          _buildBottomBarItem(Icons.notifications_rounded, Icons.notifications_outlined),
          _buildBottomBarItem(Icons.person_rounded, Icons.person_outline_rounded),
        ],
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
        color: primaryGreen,
      ),
      itemLabel: '',
    );
  }
}