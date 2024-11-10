import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kindkarma/utils/utility.dart';

class Carddetailed extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final String author;
  final DateTime date;

  const Carddetailed({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.author,
    required this.date,
  });

  @override
  State<Carddetailed> createState() => _CarddetailedState();
}

class _CarddetailedState extends State<Carddetailed> {
  late ScrollController _scrollController;
  bool _showAppBarTitle = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _showAppBarTitle = _scrollController.offset > 200;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: darkBackground,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
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
                    // Gradient overlay
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

            // Content
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
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

                    // Author Info Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: primaryGreen,
                            child: Text(
                              widget.author.isNotEmpty
                                  ? widget.author[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: surfaceColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.author,
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
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Implement share functionality
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Implement bookmark functionality
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description Section
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.8,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 100), // Space for FAB
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
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    color: surfaceColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
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
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: primaryGreen,
                            child: Text(
                              widget.author.isNotEmpty
                                  ? widget.author[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: surfaceColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.author,
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
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()), 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                             Expanded(
                              child: TextField(
                                cursorColor: primaryGreen,
                                decoration: const InputDecoration(
                                  hintText: 'Write a message...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    message = value;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send,color: message.isEmpty || message == '' ? Colors.grey : primaryGreen ,),
                              onPressed: () {
                                print(message);
                              },
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.comment),
      ),
    );
  }
}
