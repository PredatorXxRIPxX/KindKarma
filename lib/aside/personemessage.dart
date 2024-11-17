import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/components/chatmessage.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:kindkarma/utils/messagemodel.dart';
import 'package:kindkarma/utils/notificationBuilder.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:provider/provider.dart';

class Personemessage extends StatefulWidget {
  final Document userDocuments;
  const Personemessage({super.key, required this.userDocuments});

  @override
  State<Personemessage> createState() => _PersonemessageState();
}

class _PersonemessageState extends State<Personemessage> {
  Document? reciever; 
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Messagemodel> messages = [];
  late Userprovider userprovider;
  RealtimeSubscription? _subscription; 

  @override
  void initState() {
    super.initState();
    userprovider = Provider.of<Userprovider>(context, listen: false);
    
  }

  void _setupRealtimeSubscription() {
    _subscription = realtime.subscribe([
      'databases.$databaseid.collections.$chatCollectionid.documents'
    ]);

    _subscription?.stream.listen((response) {
      if (response.events.contains(
        'databases.$databaseid.collections.$chatCollectionid.documents.*.create'
      )) {
        final message = Messagemodel.fromJson(response.payload);
        if ((message.senderId == userprovider.userid && 
             message.receiverId == reciever?.data['recieverid']) ||
            (message.senderId == reciever?.data['recieverid'] && 
             message.receiverId == userprovider.userid)) {
          setState(() {
            messages.add(message);
          });
          _scrollToBottom();
        }
      }
    });
  }

  Future<void> _loadInitialMessages() async {
    try {
      if (reciever == null) return;
      
      final chatHistory = await getChatHistory(reciever!.data['recieverid']);
      setState(() {
        messages.clear();
        messages.addAll(chatHistory);
      });
    } catch (e) {
      showErrorSnackBar('Failed to load messages', context);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || reciever == null) {
      return;
    }
    
    try {
      await database.createDocument(
        databaseId: databaseid,
        collectionId: chatCollectionid,
        documentId: ID.unique(),
        data: {
          'message': message,
          'sender': userprovider.userid,
          'reciever': reciever!.data['recieverid'],
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'isSeenByReciever': false,
          'isImage': false,
        },
      );
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      showErrorSnackBar('Unable to send message. Check your network', context);
    }
  }

  Future<List<Messagemodel>> getChatHistory(String receiverId) async {
    try {
      final response = await database.listDocuments(
        databaseId: databaseid,
        collectionId: chatCollectionid,
        queries: [
          Query.or([
            Query.and([
              Query.equal('sender', userprovider.userid),
              Query.equal('reciever', receiverId),
            ]),
            Query.and([
              Query.equal('sender', receiverId),
              Query.equal('reciever', userprovider.userid),
            ]),
          ]),
          Query.orderAsc('timestamp'), 
        ],
      );

      return response.documents
          .map((doc) => Messagemodel.fromJson(doc.data))
          .toList();
    } catch (e) {
      print('Error getting chat history: $e');
      return [];
    }
  }

  Future<void> _fetchReciever(String email) async {
    try {
      final response = await database.listDocuments(
        databaseId: databaseid, 
        collectionId: userCollectionid,
        queries: [Query.equal('email', email)]
      );
      
      if (response.documents.isEmpty) {
        throw Exception('User not found');
      }
      setState(() {
        reciever = response.documents.first;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Unable to find user. Try again later'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Stream<List<Chatmessage>> _getMessages(String receiverId) async* {
    try {
      final response = await database.listDocuments(
        databaseId: databaseid,
        collectionId: chatCollectionid,
        queries: [
          Query.or([
            Query.and([
              Query.equal('sender', userprovider.userid),
              Query.equal('reciever', receiverId),
            ]),
            Query.and([
              Query.equal('sender', receiverId),
              Query.equal('reciever', userprovider.userid),
            ]),
          ]),
          Query.orderAsc('timestamp'),
        ],
      );

      yield response.documents.map((doc) {
        final data = doc.data;
        return Chatmessage(
          message: data['message'],
          isMe: data['sender'] == userprovider.userid,
          timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
        );
      }).toList();
    } catch (e) {
      print('Error getting messages: $e');
      yield [];
    }
  }

  @override
  void dispose() {
    _subscription?.close();
    _messageController.dispose();
    _scrollController.dispose();
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
            backgroundImage: NetworkImage('https://appwrite.io/images/brand-assets/appwrite-logo-dark.png'),
          ),
          title: Text(
            widget.userDocuments.data['username'],
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
            child: StreamBuilder<List<Chatmessage>>(
              stream: reciever != null 
                ? _getMessages(reciever!.data['recieverid'])
                : Stream.value([]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'An error occurred: ${snapshot.error}',
                    ),
                  );
                }

                final messages = snapshot.data ?? [];

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Chatmessage(
                      message: message.message,
                      isMe: message.isMe,
                      timestamp: message.timestamp,
                    );
                  },
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