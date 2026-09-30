import 'package:cloud_firestore/cloud_firestore.dart';

class TailorOrder {
  final String id;
  final String customerId;
  final String customerName;
  final String garment;
  final Map<String, String> measurements;
  final DateTime deadline;
  final double price;
  final double advance;
  final String status; // Pending, Cutting, Sewing, Ready, Completed
  final String paymentStatus; // Unpaid, Partial, Paid
  final String notes;
  final DateTime createdAt;

  TailorOrder({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.garment,
    required this.measurements,
    required this.deadline,
    required this.price,
    required this.advance,
    this.status = 'Pending',
    required this.paymentStatus,
    this.notes = '',
    required this.createdAt,
  });

  double get due => price - advance;

  factory TailorOrder.fromMap(String id, Map<String, dynamic> map) {
    final rawMeasurements = map['measurements'] as Map<String, dynamic>? ?? {};
    return TailorOrder(
      id: id,
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      garment: map['garment'] ?? '',
      measurements: Map<String, String>.from(
        rawMeasurements.map((k, v) => MapEntry(k.toString(), v.toString())),
      ),
      deadline: (map['deadline'] as Timestamp).toDate(),
      price: (map['price'] as num).toDouble(),
      advance: (map['advance'] as num).toDouble(),
      status: map['status'] ?? 'Pending',
      paymentStatus: map['paymentStatus'] ?? 'Unpaid',
      notes: map['notes'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'garment': garment,
      'measurements': measurements,
      'deadline': Timestamp.fromDate(deadline),
      'price': price,
      'advance': advance,
      'status': status,
      'paymentStatus': paymentStatus,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
