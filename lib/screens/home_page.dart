import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/qr_item.dart';
import '../theme/app_colors.dart';
import '../widgets/qr_preview.dart';
import 'history_page.dart';
import 'result_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _types = ['Text', 'URL', 'Email', 'Phone'];
  static const _keyboards = [
    TextInputType.text,
    TextInputType.url,
    TextInputType.emailAddress,
    TextInputType.phone,
  ];

  final _controller = TextEditingController();
  int _type = 0;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generate() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Enter something to encode');
      return;
    }
    setState(() => _error = null);
    final item = QrItem(
      data: text,
      type: _types[_type],
      createdAt: DateTime.now(),
    );
    if (saveHistory.value) {
      qrHistory.value = [item, ...qrHistory.value];
    }
    _push(ResultPage(item: item));
  }

  void _push(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.qr_code_2_rounded, color: kIndigo, size: 30),
            SizedBox(width: 8),
            Text('QuickQR', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'History',
            icon: const Icon(Icons.history_rounded),
            onPressed: () => _push(const HistoryPage()),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _push(const SettingsPage()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Create QR codes in seconds.',
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: [
              for (var i = 0; i < _types.length; i++)
                ChoiceChip(
                  label: Text(_types[i]),
                  selected: _type == i,
                  onSelected: (_) => setState(() => _type = i),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            minLines: 1,
            maxLines: 4,
            keyboardType: _keyboards[_type],
            decoration: InputDecoration(
              labelText: '${_types[_type]} to encode',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _generate(),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _generate,
            icon: const Icon(Icons.qr_code_rounded),
            label: const Text('Generate QR Code'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Recent',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () => _push(const HistoryPage()),
                child: const Text('See all'),
              ),
            ],
          ),
          ValueListenableBuilder<List<QrItem>>(
            valueListenable: qrHistory,
            builder: (context, items, _) {
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No QR codes yet.',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                );
              }
              return Column(
                children: [
                  for (final item in items.take(3))
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: QrPreview(data: item.data, size: 48),
                      title: Text(
                        item.data,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(item.type),
                      onTap: () => _push(ResultPage(item: item)),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
