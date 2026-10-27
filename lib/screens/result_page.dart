import 'package:flutter/material.dart';

import '../models/qr_item.dart';
import '../widgets/qr_preview.dart';
import 'save_page.dart';
import 'share_page.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.item});

  final QrItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Your QR Code')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(child: QrPreview(data: item.data, size: 240)),
          const SizedBox(height: 20),
          Text(
            item.type,
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          SelectableText(
            item.data,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => SavePage(item: item))),
            icon: const Icon(Icons.download_rounded),
            label: const Text('Save QR Code'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => SharePage(item: item))),
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share QR Code'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Generate Another'),
          ),
        ],
      ),
    );
  }
}
