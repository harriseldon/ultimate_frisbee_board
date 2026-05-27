import 'dart:async';
import 'dart:math' as math;
//import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
//import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:ultimate_coaching_board/src/common/blue_player_guides.dart';
import 'package:ultimate_coaching_board/src/common/enums.dart';
import 'package:ultimate_coaching_board/src/components/components.dart';
import 'package:ultimate_coaching_board/src/components/pen_component.dart';

import 'package:ultimate_coaching_board/src/config.dart';

class UltimateBoard extends FlameGame
    with
        HasCollisionDetection,
        //KeyboardEvents,
        VerticalDragDetector,
        HorizontalDragDetector, TapCallbacks {
  UltimateBoard()
    : super(
        camera: CameraComponent.withFixedResolution(
          width: gameWidth,
          height: gameHeight,
        ),
      );

  double get width => size.x;
  double get height => size.y;
  final rand = math.Random();
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());

    world.add(
      PlayerSprite(playerType: PlayerType.disc, position: Vector2(width/2 - playerRadius, height*3/4 + discRadius*2), size: Vector2.all(discRadius*2))
      // DiscComponent(
      //   // Add from here...
      //   radius: discRadius,
      //   position: Vector2(width/2 - playerRadius, height*3/4 + discRadius*2),
      //   velocity: Vector2(
      //     0,0
      //   ).normalized()..scale(height / 4),
      // ),
    );

    // world.add(
    //   PlayerComponent(
    //     playerType: PlayerType.offence,
    //     position: Vector2(width / 2, height * 0.9),
    //     radius: playerRadius,
    //   ),
    // );

    // world.add(
    //   PlayerComponent(
    //     playerType: PlayerType.defence,
    //     position: Vector2(width / 2, height * 0.4),
    //     radius: playerRadius,
    //   ),
    // );

    for (int player = 0; player < 7; player++) {
     ///
     ///          O
     ///          O
     ///          O
     ///          O
     ///   
     ///   O      O      O
     
      Vector2 position;
      if (player <= 2) {
        position = Vector2( (player+1)/4 * width, height * 3/4 );
      } else {
        position = Vector2( width/2, height/3 + (player-3) * (3*playerRadius)  );
      }

      world.add(
        PlayerSprite(
          playerType: PlayerType.offence,
          position: position,
          size: Vector2.all(playerRadius * 2),
        ),
      );

      switch(player) {
        case 0:
        case 2:

           position = Vector2( (player+1)/4 * width, height * 3/4 - 2.5*playerRadius);
           break;
        case 1:
           position = Vector2( (player+1)/4 * width + playerRadius*2, height * 3/4 - 2.5*playerRadius);
           break;
        case 3:
           position = Vector2( width/2, height/3 - (2.5*playerRadius)  );
           break;
        case 4:
           position = Vector2( width/2 - 2*playerRadius, height/3 + player * (3*playerRadius) );
           break;           
        case 5:
           position = Vector2( width/2 - 2.5*playerRadius, height/2 );
           break;            

        case 6:
           position = Vector2( width/2 + 2.5*playerRadius, height/2 );
           break;         
      }

      world.add(
        PlayerSprite(
          playerType: PlayerType.defence,
          position: position,
          size: Vector2.all(playerRadius * 2),
        ),
      );
    }

    //final runnerImage = await Flame.images.load('spritesheet_blue_full.png');

    //final runner1 = _createRunner('run_south',Vector2(width/2, height*.7), runnerImage);

    // final runner = SpriteAnimationComponent.fromFrameData(
    //   runnerImage,
    //     SpriteAnimationData.range(start: 8, end: 15, amount: 40, stepTimes: List.generate(8, (_) => 0.5), textureSize: Vector2(212, 329),amountPerRow: 8,),
    //     position: Vector2(width/2, height*.7),
    //     size: Vector2(212*.9,329*.9)

    //   );

    //world.add(runner1);
    
    //debugMode = true;
  }

  @override
  void onHorizontalDragStart(DragStartInfo info) {
    debugPrint('Horizontal Drag Started on ${info.eventPosition.widget}');
    super.onHorizontalDragStart(info);
  }

  @override
  void onHorizontalDragEnd(DragEndInfo info) {
    debugPrint('Horiztonal Drag End ${info.velocity}');
    super.onHorizontalDragEnd(info);
  }

  // @override // Add from here...
  // KeyEventResult onKeyEvent(
  //   KeyEvent event,
  //   Set<LogicalKeyboardKey> keysPressed,
  // ) {
  //   super.onKeyEvent(event, keysPressed);
  //   switch (event.logicalKey) {
  //     case LogicalKeyboardKey.arrowLeft:
  //       world.children.query<PlayerComponent>().first.moveBy(
  //         Vector2(-playerStep, 0),
  //       );
  //       break;
  //     case LogicalKeyboardKey.arrowRight:
  //       world.children.query<PlayerComponent>().first.moveBy(
  //         Vector2(playerStep, 0),
  //       );
  //       break;
  //     case LogicalKeyboardKey.arrowUp:
  //       world.children.query<PlayerComponent>().first.moveBy(
  //         Vector2(0, -playerStep),
  //       );
  //       break;
  //     case LogicalKeyboardKey.arrowDown:
  //       world.children.query<PlayerComponent>().first.moveBy(
  //         Vector2(0, playerStep),
  //       );
  //       break;
  //   }
  //   return KeyEventResult.handled;
  // }

  // SpriteAnimationComponent _createRunner(
  //   String name,
  //   Vector2 position,
  //   ui.Image image,
  // ) {
  //   final numberOfImages = blue_player_guides['number_of_images'] as int;
  //   final imagesPerRow = blue_player_guides['images_per_row'] as int;
  //   final Vector2 imageSize = blue_player_guides['image_size'] as Vector2;
  //   final currentRunner = blue_player_guides[name] as Map<String, dynamic>;

  //   return SpriteAnimationComponent.fromFrameData(
  //     image,
  //     SpriteAnimationData.range(
  //       start: currentRunner['starting_index'],
  //       end: currentRunner['ending_index'],
  //       amount: numberOfImages,
  //       stepTimes: List.generate(imagesPerRow, (_) => 0.5),
  //       textureSize: imageSize,
  //       amountPerRow: imagesPerRow,
  //     ),
  //     position: position,
  //     size: imageSize.scaled(.8),
  //   );
  // }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if(!event.handled) {
      final touchPoint = event.localPosition;
      add(PenComponent(touchPoint));
    }
  }
}
