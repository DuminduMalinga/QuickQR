import 'package:flutter/foundation.dart';

class QrItem {
  const QrItem({
    required this.data,
    required this.type,
    required this.createdAt,
  });

  final String data;
  final String type;
  final DateTime createdAt;
}

/// In-memory list of generated codes, newest first.
final ValueNotifier<List<QrItem>> qrHistory = ValueNotifier(const []);
