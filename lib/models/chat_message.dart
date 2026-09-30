import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageSender { shop, customer }

class ChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime sentAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.sentAt,
    this.isRead = false,
  });

  factory ChatMessage.fromMap(String id, Map<String, dynamic> map) {
    return ChatMessage(
      id: id,
      text: map['text'] ?? '',
      sender: (map['sender'] == 'shop') ? MessageSender.shop : MessageSender.customer,
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sender': sender == MessageSender.shop ? 'shop' : 'customer',
      'sentAt': Timestamp.fromDate(sentAt),
      'isRead': isRead,
    };
  }
}
