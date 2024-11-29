import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:intl/intl.dart';
import 'package:kindkarma/aside/MypostDetails.dart';

class MyPostCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String postImage;
  final String createdAt;

  const MyPostCard({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.postImage,
    required this.createdAt,
  });

  String getImageViewLink(String image) {
    return '$setEndpoint/storage/buckets/$storageid/files/$image/view?project=670d353b0011112ac560&project=$projectid&mode=admin';
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return DateFormat('MMM d, y').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.5;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PostDetails(
                  id: id,
                  title: title,
                  description: description,
                  postImage: postImage,
                  createdAt: createdAt,
                )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: ThemeColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    getImageViewLink(postImage),
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: imageHeight,
                        color: Colors.grey[800],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              ThemeColors.primaryGreen,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: imageHeight,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.white54,
                        size: 32,
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildInteractionButton(
                            Icons.remove_red_eye,
                            '24',
                          ),
                        ],
                      ),
                      Text(
                        _formatDate(createdAt),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class ThemeColors {
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color cardColor = Color(0xFF252525);
}
