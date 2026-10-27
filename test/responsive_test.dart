import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickqr/models/qr_item.dart';
import 'package:quickqr/screens/history_page.dart';
import 'package:quickqr/screens/home_page.dart';
import 'package:quickqr/screens/result_page.dart';
import 'package:quickqr/screens/save_page.dart';
import 'package:quickqr/screens/settings_page.dart';
import 'package:quickqr/screens/share_page.dart';

void main() {
  final item = QrItem(
    data: 'https://example.com',
    type: 'URL',
    createdAt: DateTime(2026),
  );
  final pages = <String, Widget>{
    'home': const HomePage(),
    'result': ResultPage(item: item),
    'save': SavePage(item: item),
    'share': SharePage(item: item),
    'history': const HistoryPage(),
    'settings': const SettingsPage(),
  };
  const sizes = <String, Size>{
    'small phone': Size(320, 568),
    'landscape phone': Size(800, 360),
    'tablet': Size(1024, 768),
  };

  for (final size in sizes.entries) {
    for (final page in pages.entries) {
      testWidgets('${page.key} fits on ${size.key}', (tester) async {
        tester.view.physicalSize = size.value;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        qrHistory.value = const [];
        await tester.pumpWidget(MaterialApp(home: page.value));
        await tester.pump();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
