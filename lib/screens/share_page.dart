import 'package:flutter/material.dart';

import '../models/qr_item.dart';
import '../services/qr_export.dart';
import '../widgets/qr_preview.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key, required this.item});

  final QrItem item;

  Future<void> _run(BuildContext context, Future<void> Function() share) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await share();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Could not share: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUrl = item.type == 'URL';
    return Scaffold(
      appBar: AppBar(title: const Text('Share QR Code')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(child: QrPreview(data: item.data, size: 200)),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _run(context, () => shareQrImage(item.data)),
            icon: const Icon(Icons.image_outlined),
            label: const Text('Share QR Image'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _run(context, () => shareQrText(item.data)),
            icon: const Icon(Icons.link_rounded),
            label: Text(isUrl ? 'Share URL' : 'Share Text'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
