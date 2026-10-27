import 'package:flutter/material.dart';

import '../models/qr_item.dart';
import '../widgets/qr_tile.dart';
import '../widgets/responsive.dart';
import 'result_page.dart';
import 'share_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  void _push(BuildContext context, Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Codes')),
      body: ValueListenableBuilder<List<QrItem>>(
        valueListenable: qrHistory,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 64,
                      color: scheme.outline,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No QR codes yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Codes you generate will show up here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Create your first QR'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: responsivePadding(context, vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final item = items[i];
              return QrTile(
                item: item,
                onTap: () => _push(context, ResultPage(item: item)),
                trailing: PopupMenuButton<String>(
                  onSelected: (action) {
                    switch (action) {
                      case 'open':
                        _push(context, ResultPage(item: item));
                      case 'share':
                        _push(context, SharePage(item: item));
                      case 'delete':
                        qrHistory.value = [...items]..removeAt(i);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'open', child: Text('Open')),
                    PopupMenuItem(value: 'share', child: Text('Share')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
