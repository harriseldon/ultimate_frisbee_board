import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_coaching_board/src/components/components.dart';
import 'package:ultimate_coaching_board/src/ultimate_board.dart';

class DiscComponent extends CircleComponent with CollisionCallbacks, HasGameReference<UltimateBoard> {
  DiscComponent({
    required this.velocity,
    required super.position,
    required double radius,
  }) : super(
         radius: radius,
         anchor: Anchor.center,
         paint: Paint()
           ..color = const Color(0xff1e6091)
           ..style = PaintingStyle.fill,
         children: [RectangleHitbox()]
       );

  final Vector2 velocity;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayArea) {
      debugPrint('===== Collided with UltimateBoard (${intersectionPoints.first.x}, ${intersectionPoints.first.y})');
     if(intersectionPoints.first.y <= 0) {
      velocity.y = -velocity.y;
     } else if (intersectionPoints.first.x <= 0) {
      velocity.x = -velocity.x;
     } else if (intersectionPoints.first.x >= game.width) {
      velocity.x = -velocity.x;
     } else if (intersectionPoints.first.y >= game.height) {
      velocity.y = -velocity.y;
      //velocity.x = -velocity.x;
     } 

    } else if (other is PlayerComponent) {
      //nudge the player component and return
      other.moveBy(velocity);
      velocity.y = -velocity.y;
      velocity.x =
          velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;

    }
    
    
      else {
      debugPrint('===== Collision with $other');
    }
  }
}
