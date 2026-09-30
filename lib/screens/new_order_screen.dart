import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/customer.dart';
import '../models/order.dart';
import '../data/measurement_templates.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final _service = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  Customer? _selectedCustomer;
  String _garment = garmentOptions.first;
  DateTime _deadline = DateTime.now().add(const Duration(days: 5));
  final _priceCtrl = TextEditingController();
  final _advanceCtrl = TextEditingController(text: '0');
  final _notesCtrl = TextEditingController();
  final Map<String, TextEditingController> _measurementCtrls = {};
  bool _saving = false;

  void _rebuildMeasurementControllers() {
    _measurementCtrls.clear();
    for (final field in measurementTemplates[_garment]!) {
      _measurementCtrls[field.key] = TextEditingController(
        text: _selectedCustomer?.measurements[_garment]?[field.key] ?? '',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _rebuildMeasurementControllers();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  void _openQuickAddCustomer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _QuickAddCustomerSheet(
        service: _service,
        onCreated: (customer) {
          setState(() {
            _selectedCustomer = customer;
            _rebuildMeasurementControllers();
          });
        },
      ),
    );
  }

  Future<void> _saveOrder() async {
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or add a customer first')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final measurements = {
        for (final entry in _measurementCtrls.entries) entry.key: entry.value.text.trim()
      };
      // Save measurements onto the customer profile for next time too.
      await _service.saveMeasurementsForCustomer(_selectedCustomer!.id, _garment, measurements);

      final order = TailorOrder(
        id: const Uuid().v4(),
        customerId: _selectedCustomer!.id,
        customerName: _selectedCustomer!.name,
        garment: _garment,
        measurements: measurements,
        deadline: _deadline,
        price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
        advance: double.tryParse(_advanceCtrl.text.trim()) ?? 0,
        paymentStatus: (double.tryParse(_advanceCtrl.text.trim()) ?? 0) <= 0 ? 'Unpaid' : 'Partial',
        notes: _notesCtrl.text.trim(),
        createdAt: DateTime.now(),
      );
      await _service.addOrder(order);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _advanceCtrl.dispose();
    _notesCtrl.dispose();
    for (final c in _measurementCtrls.values) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧵 Place New Order')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Select Customer', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<List<Customer>>(
                    stream: _service.watchCustomers(),
                    builder: (context, snap) {
                      final customers = snap.data ?? [];
                      return DropdownButtonFormField<Customer>(
                        value: _selectedCustomer,
                        isExpanded: true,
                        hint: const Text('Choose a customer'),
                        items: customers
                            .map((c) => DropdownMenuItem(value: c, child: Text('${c.name} (${c.phone})')))
                            .toList(),
                        onChanged: (c) => setState(() {
                          _selectedCustomer = c;
                          _rebuildMeasurementControllers();
                        }),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // The quick "+" add-customer button — same idea as your web app's shortcut button.
                Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _openQuickAddCustomer,
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Garment Type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _garment,
              items: garmentOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (g) => setState(() {
                _garment = g!;
                _rebuildMeasurementControllers();
              }),
            ),
            const SizedBox(height: 20),
            Text('Measurements', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...measurementTemplates[_garment]!.map((field) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _measurementCtrls[field.key],
                    decoration: InputDecoration(labelText: field.label, hintText: field.placeholder),
                  ),
                )),
            const SizedBox(height: 10),
            Text('Delivery & Payment', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDeadline,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Delivery Deadline'),
                child: Text('${_deadline.day}/${_deadline.month}/${_deadline.year}'),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Price (₹)'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a price' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _advanceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Advance Paid (₹)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Order Notes'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _saveOrder,
                child: _saving
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Place Order'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Small quick-add sheet, invoked from the "+" beside the customer dropdown —
/// mirrors the "Quick Add Customer" modal from your original web app.
class _QuickAddCustomerSheet extends StatefulWidget {
  final FirestoreService service;
  final void Function(Customer) onCreated;
  const _QuickAddCustomerSheet({required this.service, required this.onCreated});

  @override
  State<_QuickAddCustomerSheet> createState() => _QuickAddCustomerSheetState();
}

class _QuickAddCustomerSheetState extends State<_QuickAddCustomerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final customer = Customer(id: '', name: _nameCtrl.text.trim(), phone: _phoneCtrl.text.trim());
    final id = await widget.service.addCustomer(customer);
    if (mounted) {
      widget.onCreated(Customer(id: id, name: customer.name, phone: customer.phone));
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Add Customer', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Add & Select'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
