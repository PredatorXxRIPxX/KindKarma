import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:kindkarma/api/api.dart';
import 'package:kindkarma/utils/notificationBuilder.dart';
import 'package:kindkarma/utils/utility.dart';

class NotificationCard extends StatelessWidget {
  final String titleEvent;
  final DateTime time;
  final String notificationid;

  const NotificationCard({
    super.key,
    required this.titleEvent,
    required this.time,
    required this.notificationid,
  });

  Future<void> _deleteNotification(BuildContext context) async {
    try {
      DocumentList documents = await database.listDocuments(
          databaseId: databaseid,
          collectionId: notificationCollection,
          queries: [Query.equal('notificationid', notificationid)]);
      if (documents.documents.isEmpty) {
        showErrorSnackBar("Notification not found", context);
        return;
      }
      await database.deleteDocument(
          databaseId: databaseid,
          collectionId: notificationCollection,
          documentId: documents.documents.first.$id);
      showSuccessSnackBar("Notification Deleted", context);
    } catch (e) {
      showErrorSnackBar("An Error has been occured", context);
    }
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      key: ObjectKey(titleEvent),
      trailingActions: [
        SwipeAction(
          onTap: (handler) {
            _deleteNotification(context);
            handler(true);
          },
          color: Colors.red,
          content: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ],
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.notifications,
                color: primaryGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleEvent,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTimeAgo(),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
