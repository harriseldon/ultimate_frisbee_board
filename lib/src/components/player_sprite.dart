import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:ultimate_coaching_board/src/common/enums.dart';
import 'package:ultimate_coaching_board/src/ultimate_board.dart';



class PlayerSprite extends SpriteComponent with HasGameReference<UltimateBoard>, DragCallbacks {
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
}