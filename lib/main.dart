import 'package:flutter/material.dart';
import 'package:kindkarma/auth/forgot.dart';
import 'package:kindkarma/auth/login.dart';
import 'package:kindkarma/auth/register.dart';
import 'package:kindkarma/view/home.dart';
import 'package:provider/provider.dart';
import 'package:kindkarma/controllers/userprovider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Userprovider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kindkarma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => const MyHomePage(),
        '/login': (context) => const MyLoginPage(),
        '/register': (context) => const MyRegisterPage(),
        '/forgot': (context) => const Forgot(),
      },
    );
  }
}