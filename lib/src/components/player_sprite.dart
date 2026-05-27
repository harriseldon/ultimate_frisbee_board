import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:ultimate_coaching_board/src/common/enums.dart';
import 'package:ultimate_coaching_board/src/ultimate_board.dart';



class PlayerSprite extends SpriteComponent with HasGameReference<UltimateBoard>, DragCallbacks, CollisionCallbacks {
    PlayerSprite({
      required this.playerType,
      required super.position,
      required super.size,
    })  ;

    final PlayerType playerType;
    //final Vector2 position;

    @override
    Future<void> onLoad() async {
      final spriteFileName = 
              switch(playerType) {
                PlayerType.offence => 'blue_player.png',
                PlayerType.defence => 'red_player.png',
                _ => 'frisbee.png'
              };
      
      //playerType == PlayerType.offence ?  : 'red_player.png';
      super.sprite = await Sprite.load(spriteFileName);

      add(RectangleHitbox());
    }

    void startMoving(MovementDirection direction) {
      
    }


  @override
  void onDragUpdate(DragUpdateEvent event) {
    
    super.onDragUpdate(event);
    // velocity.x = event.localDelta.x;
    // velocity.y = event.localDelta.y;
    position.x = (position.x + event.localDelta.x).clamp(size.x, game.width-size.x);
    position.y = (position.y + event.localDelta.y).clamp(size.y, game.height-size.y);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // 2. Check if we hit the other sprite component
    if (other is PlayerSprite) {
      // Calculate the vector pointing from this sprite to the other sprite
      Vector2 pushDirection = (other.position - position).normalized();
      
      // Calculate a push distance. A simple approach uses the overlap 
      // or a fixed speed multiplier based on your drag delta.
      double pushStrength = 5.0; 
      
      // Move the second sprite away
      other.position.add(pushDirection * pushStrength);
    }
  }
}