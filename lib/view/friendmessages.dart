import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/aside/personemessage.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:provider/provider.dart';

class Friendmessages extends StatefulWidget {
  const Friendmessages({super.key});
  
  @override
  State<Friendmessages> createState() => _FriendmessagesState();
}

class _FriendmessagesState extends State<Friendmessages> {
  late Userprovider userProvider;

  Future<Document> getAuthor(String receiverId) async {
    final response = await database.listDocuments(
      databaseId: databaseid, 
      collectionId: userCollectionid,
      queries: [Query.equal('iduser', receiverId)]
    );
    return response.documents.first;
  }

  Stream<List<ListTile>> _getUsers() async* {
    try {
      final response = await database.listDocuments(
        databaseId: databaseid, 
        collectionId: chatCollectionid,
        queries: [Query.select(['reciever_id'])]
      );
      
      final Set<String> receivers = {};
      for (final Document document in response.documents) {
        receivers.add(document.data['reciever_id']);
      }
      
      final List<ListTile> userTiles = [];
      
      for (final String receiver in receivers) {
        final Document authorDoc = await getAuthor(receiver);
        userTiles.add(
          ListTile(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => Personemessage(
                    author: authorDoc.data,
                  )
                )
              );
            },
            leading: const CircleAvatar(
              backgroundColor: primaryGreen,
              child: Icon(Icons.person_rounded,color: darkBackground,),
            ),
            title: Text(authorDoc.data['username'] ?? 'Unknown',style: const TextStyle(color: Colors.white),),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: primaryGreen),
          )
        );
      }
      
      yield userTiles;
    } catch (e) {
      yield [];
    }
  }

  @override
  void initState() {
    userProvider = Provider.of<Userprovider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          )
        ),
        title: const Text('Messages',style: TextStyle(color: Colors.white),),
        backgroundColor: darkBackground,
      ),
      body: StreamBuilder<List<ListTile>>(
        stream: _getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => snapshot.data![index],
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: primaryGreen,
            ),
          );
        }
      )
    );
  }
}