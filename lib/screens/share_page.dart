import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/qr_item.dart';
import '../services/qr_export.dart';
import '../widgets/qr_preview.dart';
import '../widgets/responsive.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key, required this.item});

  final QrItem item;

  Future<void> _run(
    BuildContext context,
    Future<ShareResult> Function() share,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      final result = await share();
      // Cancelling the share sheet keeps the user on this screen.
      if (result.status == ShareResultStatus.success) {
        navigator.popUntil((route) => route.isFirst);
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Could not share: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUrl = item.type == 'URL';
    return Scaffold(
      appBar: AppBar(title: const Text('Share QR Code')),
      body: ResponsiveList(
        children: [
          Center(
            child: QrPreview(
              data: item.data,
              size: responsiveQrSize(context, 200),
            ),
          ),
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
