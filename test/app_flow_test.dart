import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickqr/main.dart';
import 'package:quickqr/models/app_settings.dart';
import 'package:quickqr/models/qr_item.dart';
import 'package:quickqr/screens/home_page.dart';
import 'package:quickqr/services/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('QrItem survives a JSON round trip', () {
    final item = QrItem(
      data: 'a@b.com',
      type: 'Email',
      createdAt: DateTime(2026, 1, 2),
    );
    final back = QrItem.fromJson(jsonDecode(jsonEncode(item.toJson())));
    expect(back.data, item.data);
    expect(back.type, item.type);
    expect(back.createdAt, item.createdAt);
  });

  test('initStorage restores saved history and settings', () async {
    SharedPreferences.setMockInitialValues({
      'darkTheme': true,
      'saveHistory': false,
      'history': jsonEncode([
        QrItem(data: 'hi', type: 'Text', createdAt: DateTime(2026)).toJson(),
      ]),
    });
    await initStorage();
    expect(themeMode.value, ThemeMode.dark);
    expect(saveHistory.value, isFalse);
    expect(qrHistory.value.single.data, 'hi');
  });

  test('corrupt stored history falls back to empty', () async {
    SharedPreferences.setMockInitialValues({'history': 'not json'});
    await initStorage();
    expect(qrHistory.value, isEmpty);
  });

  testWidgets('generating a code opens the result and records history', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    qrHistory.value = const [];
    saveHistory.value = true;
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.text('Generate QR Code'));
    await tester.pump();
    expect(find.text('Enter something to encode'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.tap(find.text('Generate QR Code'));
    await tester.pumpAndSettle();

    expect(find.text('Your QR Code'), findsOneWidget);
    expect(qrHistory.value.single.data, 'hello');
  });

  testWidgets('switching tabs clears the input', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.tap(find.text('URL'));
    await tester.pump();
    expect(find.text('abc'), findsNothing);
  });

  testWidgets('app builds with QuickQrApp', (tester) async {
    await tester.pumpWidget(const QuickQrApp());
    expect(find.text('QuickQr'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
