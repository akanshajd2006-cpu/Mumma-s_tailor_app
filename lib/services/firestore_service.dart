import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer.dart';
import '../models/order.dart';
import '../models/chat_message.dart';

/// Single place that talks to Firestore. Every screen goes through here
/// instead of touching FirebaseFirestore directly — keeps the backend
/// swappable later if you ever want to move off Firebase.
class FirestoreService {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _customers => _db.collection('customers');
  CollectionReference get _orders => _db.collection('orders');

  // ---------------- CUSTOMERS ----------------

  Stream<List<Customer>> watchCustomers() {
    return _customers.orderBy('name').snapshots().map((snap) => snap.docs
        .map((d) => Customer.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList());
  }

  Future<Customer?> getCustomer(String id) async {
    final doc = await _customers.doc(id).get();
    if (!doc.exists) return null;
    return Customer.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<String> addCustomer(Customer customer) async {
    final ref = await _customers.add(customer.toMap());
    return ref.id;
  }

  Future<void> updateCustomer(Customer customer) {
    return _customers.doc(customer.id).update(customer.toMap());
  }

  Future<void> saveMeasurementsForCustomer(
      String customerId, String garment, Map<String, String> values) async {
    await _customers.doc(customerId).update({
      'measurements.$garment': values,
    });
  }

  Future<bool> phoneExists(String phone) async {
    final query = await _customers.where('phone', isEqualTo: phone).limit(1).get();
    return query.docs.isNotEmpty;
  }

  // ---------------- ORDERS ----------------

  Stream<List<TailorOrder>> watchOrders() {
    return _orders.orderBy('createdAt', descending: true).snapshots().map(
        (snap) => snap.docs
            .map((d) => TailorOrder.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addOrder(TailorOrder order) {
    return _orders.doc(order.id).set(order.toMap());
  }

  Future<void> updateOrderStatus(String orderId, String status) {
    return _orders.doc(orderId).update({'status': status});
  }

  Future<int> getNextOrderNumber() async {
    final counterRef = _db.collection('meta').doc('counters');
    return _db.runTransaction<int>((txn) async {
      final snap = await txn.get(counterRef);
      int next = 1001;
      if (snap.exists && snap.data()!.containsKey('nextOrderNum')) {
        next = snap.data()!['nextOrderNum'] as int;
      }
      txn.set(counterRef, {'nextOrderNum': next + 1}, SetOptions(merge: true));
      return next;
    });
  }

  // ---------------- CHAT (built-in messaging per customer) ----------------

  CollectionReference _messages(String customerId) =>
      _customers.doc(customerId).collection('messages');

  Stream<List<ChatMessage>> watchMessages(String customerId) {
    return _messages(customerId).orderBy('sentAt').snapshots().map((snap) =>
        snap.docs
            .map((d) => ChatMessage.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> sendMessage(String customerId, ChatMessage message) {
    return _messages(customerId).add(message.toMap());
  }

  /// Returns last message + unread count for every customer, used on the
  /// Chats list screen (like WhatsApp's home screen).
  Future<Map<String, dynamic>> getLastMessagePreview(String customerId) async {
    final snap = await _messages(customerId)
        .orderBy('sentAt', descending: true)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return {'text': null, 'sentAt': null};
    final data = snap.docs.first.data() as Map<String, dynamic>;
    return {'text': data['text'], 'sentAt': data['sentAt']};
  }
}
