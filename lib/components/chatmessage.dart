import 'package:flutter/material.dart';
import 'package:kindkarma/utils/utility.dart';

class Chatmessage extends StatefulWidget {
  final String message;
  final bool isMe;
  final DateTime timestamp;
  const Chatmessage({super.key, required this.message, required this.isMe, required this.timestamp});

  @override
  State<Chatmessage> createState() => _ChatmessageState();
}

class _ChatmessageState extends State<Chatmessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 10),
      child: Row(
        mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!widget.isMe) const SizedBox(width: 40),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: widget.isMe ? primaryGreen : accentColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.timestamp.hour}:${widget.timestamp.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: widget.isMe ? Colors.white70 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.isMe) const SizedBox(width: 40),
        ],
      ),
    );
  }
}