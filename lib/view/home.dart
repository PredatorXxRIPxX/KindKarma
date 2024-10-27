import 'package:flutter/material.dart';
import 'package:kindkarma/utils/utility.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: const Text('Charitex', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.messenger_outlined, color: Colors.white),
            onPressed: (){
              print("message");
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Charitex',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Color(color_green)),
        unselectedLabelStyle: TextStyle(color: Color(color_white)),
        currentIndex: currentPage,
        onTap: (value){
          setState(() {
            currentPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Color(color_green)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share_location_outlined, color: Color(color_green)),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined, color: Color(color_green)),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            
            icon: Icon(Icons.person_outline, color: Color(color_green)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
