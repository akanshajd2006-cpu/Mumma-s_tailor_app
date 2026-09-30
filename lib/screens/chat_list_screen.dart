import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/customer.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder<List<Customer>>(
        stream: service.watchCustomers(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final customers = snap.data!;
          if (customers.isEmpty) {
            return const Center(
              child: Text('Add a customer first to start chatting.',
                  style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.separated(
            itemCount: customers.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, i) {
              final c = customers[i];
              return _ChatPreviewTile(customer: c, service: service);
            },
          );
        },
      ),
    );
  }
}

class _ChatPreviewTile extends StatelessWidget {
  final Customer customer;
  final FirestoreService service;
  const _ChatPreviewTile({required this.customer, required this.service});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: service.getLastMessagePreview(customer.id),
      builder: (context, snap) {
        final preview = snap.data;
        final text = preview?['text'] as String?;
        final sentAt = preview?['sentAt'];
        String timeLabel = '';
        if (sentAt != null) {
          final dt = sentAt.toDate();
          timeLabel = DateFormat('h:mm a').format(dt);
        }
        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            text ?? 'No messages yet — say hello!',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          trailing: Text(timeLabel, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ChatScreen(customer: customer)),
          ),
        );
      },
    );
  }
}
