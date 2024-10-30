import 'package:flutter/material.dart';
import 'package:kindkarma/components/notificationCard.dart';

class Notificationpage extends StatefulWidget {
  const Notificationpage({super.key});

  @override
  State<Notificationpage> createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (builder,index){
        return NotificationCard(
          time: DateTime(2021, 10, 10),
          titleEvent: 'you have new meessge',

        );
      },
    );
  }
}