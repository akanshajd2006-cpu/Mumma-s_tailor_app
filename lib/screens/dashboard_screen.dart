import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/customer.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();
    return Scaffold(
      appBar: AppBar(title: const Text("Mumma's Tailor Hub")),
      body: StreamBuilder<List<TailorOrder>>(
        stream: service.watchOrders(),
        builder: (context, orderSnap) {
          final orders = orderSnap.data ?? [];
          final pending = orders.where((o) => o.status != 'Completed').length;
          final readyToday = orders.where((o) => o.status == 'Ready').length;
          final dueAmount = orders.fold<double>(0, (sum, o) => sum + o.due);

          return StreamBuilder<List<Customer>>(
            stream: service.watchCustomers(),
            builder: (context, custSnap) {
              final customerCount = custSnap.data?.length ?? 0;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _StatCard(label: 'Pending Orders', value: '$pending', icon: Icons.hourglass_bottom, color: AppColors.warning),
                      _StatCard(label: 'Ready to Deliver', value: '$readyToday', icon: Icons.local_shipping, color: AppColors.success),
                      _StatCard(label: 'Total Customers', value: '$customerCount', icon: Icons.people, color: AppColors.primary),
                      _StatCard(label: 'Amount Due', value: '₹${dueAmount.toStringAsFixed(0)}', icon: Icons.currency_rupee, color: AppColors.danger),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Recent Orders', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (orders.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text('No orders yet — tap "New Order" to add one.', style: TextStyle(color: AppColors.textSecondary))),
                    )
                  else
                    ...orders.take(5).map((o) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text('${o.customerName} — ${o.garment}'),
                            subtitle: Text('Due: ${o.deadline.day}/${o.deadline.month}/${o.deadline.year}'),
                            trailing: _StatusChip(status: o.status),
                          ),
                        )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  Color get _color {
    switch (status) {
      case 'Completed': return AppColors.success;
      case 'Ready': return AppColors.primary;
      case 'Cutting': case 'Sewing': return AppColors.warning;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: _color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
