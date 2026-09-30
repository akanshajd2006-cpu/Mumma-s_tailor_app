class Customer {
  final String id;
  final String name;
  final String phone;
  final String notes;
  // measurements: { "Kurti": { "length": "38", "chest": "36", ... }, "Blouse": {...} }
  final Map<String, Map<String, String>> measurements;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.notes = '',
    Map<String, Map<String, String>>? measurements,
  }) : measurements = measurements ?? {};

  factory Customer.fromMap(String id, Map<String, dynamic> map) {
    final rawMeasurements = map['measurements'] as Map<String, dynamic>? ?? {};
    final parsedMeasurements = <String, Map<String, String>>{};
    rawMeasurements.forEach((garment, values) {
      parsedMeasurements[garment] = Map<String, String>.from(
        (values as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
      );
    });

    return Customer(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      notes: map['notes'] ?? '',
      measurements: parsedMeasurements,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'notes': notes,
      'measurements': measurements,
    };
  }

  Customer copyWith({
    String? name,
    String? phone,
    String? notes,
    Map<String, Map<String, String>>? measurements,
  }) {
    return Customer(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      measurements: measurements ?? this.measurements,
    );
  }
}
