import 'package:flutter/material.dart';
import 'package:kindkarma/components/articlecard.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            return Articlecard(
                title: 'hello',
                description: 'hello again',
                image: 'hello',
                author: 'john doe',
                date: DateTime.now(),
                category: 'cards');
          },
        ),
      ),
    );
  }
}
