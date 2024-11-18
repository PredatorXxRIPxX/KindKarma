import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:kindkarma/utils/messagemodel.dart';
import 'package:kindkarma/utils/notificationBuilder.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:provider/provider.dart';

class Personemessage extends StatefulWidget {
  final Map<String,dynamic> author;
  const Personemessage({super.key, required this.author});

  @override
  State<Personemessage> createState() => _PersonemessageState();
}

class _PersonemessageState extends State<Personemessage> {
  Map<String,dynamic>? reciever; 
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Stream<List<BubbleSpecialThree>> messages;
  late Userprovider userprovider;
  RealtimeSubscription? _subscription; 


  Future <void> _sendMessage() async {
    if(_messageController.text.isEmpty) return;
    try {
      await database.createDocument(databaseId: databaseid, collectionId: postCollectionid, documentId: ID.unique(),
      data: {
        'message': _messageController.text,
        'sender_id': userprovider.userid,
        'reciever_id': widget.author['iduser'],
        'timestemp': DateTime.now().millisecondsSinceEpoch,
        'isSeenByReciever': false,
        'isImage':false
      });
    } catch (e) {
      showErrorSnackBar('enable to send message', context);
    }
  }

  Future<List<BubbleSpecialThree>>getMessages()async{
    try {
      final response = await database.listDocuments(databaseId: databaseid, collectionId: chatCollectionid,queries: [
         Query.or([
            Query.and([
              Query.equal('sender_id', userprovider.userid),
              Query.equal('reciever_id', reciever!['iduser']),
            ]),
            Query.and([
              Query.equal('sender_id', reciever!['iduser']),
              Query.equal('reciever_id', userprovider.userid),
            ]),
          ]),
          Query.orderAsc('timestamp'), 
      ]);
      return response.documents.map((e) => BubbleSpecialThree(
        text: e.data['message'],
        isSender: e.data['sender_id'] == userprovider.userid,
        textStyle: TextStyle(color: e.data['sender_id'] == userprovider.userid ? Colors.white : Colors.black),
        color: e.data['sender_id'] == userprovider.userid ? primaryGreen : Colors.grey,
        tail: true,
      )).toList();
    } catch (e) {
      showErrorSnackBar('enable to fetch messages', context);
      return [];
    }
  }

  @override
  void initState() {
    getMessages().then((value) {
      setState(() {
        messages = Stream.value(value);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _subscription?.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: darkBackground,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(
            radius: 20,
            backgroundColor: primaryGreen,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            widget.author['username'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: const Text(
            'Online',
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<BubbleSpecialThree>>(
              stream: messages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return snapshot.data![index];
                    },
                  );
                }
                if(snapshot.hasError){
                  return const Center(
                    child: Text('Error occured'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: darkBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}