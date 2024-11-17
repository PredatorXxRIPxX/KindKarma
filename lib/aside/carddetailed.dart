import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/aside/personemessage.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:kindkarma/utils/notificationBuilder.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:provider/provider.dart';

class CardDetailed extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final Map<String,dynamic> author;
  final DateTime date;

  const CardDetailed({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.author,
    required this.date,
  });

  @override
  State<CardDetailed> createState() => _CardDetailedState();
}

class _CardDetailedState extends State<CardDetailed> {
  late final ScrollController _scrollController;
  bool _showAppBarTitle = false;
  String _message = '';
  late final Userprovider _userProvider;
  final _messageController = TextEditingController();

  @override
  void initState() {
    print(widget.author['username'].toString());
    super.initState();
    _userProvider = Provider.of<Userprovider>(context, listen: false);
    _scrollController = ScrollController()
      ..addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!mounted) return;
    setState(() {
      _showAppBarTitle = _scrollController.offset > 200;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    print(widget.author['username'].toString());
    return DateFormat('MMMM d, yyyy').format(date);
  }

  Widget _buildAuthorInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildAuthorAvatar(),
          const SizedBox(width: 12),
          Expanded(child: _buildAuthorDetails()),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAuthorAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: primaryGreen,
      child: Text(
        widget.author['username'] || widget.author['username'] != null ? widget.author['username'].toString() : 'Unknown',
        style: const TextStyle(
          color: surfaceColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAuthorDetails() {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.author['username'].isNotEmpty || widget.author['username'] != null ? widget.author['username'].toString() : 'Unkonwn',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatDate(widget.date),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            // TODO: Implement share functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {
          
          },
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              cursorColor: primaryGreen,
              decoration: const InputDecoration(
                hintText: 'Write a message...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => setState(() => _message = value),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _message.trim().isEmpty ? Colors.grey : primaryGreen,
            ),
            onPressed: _message.trim().isEmpty
                ? null
                : () {
                    Navigator.pop(context);
                    
                  },
          ),
        ],
      ),
    );
  }

  void _showMessageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 250,
          decoration: const BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    _buildAuthorAvatar(),
                    const SizedBox(width: 12),
                    Expanded(child: _buildAuthorDetails()),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              _buildMessageInput(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: darkBackground,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: _showAppBarTitle
                    ? Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            darkBackground.withOpacity(0.4),
                            darkBackground,
                          ],
                          stops: const [0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    //_buildAuthorInfo(),
                    const SizedBox(height: 24),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.8,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        foregroundColor: surfaceColor,
        elevation: 4,
        onPressed: _showMessageBottomSheet,
        child: const Icon(Icons.comment),
      ),
    );
  }
}