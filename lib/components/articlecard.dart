import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/aside/carddetailed.dart';
import 'package:kindkarma/utils/utility.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final Document author;
  final DateTime date;
  final String category;

  ArticleCard({
    required this.title,
    required this.description,
    required this.image,
    required this.author,
    required this.date,
    required this.category,
  });

  String _formatTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM d').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }

    String getImageViewLink(String image) {
      return '$setEndpoint/storage/buckets/$storageid/files/$image/view?project=670d353b0011112ac560&project=$projectid&mode=admin';
    }

    
  @override
  Widget build(BuildContext context) {
    return Card(
      color: surfaceColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardDetailed(
                title: title,
                description: description,
                image: getImageViewLink(image),
                author: author.data['user'],
                date: date,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  getImageViewLink(image),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          backgroundColor: darkBackground,
                          child: Icon(
                            Icons.person,
                            color: primaryGreen,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          author.data['user']['username']?.toString() ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimeAgo(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}