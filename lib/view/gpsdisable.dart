import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:kindkarma/view/home.dart';

class Gpsdisable extends StatefulWidget {
  const Gpsdisable({super.key});

  @override
  State<Gpsdisable> createState() => _GpsdisableState();
}

class _GpsdisableState extends State<Gpsdisable> {
  @override
  Widget build(BuildContext context) {
    Stream<bool> getLocation() {
      return Stream.periodic(const Duration(seconds: 1),
              (_) => Geolocator.isLocationServiceEnabled()).asyncMap((event) async => await event);
    }

    return Scaffold(
      backgroundColor: darkBackground,
      body: StreamBuilder<bool>(
          stream: getLocation(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()));
              });
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, color: Colors.red, size: 100),
                  const SizedBox(height: 20),
                  const Text(
                    'Location Services Disabled',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enable location services to continue',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Open location settings
                      await Geolocator.openLocationSettings();
                    },
                    child: const Text('Open Location Settings',
                        style: TextStyle(color: primaryGreen)),
                  )
                ],
              ),
            );
          }),
    );
  }
}
