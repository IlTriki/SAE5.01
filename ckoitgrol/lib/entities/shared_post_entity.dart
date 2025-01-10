class SharedPostEntity {
  final String id;
  final String postId;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;
  final bool isRead;

  SharedPostEntity({
    required this.id,
    required this.postId,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    this.isRead = false,
  });

  factory SharedPostEntity.fromJson(Map<String, dynamic> json) {
    return SharedPostEntity(
      id: json['id'],
      postId: json['postId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}
