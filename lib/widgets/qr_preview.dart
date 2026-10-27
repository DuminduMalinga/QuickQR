import 'package:flutter/material.dart';

/// Placeholder QR rendering: a deterministic pattern derived from [data].
/// Not scannable; swap for a real QR encoder (e.g. qr_flutter) later.
class QrPreview extends StatelessWidget {
  const QrPreview({super.key, required this.data, this.size = 220});

  final String data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.06),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.07),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: CustomPaint(painter: _QrPainter(data)),
    );
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.data);

  final String data;
  static const _n = 25;

  bool _inFinder(int r, int c) =>
      (r < 7 && c < 7) || (r < 7 && c >= _n - 7) || (r >= _n - 7 && c < 7);

  @override
  void paint(Canvas canvas, Size size) {
    final m = size.shortestSide / _n;
    final paint = Paint()..color = Colors.black;
    var seed = data.hashCode & 0x7fffffff;

    void cell(int r, int c) =>
        canvas.drawRect(Rect.fromLTWH(c * m, r * m, m + 0.4, m + 0.4), paint);

    for (var r = 0; r < _n; r++) {
      for (var c = 0; c < _n; c++) {
        if (_inFinder(r, c)) continue;
        seed = (seed * 1103515245 + 12345) & 0x7fffffff;
        if ((seed >> 16) % 2 == 0) cell(r, c);
      }
    }
    for (final origin in const [(0, 0), (0, _n - 7), (_n - 7, 0)]) {
      for (var r = 0; r < 7; r++) {
        for (var c = 0; c < 7; c++) {
          final ring = r == 0 || r == 6 || c == 0 || c == 6;
          final core = r >= 2 && r <= 4 && c >= 2 && c <= 4;
          if (ring || core) cell(origin.$1 + r, origin.$2 + c);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrPainter old) => old.data != data;
}
