import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:kindkarma/view/settings.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String email;
  late String username;

  Future <void> logout(BuildContext context) async {
    try {
      await account.deleteSession(sessionId: "current");
    } catch (e) {
      AlertDialog(
        title: const Text('Error'),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    } finally {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    final Userprovider userprovider = Provider.of<Userprovider>(context, listen: false);
    email = userprovider.email;
    username = userprovider.username;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor, surfaceColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      username, 
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Kind Karma User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Profile:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                ListTile(  // Removed const to show email
                  leading: const Icon(Icons.email, color: Colors.white),
                  title: const Text('Email', 
                    style: TextStyle(color: Colors.white, fontSize: 20)
                  ),
                  subtitle: Text(
                    email,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.phone, color: Colors.white),
                  title: Text('Phone', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                const ListTile(
                  leading: Icon(Icons.location_on, color: Colors.white),
                  title: Text('Location', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text('Settings', style: TextStyle(color: Colors.white, fontSize: 20)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Settings()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 20)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('No',style: TextStyle(color: primaryGreen),),
                          ),
                          TextButton(
                            onPressed: () {
                              logout(context);
                            },
                            child: const Text('Yes',style: TextStyle(color: primaryGreen),),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}