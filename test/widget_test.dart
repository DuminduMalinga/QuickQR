import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quickqr/main.dart';
import 'package:quickqr/screens/home_page.dart';
import 'package:quickqr/screens/splash_page.dart';

void main() {
  testWidgets('renders the QuickQR splash identity', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuickQrApp());

    expect(find.text('QuickQR'), findsOneWidget);
    expect(find.text('Create. Save. Share.'), findsOneWidget);
    expect(find.byType(SplashPage), findsOneWidget);
  });

  testWidgets('completes the splash sequence and opens home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuickQrApp());
    await tester.pump(const Duration(milliseconds: 1500));

    expect(find.byType(SplashPage), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1500));
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Generate QR Code'), findsOneWidget);
  });

  testWidgets('splash remains usable at Android frame size', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const QuickQrApp());

    expect(find.text('QuickQR'), findsOneWidget);
    expect(find.text('Create. Save. Share.'), findsOneWidget);
  });
}
