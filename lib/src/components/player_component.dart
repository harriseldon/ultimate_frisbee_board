

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart';

import 'package:ultimate_coaching_board/src/common/enums.dart';
import 'package:ultimate_coaching_board/src/components/play_area.dart';
import 'package:ultimate_coaching_board/src/config.dart';
import 'package:ultimate_coaching_board/src/ultimate_board.dart';

class PlayerComponent  extends CircleComponent with CollisionCallbacks, DragCallbacks, HasGameReference<UltimateBoard>{
  PlayerComponent({
    required this.playerType,
    required super.position,
    required super.radius,
  }) : 
    
    super(anchor: Anchor.center, children: [RectangleHitbox()], paint: Paint()..color = playerType == PlayerType.defence ? const Color.fromARGB(255, 118, 129, 231) : const Color.fromARGB(255, 215, 53, 53)
    ..style = PaintingStyle.fill)
  ;

  final CircleHitbox hitbox = CircleHitbox();
  final PlayerType playerType;
  final Vector2 velocity = Vector2(0,0);

  @override
  onLoad() {
    hitbox.paint.color = paint.color;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    hitbox.paint.color = hitbox.paint.color.darken(0.5);

  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    hitbox.paint.color = hitbox.paint.color.brighten(0.5);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    
    super.onDragUpdate(event);
    velocity.x = event.localDelta.x;
    velocity.y = event.localDelta.y;
    position.x = (position.x + event.localDelta.x).clamp(0, game.width);
    position.y = (position.y + event.localDelta.y).clamp(0, game.height);
  }

  void moveBy(Vector2 delta) {
    add(MoveToEffect(
      Vector2((position.x + delta.x).clamp(0, game.width), (position.y + delta.y).clamp(0, game.height)),
      EffectController(duration: 0.1)
    ));
  }

  //detect collision with another play and force it move
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerComponent) {
      //other must move with this one
      velocity.x = other.velocity.x;
      velocity.y = other.velocity.y;
    } else if (other is PlayArea) {
      //collided with edge
      if (intersectionPoints.first.x <= 0) {
        //left edge
        position.x = radius*2;
        velocity.x = 0;
      }
      if (intersectionPoints.first.x >= gameWidth) {
        position.x = gameWidth - radius*2;
        velocity.x = 0;
      }
      if (intersectionPoints.first.y >= gameHeight) {
        position.y = gameHeight - radius*2;
        velocity.y = 0;
      }
      if (intersectionPoints.first.y <= 0) {
        position.y = radius*2;
        velocity.y = 0;
      }
    }

  }

  @override
  void onCollisionEnd(PositionComponent other) {
    
    super.onCollisionEnd( other);

    if (other is PlayerComponent) {
      debugPrint('===== Player collided with Player ${other.velocity}');
      velocity.x = 0;
      velocity.y = 0;
    } 

  }

  

}