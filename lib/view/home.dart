import 'package:flutter/material.dart';

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
        backgroundColor: Colors.black38,
        currentIndex: currentPage,
        onTap: (value){
          setState(() {
            currentPage = value;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share_location_outlined, color: Colors.white),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined, color: Colors.white),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
