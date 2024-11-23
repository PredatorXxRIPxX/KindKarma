import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/components/mypostcard.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:kindkarma/utils/notificationBuilder.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:provider/provider.dart';

class Myposts extends StatefulWidget {
  const Myposts({super.key});

  @override
  State<Myposts> createState() => _MypostsState();
}

class _MypostsState extends State<Myposts> {
  late String userid;

  Future<List<Document>> getPosts() async {
    try {
      final documents = await database.listDocuments(
        databaseId: databaseid,
        collectionId: postCollectionid,
        queries: [
          Query.equal('user', userid),
        ],
      );
      return documents.documents;
    } catch (e) {
      showErrorSnackBar(e.toString(), context);
      return [];
    }
  }

  @override
  void initState() {
    final Userprovider userprovider =
        Provider.of<Userprovider>(context, listen: false);
    userid = userprovider.userid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getPosts(), 
    builder: (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Center(child: CircularProgressIndicator(color: primaryGreen,));
      }
      if(snapshot.hasError){
        return const Center(child: Text('Error fetching data'));
      }
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            final Document document = snapshot.data[index];
            return MyPostCard(
              id: document.data["idpost"],
              title: document.data['title'],
              description: document.data['description'],
              postImage: document.data['postimage'],
              createdAt: document.data['created_at'],
            );
          },
        );
      }
      return const Center(
        child: Column(
          children: [
            Icon(Icons.bookmark_rounded, size: 100, color: Colors.white),
            Text('No posts yet',style: TextStyle(color: Colors.white),),
          ],
        ),
      );
    });
  }
}
