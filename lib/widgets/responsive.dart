import 'dart:math' as math;

import 'package:flutter/material.dart';

const _maxContentWidth = 560.0;

/// Page padding that keeps content in a centered column on wide screens.
EdgeInsets responsivePadding(
  BuildContext context, {
  double vertical = 24,
  double minHorizontal = 24,
}) {
  final width = MediaQuery.sizeOf(context).width;
  final horizontal = math.max(minHorizontal, (width - _maxContentWidth) / 2);
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}

/// QR size that fits the screen width and leaves room in landscape.
double responsiveQrSize(BuildContext context, double preferred) {
  final size = MediaQuery.sizeOf(context);
  final limit = math.min(size.width - 48, size.height * 0.42);
  return math.max(120, math.min(preferred, limit));
}

class ResponsiveList extends StatelessWidget {
  const ResponsiveList({
    super.key,
    required this.children,
    this.vertical = 24,
    this.minHorizontal = 24,
  });

  final List<Widget> children;
  final double vertical;
  final double minHorizontal;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: responsivePadding(
        context,
        vertical: vertical,
        minHorizontal: minHorizontal,
      ),
      children: children,
    );
  }
}
