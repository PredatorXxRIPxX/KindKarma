import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kindkarma/api/api.dart';
import 'package:intl/intl.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:kindkarma/utils/notificationBuilder.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:provider/provider.dart';

class PostDetails extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String postImage;
  final String createdAt;

  const PostDetails({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.postImage,
    required this.createdAt,
  });

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isEditing = false;
  bool _isLoading = false;
  String? _errorMessage;
  XFile? image;
  late Userprovider userprovider;
  bool isuploading = false;
  final idPost = ID.unique();

  @override
  void initState() {
    super.initState();
    userprovider = Provider.of<Userprovider>(context, listen: false);
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String getImageViewLink(String image) {
    return '$setEndpoint/storage/buckets/$storageid/files/$image/view?project=670d353b0011112ac560&project=$projectid&mode=admin';
  }

  Future<void> _updatePost() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final idDoc = await database.listDocuments(
          databaseId: databaseid,
          collectionId: postCollectionid,
          queries: [
            Query.equal('idpost', widget.id),
          ]);
      print(idDoc.documents.first.$id);
      database.updateDocument(
          databaseId: databaseid,
          collectionId: postCollectionid,
          documentId: idDoc.documents.first.$id,
          data: {
            'title': _titleController.text,
            'description': _descriptionController.text,
            'created_at': DateTime.now().toLocal(),
          });

      Navigator.pop(context, true);

      setState(() {
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post updated successfully' ),
            backgroundColor: ThemeColors.primaryGreen,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update post: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Widget?> selectSource(BuildContext context) {
    return showModalBottomSheet<Widget>(
      backgroundColor: surfaceColor,
      elevation: 7.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOptionButton(
                      context: context,
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        addContent(context, 'camera');
                      },
                    ),
                    _buildOptionButton(
                      context: context,
                      icon: Icons.image,
                      label: 'Gallery',
                      onTap: () {
                        addContent(context, 'gallery');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadcontent(BuildContext context) async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        image == null) {
      showInfoSnackBar('you need to fill all the information', context);
      return;
    }
    isuploading = true;
    if (isuploading) {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryGreen,
              ),
            );
          });
    }
    try {
      final docid = await database.listDocuments(
          databaseId: databaseid,
          collectionId: postCollectionid,
          queries: [
            Query.equal('idpost', widget.id),
          ]);

      await storage.deleteFile(
          bucketId: storageid, fileId: docid.documents.first.data['postimage']);

      final fileId = ID.unique();
      final idPost = ID.unique();

      await storage.createFile(
          bucketId: storageid,
          fileId: fileId,
          file: InputFile.fromPath(path: image!.path));

      await database.updateDocument(
          databaseId: databaseid,
          collectionId: postCollectionid,
          documentId: docid.documents.first.$id,
          data: {
            'title': _titleController.text,
            'description': _descriptionController.text,
            'created_at': DateTime.now().toIso8601String(),
            'postimage': fileId,
            'idpost': idPost,
          });
        setState(() {
          _isEditing = false;
        });
      showSuccessSnackBar('Content added successfully updated image', context);
    } catch (e) {
      showErrorSnackBar('check your network connection', context);
    } finally {
      setState(() {
        isuploading = false;
      });
      Navigator.pop(context);
    }
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: primaryGreen,
              size: 50,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addContent(BuildContext context, String source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile;

    if (source == 'camera') {
      pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    } else {
      pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    }

    setState(() {
      image = pickedFile;
    });
    _uploadcontent(context);
  }

  Future<void> _deletePost() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.cardColor,
        title: const Text(
          'Delete Post',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final idDoc = await database.listDocuments(
          databaseId: databaseid,
          collectionId: postCollectionid,
          queries: [
            Query.equal('idpost', widget.id),
          ]);

      await database.deleteDocument(
        databaseId: databaseid,
        collectionId: postCollectionid,
        documentId: idDoc.documents.first.$id,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post deleted successfully'),
            backgroundColor: ThemeColors.primaryGreen,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to delete post: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.darkBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: ThemeColors.surfaceColor,
        title: const Text('Post Details'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => setState(() => _isEditing = true),
            ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _isLoading ? null : _deletePost,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  getImageViewLink(widget.postImage),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 300,
                      color: Colors.grey[800],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[800],
                    child: const Icon(Icons.error_outline, size: 50),
                  ),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      backgroundColor: primaryGreen,
                      onPressed: () {
                        selectSource(context);
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (_isEditing)
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: ThemeColors.primaryGreen),
                        ),
                      ),
                    )
                  else
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (_isEditing)
                    TextField(
                      controller: _descriptionController,
                      maxLines: null,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: ThemeColors.primaryGreen),
                        ),
                      ),
                    )
                  else
                    Text(
                      widget.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Created on ${DateFormat('MMM d, y').format(DateTime.parse(widget.createdAt))}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isEditing
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeColors.surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => setState(() => _isEditing = false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _updatePost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Save Changes'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class ThemeColors {
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color darkBackground = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color cardColor = Color(0xFF252525);
}
