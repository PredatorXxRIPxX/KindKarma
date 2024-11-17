
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kindkarma/aside/personemessage.dart';
import 'package:kindkarma/utils/utility.dart';

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
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    String username = widget.author['username'].toString();
    return CircleAvatar(
      radius: 24,
      backgroundColor: primaryGreen,
      child: Text(
        username[0].toUpperCase(),
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
          widget.author['username'].toString(),
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
                    _buildAuthorInfo(),
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
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Personemessage(userDocuments: widget.author,)));
        },
        child: const Icon(Icons.comment),
      ),
    );
  }
}