import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPreview extends StatelessWidget {
  const QrPreview({super.key, required this.data, this.size = 220});

  final String data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.07),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: QrImageView(
        data: data,
        padding: EdgeInsets.all(size * 0.06),
        backgroundColor: Colors.white,
        errorCorrectionLevel: QrErrorCorrectLevel.M,
        eyeStyle: const QrEyeStyle(color: Colors.black),
        dataModuleStyle: const QrDataModuleStyle(color: Colors.black),
        errorStateBuilder: (context, error) => const Center(
          child: Icon(Icons.error_outline_rounded, color: Colors.black45),
        ),
      ),
    );
  }
}
