class Messagemodel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final bool isMe;
  final DateTime timestamp;
  const Messagemodel(
      {required this.message,
      this.isMe = true,
      required this.timestamp,
      required this.id,
      required this.senderId,
      required this.receiverId});

      
  factory Messagemodel.fromJson(Map<String, dynamic> json) {
    return Messagemodel(
      id: json['\$id'] ?? '',
      senderId: json['sender_id'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
