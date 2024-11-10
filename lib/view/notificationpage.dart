import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/components/notificationCard.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:provider/provider.dart';

class Notificationpage extends StatefulWidget {
  const Notificationpage({super.key});

  @override
  State<Notificationpage> createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {

  late String userid ;

  Future<List<Document>> getNotifications() async {
    try {
      final documents = await database.listDocuments(
        databaseId: databaseid,
        collectionId: notificationCollection,
        queries: [
          Query.select(['notificationid','text', 'date']),
          Query.equal('userid', userid),
          Query.orderDesc('date'), 
        ],
      );
      return documents.documents;
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  @override
  void initState() {
    final Userprovider userprovider = Provider.of<Userprovider>(context, listen: false);
    userid = userprovider.userid;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Document>>(
      future: getNotifications(),
      builder: (context, AsyncSnapshot<List<Document>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.notifications_off, size: 100.0, color: accentColor),
              SizedBox(height: 10.0),
              Text('No notifications available', style: TextStyle(fontSize: 20.0,color: accentColor)),
            ],
          ));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final notification = snapshot.data![index];
            return NotificationCard(
              notificationid: notification.data['notificationid']??'hello',
              titleEvent: notification.data['text'],
              time:DateTime.parse(notification.data['date']),
            );
          },
        );
      },
    );
  }
}