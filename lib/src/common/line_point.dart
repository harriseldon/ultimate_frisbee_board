import 'package:flutter/material.dart';

class LinePoint {
  final Offset position;
  final DateTime createdAt;

  LinePoint({
    required this.position,
    required this.createdAt,
  });

  /// Returns a normalized value (0.0 to 1.0) of the point's remaining life.
  double getAgeRatio(Duration maxAge) {
    final age = DateTime.now().difference(createdAt);
    return (age.inMilliseconds / maxAge.inMilliseconds).clamp(0.0, 1.0);
  }
}