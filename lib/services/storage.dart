import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/qr_item.dart';

const _historyKey = 'history';
const _darkKey = 'darkTheme';
const _saveHistoryKey = 'saveHistory';

/// Loads saved settings/history, then writes them back whenever they change.
Future<void> initStorage() async {
  final prefs = await SharedPreferences.getInstance();

  themeMode.value = (prefs.getBool(_darkKey) ?? false)
      ? ThemeMode.dark
      : ThemeMode.light;
  saveHistory.value = prefs.getBool(_saveHistoryKey) ?? true;
  qrHistory.value = _decodeHistory(prefs.getString(_historyKey));

  themeMode.addListener(
    () => prefs.setBool(_darkKey, themeMode.value == ThemeMode.dark),
  );
  saveHistory.addListener(
    () => prefs.setBool(_saveHistoryKey, saveHistory.value),
  );
  qrHistory.addListener(
    () => prefs.setString(
      _historyKey,
      jsonEncode([for (final i in qrHistory.value) i.toJson()]),
    ),
  );
}

List<QrItem> _decodeHistory(String? raw) {
  if (raw == null) return const [];
  try {
    return [
      for (final e in jsonDecode(raw) as List)
        QrItem.fromJson(e as Map<String, dynamic>),
    ];
  } catch (_) {
    return const [];
  }
}
