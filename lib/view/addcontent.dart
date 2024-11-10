import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/controllers/userprovider.dart';
import 'package:kindkarma/utils/notificationBuilder.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:provider/provider.dart';

class AddContent extends StatefulWidget {
  const AddContent({super.key});

  @override
  State<AddContent> createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  String title = '';
  String description = '';
  XFile? image;
  late Userprovider userprovider;
  bool isuploading = false;

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
                        Navigator.pop(context);
                        addContent(context, 'camera');
                      },
                    ),
                    _buildOptionButton(
                      context: context,
                      icon: Icons.image,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
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
    if (title.isEmpty || description.isEmpty || image == null) {
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
      final fileId = ID.unique();
      await storage.createFile(
          bucketId: storageid,
          fileId: fileId,
          file: InputFile.fromPath(path: image!.path));
      final idPost = ID.unique();

      final userid = account.get().then((value){
        return value.$id;
      });
      
      print('from provider ${userprovider.userid}');
      // error is here 
      await database.createDocument(
          databaseId: databaseid,
          collectionId: postCollectionid,
          documentId: idPost,
          data: {
            'title': title,
            'description': description,
            'postimage': fileId,
            'idpost': idPost,
            'user': userprovider.userid,
            'created_at': DateTime.now().toString(),
          });
      showSuccessSnackBar('Content added successfully', context);
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
  }

  @override
  void initState() {
    userprovider = Provider.of<Userprovider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Add Content:',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  selectSource(context);
                },
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(image!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: primaryGreen,
                            size: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Add Image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              cursorColor: primaryGreen,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryGreen),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              cursorColor: primaryGreen,
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryGreen),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                _uploadcontent(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Content',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
