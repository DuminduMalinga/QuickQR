import 'package:flutter/material.dart';

import '../models/qr_item.dart';

IconData _iconFor(String type) => switch (type) {
  'URL' => Icons.link_rounded,
  'Email' => Icons.email_outlined,
  'Phone' => Icons.phone_outlined,
  _ => Icons.text_fields_rounded,
};

/// A history row showing only the type icon and label (Text, URL, ...).
class QrTile extends StatelessWidget {
  const QrTile({
    super.key,
    required this.item,
    required this.onTap,
    this.trailing,
    this.contentPadding,
  });

  final QrItem item;
  final VoidCallback onTap;
  final Widget? trailing;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: contentPadding,
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        child: Icon(_iconFor(item.type)),
      ),
      title: Text(item.type),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
