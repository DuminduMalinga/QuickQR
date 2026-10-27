import 'package:flutter/foundation.dart';

class QrItem {
  const QrItem({
    required this.data,
    required this.type,
    required this.createdAt,
  });

  factory QrItem.fromJson(Map<String, dynamic> json) => QrItem(
    data: json['data'] as String,
    type: json['type'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  final String data;
  final String type;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'data': data,
    'type': type,
    'createdAt': createdAt.toIso8601String(),
  };
}

/// Generated codes, newest first. Persisted by `initStorage`.
final ValueNotifier<List<QrItem>> qrHistory = ValueNotifier(const []);
