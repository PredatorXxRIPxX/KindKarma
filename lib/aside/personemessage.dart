import 'package:appwrite/appwrite.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:kindkarma/utils/notificationBuilder.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:provider/provider.dart';

class PersoneMessage extends StatefulWidget {
  final Map<String, dynamic> author;
  const PersoneMessage({super.key, required this.author});

  @override
  State<PersoneMessage> createState() => _PersoneMessageState();
}

class _PersoneMessageState extends State<PersoneMessage> {
  Map<String, dynamic>? receiver;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<BubbleSpecialThree> messagesList = [];
  late Userprovider userprovider;
  RealtimeSubscription? _subscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userprovider = Provider.of<Userprovider>(context, listen: false);
    receiver = widget.author;
    _fetchMessages();
    _setupRealtimeSubscription();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _subscription?.close();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await database.listDocuments(
          databaseId: databaseid,
          collectionId: chatCollectionid,
          queries: [
            Query.orderDesc('timestemp'),
            Query.limit(50),
          ]);
      setState(() {
        messagesList = response.documents
            .map((e) => _createMessageBubble(e.data))
            .toList()
            .reversed
            .toList();
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showErrorSnackBar('Unable to fetch messages', context);
    }
  }

  BubbleSpecialThree _createMessageBubble(Map<String, dynamic> messageData) {
    return BubbleSpecialThree(
      text: messageData['message'],
      isSender: messageData['sender_id'] == userprovider.userid,
      textStyle: TextStyle(
          color: messageData['sender_id'] == userprovider.userid
              ? Colors.white
              : Colors.black),
      color: messageData['sender_id'] == userprovider.userid
          ? primaryGreen
          : Colors.grey,
      tail: true,
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await database.createDocument(
          databaseId: databaseid,
          collectionId: chatCollectionid,
          documentId: ID.unique(),
          data: {
            'message': _messageController.text.trim(),
            'sender_id': userprovider.userid,
            'reciever_id': widget.author['iduser'],
            'timestemp': DateTime.now().toIso8601String(),
            'isSeenByReciever': false,
            'isImage': false
          });

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      showErrorSnackBar('Unable to send message, check your network', context);
    }
  }

  void _setupRealtimeSubscription() {
    try {
      _subscription = realtime.subscribe(
          ['databases.$databaseid.collections.$chatCollectionid.documents']);

      _subscription?.stream.listen((response) {
        if (response.events.contains(
            'databases.$databaseid.collections.$chatCollectionid.documents.*')) {
          final message = response.payload;
          _addNewMessage(message);
        }
      }, onError: (error) {
        showErrorSnackBar('Realtime connection lost', context);
      });
    } catch (e) {
      showErrorSnackBar('Failed to setup realtime chat', context);
    }
  }

  void _addNewMessage(Map<String, dynamic> messageData) {
    setState(() {
      messagesList.add(_createMessageBubble(messageData));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index];
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
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: darkBackground,
                            title: const Text("Sending Image",
                                style: TextStyle(color: Colors.white)),
                            content: const Text(
                                "This feature will be available soon",
                                style: TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Ok",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        });
                  },
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
                    onSubmitted: (_) => _sendMessage(),
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
