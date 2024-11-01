import 'package:flutter/material.dart';
import 'package:kindkarma/aside/about.dart';
import 'package:kindkarma/aside/changedetails.dart';
import 'package:kindkarma/aside/contactus.dart';
import 'package:kindkarma/aside/termcondition.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed:(){
            Navigator.pop(context);
          } , icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            ListTile(
              title: const Text('change Details'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailsPage()));
              },
            ),
            ListTile(
              title: const Text('Contact Us'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Contactus()));
              },
            ),
            ListTile(
              title: const Text('Terms and Conditions'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsAndConditions()));
              },
            ),
            ListTile(
              title: const Text('About'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
              },
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Made with ❤️ by Charitex Team from IoWaveStudios',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}