import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

const _statusFlow = ['Pending', 'Cutting', 'Sewing', 'Ready', 'Completed'];

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: StreamBuilder<List<TailorOrder>>(
        stream: service.watchOrders(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final orders = snap.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet.', style: TextStyle(color: AppColors.textSecondary)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final o = orders[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${o.customerName} — ${o.garment}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text('₹${o.price.toStringAsFixed(0)}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Due: ${o.deadline.day}/${o.deadline.month}/${o.deadline.year}  •  Due amount: ₹${o.due.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: o.status,
                        decoration: const InputDecoration(labelText: 'Status', isDense: true),
                        items: _statusFlow.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (value) {
                          if (value != null) service.updateOrderStatus(o.id, value);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
