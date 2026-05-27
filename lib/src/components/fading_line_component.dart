import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_coaching_board/src/common/line_point.dart';


class FadingLineComponent extends PositionComponent {
  final List<LinePoint> _points = [];
  
  // Configuration
  final Duration maxAge = const Duration(milliseconds: 600);
  final double strokeWidth = 8.0;

  FadingLineComponent() {
    // Ensure the component matches the game size so it can draw anywhere
    size = Vector2.zero(); 
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  /// Call this from your game's drag event detectors
  void addPoint(Vector2 gamePosition) {
    _points.add(
      LinePoint(
        position: Offset(gamePosition.x, gamePosition.y),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Remove points that have outlived the max age
    _points.removeWhere((point) => point.getAgeRatio(maxAge) >= 1.0);
  }

  @override
  void render(Canvas canvas) {
    if (_points.length < 2) return;

    // 1. Build the path connecting all active points
    final path = ui.Path();
    path.moveTo(_points.first.position.dx, _points.first.position.dy);
    
    for (int i = 1; i < _points.length; i++) {
      path.lineTo(_points[i].position.dx, _points[i].position.dy);
    }

    // 2. Compute a bounding rect for the path to constrain the gradient
    final bounds = path.getBounds();
    if (bounds.isEmpty) return;

    // 3. Setup the Base Paint with Blue -> Red Gradient
    // Note: This applies the gradient across the spatial bounding box of the line.
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = ui.Gradient.linear(
        bounds.topLeft,
        bounds.bottomRight,
        [Colors.blue, Colors.red],
      );

    // 4. Create the Glow Layer (Draw this first underneath)
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 2.2 // Wider for outer glow glow
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = basePaint.shader
      // MaskFilter creates the soft blur effect
      ..imageFilter = ui.ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0);

    // 5. Draw the glow, then the sharp core line
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, basePaint);
  }
}