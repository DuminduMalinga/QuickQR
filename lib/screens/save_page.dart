import 'package:flutter/material.dart';

import '../models/qr_item.dart';
import '../theme/app_colors.dart';
import '../widgets/qr_preview.dart';

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

  void _save() {
    final name = _name.text.trim();
    setState(() {
      _savedAs = name.isEmpty
          ? 'qr_${DateTime.now().millisecondsSinceEpoch}.png'
          : '$name.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    final saved = _savedAs != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Save QR Code')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(child: QrPreview(data: widget.item.data, size: 200)),
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
              onPressed: _save,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Save to Gallery'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ] else ...[
            const Icon(Icons.check_circle_rounded, color: kIndigo, size: 56),
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
