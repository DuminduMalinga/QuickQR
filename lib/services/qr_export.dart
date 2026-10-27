import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// Renders [data] as a PNG with a white background and quiet-zone margin.
Future<Uint8List> renderQrPng(String data, {double size = 1024}) async {
  final painter = QrPainter(
    data: data,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.M,
    eyeStyle: const QrEyeStyle(color: Colors.black),
    dataModuleStyle: const QrDataModuleStyle(color: Colors.black),
  );
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size, size),
    Paint()..color = Colors.white,
  );
  final margin = size * 0.06;
  canvas.translate(margin, margin);
  painter.paint(canvas, Size.square(size - margin * 2));
  final image = await recorder.endRecording().toImage(
    size.toInt(),
    size.toInt(),
  );
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}

Future<void> saveQrToGallery(String data, String name) async {
  final bytes = await renderQrPng(data);
  await Gal.putImageBytes(bytes, name: name);
}

Future<ShareResult> shareQrImage(String data) async {
  final bytes = await renderQrPng(data);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/quickqr_share.png');
  await file.writeAsBytes(bytes);
  return SharePlus.instance.share(
    ShareParams(files: [XFile(file.path, mimeType: 'image/png')]),
  );
}

Future<ShareResult> shareQrText(String data) =>
    SharePlus.instance.share(ShareParams(text: data));
