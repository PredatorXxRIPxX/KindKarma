import 'package:flutter/material.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:kindkarma/view/settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                        end: Alignment.bottomRight)),
                child: const Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'John Doe',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Kind Karma User',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                'My Profile :',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const ListTile(
            leading: Icon(
              Icons.email,
              color: Colors.white,
            ),
            title: Text(
              'Email',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const ListTile(
            leading: Icon(
              Icons.phone,
              color: Colors.white,
            ),
            title: Text(
              'Phone',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const ListTile(
            leading: Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            title: Text(
              'Location',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            title: const Text(
              'settings',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Yes')),
                        ],
                      ));
            },
          ),
        ],
      ),
    );
  }
}
