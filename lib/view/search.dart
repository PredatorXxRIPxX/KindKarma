import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/components/articlecard.dart';
import 'package:kindkarma/utils/notificationBuilder.dart';
import 'package:kindkarma/utils/utility.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchFocused = false;
  List<Document> _searchResults = [];
  bool _isLoading = false;
  bool _hasMore = true;
  final int limit = 10;
  int _offset = 0;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchResults = [];
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreResults();
    }
  }

  Future<void> _loadMoreResults() async {
    if (!_isLoading && _hasMore && _currentQuery.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await database.listDocuments(
          databaseId: databaseid,
          collectionId: postCollectionid,
          queries: [
            Query.search('title', _currentQuery),
            Query.limit(limit),
            Query.offset(_offset),
          ],
        );

        setState(() {
          if (response.documents.length < limit) {
            _hasMore = false;
          }
          _searchResults.addAll(response.documents);
          _offset += response.documents.length;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showErrorSnackBar(
            "an error occured while getting data try again later",context);
      }
    }
  }

  Future<void> searchContent(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _currentQuery = '';
        _offset = 0;
        _hasMore = true;
        return;
      });
    }

    setState(() {
      _isLoading = true;
      _currentQuery = query;
      _offset = 0;
      _hasMore = true;
      _searchResults = [];
    });

    try {
      final response = await database.listDocuments(
        databaseId: databaseid,
        collectionId: postCollectionid,
        queries: [
          Query.search('title', query),
          Query.limit(limit),
          Query.offset(_offset),
        ],
      );

      setState(() {
        _searchResults = response.documents;
        _offset = response.documents.length;
        _hasMore = response.documents.length >= limit;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error searching: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isSearchFocused = hasFocus;
          });
        },
        child: TextFormField(
          controller: _searchController,
          cursorColor: primaryGreen,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            prefixIcon: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.search_outlined,
                color: _isSearchFocused ? primaryGreen : Colors.white70,
                size: 24,
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white70),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        searchContent('');
                      });
                    },
                  )
                : null,
            hintText: 'Search...',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: primaryGreen,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            filled: true,
            fillColor: surfaceColor.withOpacity(0.5),
          ),
          onChanged: (value) {
            searchContent(value);
          },
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty && !_isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecentSearches(),
          _buildSuggestions(),
        ],
      );
    }

    return GridView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _searchResults.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _searchResults.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
              ),
            ),
          );
        }
        return ArticleCard(
          title: _searchResults[index].data['title']?.toString() ?? '',
          description:
              _searchResults[index].data['description']?.toString() ?? '',
          image: _searchResults[index].data['postimage']?.toString() ?? '',
          author:
              _searchResults[index].data['user']['username']?.toString() ?? '',
          date: DateTime.tryParse(
                  _searchResults[index].data['created_at']?.toString() ?? '') ??
              DateTime.now(),
          category: 'cards',
        );
      },
    );
  }

  Widget _buildRecentSearches() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Recent Searches',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Kindness', 'Love', 'Peace', 'Happiness', 'Hope']
                .map((tag) => ActionChip(
                      label: Text(
                        tag,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: accentColor,
                      side: const BorderSide(color: primaryGreen),
                      onPressed: () {
                        _searchController.text = tag;
                        searchContent(tag);
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Suggested Searches',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Popular', 'Trending', 'New', 'Featured', 'Recommended']
                .map((tag) => ActionChip(
                      label: Text(
                        tag,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: accentColor,
                      side: const BorderSide(color: primaryGreen),
                      onPressed: () {
                        _searchController.text = tag;
                        searchContent(tag);
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: _buildSearchResults(),
    );
  }
}
