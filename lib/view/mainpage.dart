import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/components/articlecard.dart';
import 'package:kindkarma/utils/notificationBuilder.dart';
import 'package:kindkarma/utils/utility.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Document> _documents = []; 
  bool _isLoading = false;
  bool _hasMoreData = true;
  static const int _limit = 10;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final documents = await _fetchDocuments();
      setState(() {
        _documents.addAll(documents);
        _isLoading = false;
        _hasMoreData = documents.length >= _limit;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showErrorSnackBar('Failed to load articles', context);
      }
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final documents = await _fetchDocuments();
      setState(() {
        _documents.addAll(documents);
        _isLoading = false;
        _hasMoreData = documents.length >= _limit;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showErrorSnackBar('Failed to load more articles', context);
      }
    }
  }

  Future<List<Document>> _fetchDocuments() async {
    try {
      final documents = await database.listDocuments(
        databaseId: databaseid,
        collectionId: postCollectionid,
        queries: [
          Query.orderDesc('created_at'),
          Query.limit(_limit),
          Query.offset(_documents.length),
        ],
      );
      
      return documents.documents;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _documents.clear();
      _hasMoreData = true;
    });
    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _documents.isEmpty && _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryGreen,
                  ),
                )
              : _documents.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined,
                              size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No articles found',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.75,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final document = _documents[index];
                              return ArticleCard(
                                title: document.data['title']?.toString() ?? '',
                                description: document.data['description']?.toString() ?? '',
                                image: document.data['postimage']?.toString() ?? '',
                                author: document.data['user']['username']?.toString() ?? '',
                                date: DateTime.tryParse(document.data['created_at']?.toString() ?? '') ?? DateTime.now(),
                                category: 'cards',
                              );
                            },
                            childCount: _documents.length,
                          ),
                        ),
                        if (_isLoading)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: primaryGreen,
                                ),
                              ),
                            ),
                          ),
                        if (!_hasMoreData)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'No more articles',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
        ),
      ),
    );
  }
}