import 'package:flutter/material.dart';
import 'package:kindkarma/auth/forgot.dart';
import 'package:kindkarma/auth/login.dart';
import 'package:kindkarma/auth/signup.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:kindkarma/view/home.dart';
import 'package:provider/provider.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Channel for basic notifications',
        defaultColor: primaryGreen,
        importance: NotificationImportance.High,
        ledColor: surfaceColor,
      )
    ],
    debug: true,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => Userprovider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Kindkarma',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => const MyHomePage(),
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUp(),
        '/forgot': (context) => const ForgotPassword(),
      },
    );
  }
}