import 'package:flutter/material.dart';

import '../models/qr_item.dart';
import '../services/qr_export.dart';
import '../widgets/qr_preview.dart';
import '../widgets/responsive.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key, required this.item});

  final QrItem item;

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  final _name = TextEditingController();
  String? _savedAs;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool _saving = false;

  Future<void> _save() async {
    final typed = _name.text.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final name = typed.isEmpty
        ? 'qr_${DateTime.now().millisecondsSinceEpoch}'
        : typed;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    try {
      await saveQrToGallery(widget.item.data, name);
      messenger.showSnackBar(
        SnackBar(content: Text('Saved $name.png to Gallery')),
      );
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Could not save: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final saved = _savedAs != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Save QR Code')),
      body: ResponsiveList(
        children: [
          Center(
            child: QrPreview(
              data: widget.item.data,
              size: responsiveQrSize(context, 200),
            ),
          ),
          const SizedBox(height: 24),
          if (!saved) ...[
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'File name (optional)',
                suffixText: '.png',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Save to Gallery'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ] else ...[
            Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 56,
            ),
            const SizedBox(height: 12),
            const Text(
              'Saved to Gallery',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(_savedAs!, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ],
      ),
    );
  }
}
