import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
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
  XFile? _image;
  late Userprovider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<Userprovider>(context, listen: false);
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getImageViewLink(String image) {
    String storageid = AppwriteService.storageId;
    String projectid = AppwriteService.projectId;
    String setEndpoint = AppwriteService.setEndpoint;
    return '$setEndpoint/storage/buckets/$storageid/files/$image/view?project=670d353b0011112ac560&project=$projectid&mode=admin';
  }

  Future<void> _updatePost() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final idDoc = await _findPostDocument();
      await _performPostUpdate(idDoc);
      _handleSuccessfulUpdate();
    } catch (e) {
      _handleUpdateError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateInputs() {
    if (_titleController.text.trim().isEmpty || 
        _descriptionController.text.trim().isEmpty) {
      showInfoSnackBar('Please fill in all required fields', context);
      return false;
    }
    return true;
  }

  Future<DocumentList> _findPostDocument() async {
    return await AppwriteService.databases.listDocuments(
      databaseId: AppwriteService.databaseId,
      collectionId: AppwriteService.postCollectionId,
      queries: [Query.equal('idpost', widget.id)],
    );
  }

  Future<void> _performPostUpdate(DocumentList idDoc) async {
    await AppwriteService.databases.updateDocument(
      databaseId: AppwriteService.databaseId,
      collectionId: AppwriteService.postCollectionId,
      documentId: idDoc.documents.first.$id,
      data: {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'created_at': DateTime.now().toLocal().toIso8601String(),
      },
    );
  }

  void _handleSuccessfulUpdate() {
    Navigator.pop(context, true);
    setState(() => _isEditing = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post updated successfully'),
          backgroundColor: primaryGreen,
        ),
      );
    }
  }

  void _handleUpdateError(Object e) {
    setState(() {
      _errorMessage = 'Failed to update post: ${e.toString()}';
    });
  }

  Future<void> _uploadContent() async {
    if (!_validateContentUpload()) return;

    setState(() => _isLoading = true);
    
    try {
      final docid = await _findPostDocument();
      await _deleteExistingImage(docid);
      final fileId = await _uploadNewImage();
      await _updatePostWithNewImage(docid, fileId);
      
      _handleSuccessfulContentUpload();
    } catch (e) {
      showErrorSnackBar('Check your network connection', context);
    } finally {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  bool _validateContentUpload() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _image == null) {
      showInfoSnackBar('You need to fill all the information', context);
      return false;
    }
    return true;
  }

  Future<void> _deleteExistingImage(DocumentList docid) async {
    await AppwriteService.storage.deleteFile(
      bucketId: AppwriteService.storageId, 
      fileId: docid.documents.first.data['postimage']
    );
  }

  Future<String> _uploadNewImage() async {
    final fileId = ID.unique();
    await AppwriteService.storage.createFile(
      bucketId: AppwriteService.storageId,
      fileId: fileId,
      file: InputFile.fromPath(path: _image!.path)
    );
    return fileId;
  }

  Future<void> _updatePostWithNewImage(DocumentList docid, String fileId) async {
    await AppwriteService.databases.updateDocument(
      databaseId: AppwriteService.databaseId,
      collectionId: AppwriteService.postCollectionId,
      documentId: docid.documents.first.$id,
      data: {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'created_at': DateTime.now().toIso8601String(),
        'postimage': fileId,
        'idpost': ID.unique(),
      }
    );
  }

  void _handleSuccessfulContentUpload() {
    setState(() => _isEditing = false);
    showSuccessSnackBar('Content successfully updated', context);
  }

  Future<void> _deletePost() async {
    final shouldDelete = await _showDeleteConfirmationDialog();
    if (!shouldDelete) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final idDoc = await _findPostDocument();
      await _performPostDeletion(idDoc);
      _handleSuccessfulDeletion();
    } catch (e) {
      _handleDeletionError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _performPostDeletion(DocumentList idDoc) async {
    await AppwriteService.databases.deleteDocument(
      databaseId: AppwriteService.databaseId,
      collectionId: AppwriteService.postCollectionId,
      documentId: idDoc.documents.first.$id,
    );
  }

  void _handleSuccessfulDeletion() {
    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post deleted successfully'),
          backgroundColor: primaryGreen,
        ),
      );
    }
  }

  void _handleDeletionError(Object e) {
    setState(() {
      _errorMessage = 'Failed to delete post: ${e.toString()}';
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source, 
      imageQuality: 80
    );

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      _uploadContent();
    }
  }

  Widget _buildImageSourceSelector() {
    return BottomSheet(
      backgroundColor: surfaceColor,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.25,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildSourceButton(
                  icon: Icons.image,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      onClosing: () {},
    );
  }

  Widget _buildSourceButton({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _isEditing ? _buildEditingBottomBar() : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: surfaceColor,
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
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          _buildPostContent(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        _buildNetworkImage(),
        if (_isEditing) _buildImageEditButton(),
      ],
    );
  }

  Widget _buildNetworkImage() {
    return Image.network(
      _getImageViewLink(widget.postImage),
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildImageLoadingIndicator(loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) => _buildImageErrorPlaceholder(),
    );
  }

  Widget _buildImageLoadingIndicator(ImageChunkEvent loadingProgress) {
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
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      height: 300,
      color: Colors.grey[800],
      child: const Icon(Icons.error_outline, size: 50),
    );
  }

  Widget _buildImageEditButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        backgroundColor: primaryGreen,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildImageSourceSelector(),
          );
        },
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPostContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildErrorMessageWidget(),
          _buildTitleWidget(),
          const SizedBox(height: 16),
          _buildDescriptionWidget(),
          const SizedBox(height: 24),
          _buildCreatedDateWidget(),
        ],
      ),
    );
  }

  Widget _buildErrorMessageWidget() {
    if (_errorMessage == null) return const SizedBox.shrink();
    return Container(
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
    );
  }

  Widget _buildTitleWidget() {
    if (!_isEditing) {
      return Text(
        widget.title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }
    
    return TextField(
      controller: _titleController,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: 'Enter post title',
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
        ),
        border: InputBorder.none,
      ),
      maxLines: null,
    );
  }

  Widget _buildDescriptionWidget() {
    if (!_isEditing) {
      return Text(
        widget.description,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
      );
    }
    
    return TextField(
      controller: _descriptionController,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      decoration: InputDecoration(
        hintText: 'Enter post description',
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
        ),
        border: InputBorder.none,
      ),
      maxLines: null,
    );
  }

  Widget _buildCreatedDateWidget() {
    final formattedDate = DateFormat('MMMM d, yyyy, h:mm a')
        .format(DateTime.parse(widget.createdAt));
    
    return Text(
      'Created on: $formattedDate',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white54,
      ),
    );
  }

  Widget _buildEditingBottomBar() {
    return BottomAppBar(
      color: primaryGreen,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => setState(() => _isEditing = false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _updatePost,
            style: ElevatedButton.styleFrom(
              backgroundColor: surfaceColor,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}