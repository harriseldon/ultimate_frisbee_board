import 'dart:async';
import 'dart:math' as math;
//import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
//import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

//import 'package:flutter/services.dart';
//import 'package:ultimate_coaching_board/src/common/blue_player_guides.dart';
import 'package:ultimate_coaching_board/src/common/enums.dart';
import 'package:ultimate_coaching_board/src/components/components.dart';

import 'package:ultimate_coaching_board/src/config.dart';

class UltimateBoard extends FlameGame
    with HasCollisionDetection, DragCallbacks, TapCallbacks {
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
  late final FadingLineComponent _fadingLineComponent;
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());

    world.add(
      PlayerSprite(
        playerType: PlayerType.disc,
        position: _getDefaultPlayerPosition(
          PlayerType.disc,
          0,
          BaseFormation.verticalStack,
        ),

        size: Vector2.all(discRadius * 2),
      ),
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

      world.add(
        PlayerSprite(
          playerType: PlayerType.offence,
          position: _getDefaultPlayerPosition(
            PlayerType.offence,
            player,
            BaseFormation.verticalStack,
          ),
          size: Vector2.all(playerRadius * 2),
        ),
      );

      world.add(
        PlayerSprite(
          playerType: PlayerType.defence,
          position: _getDefaultPlayerPosition(
            PlayerType.defence,
            player,
            BaseFormation.verticalStack,
          ),
          size: Vector2.all(playerRadius * 2),
        ),
      );
    }

    _fadingLineComponent = FadingLineComponent(
      maxAge: Duration(milliseconds: 1200),
    );

    world.add(_fadingLineComponent);

    final buttonUp = await Sprite.load('button_up.png');
    final buttonDown = await Sprite.load('button_down.png');

    // H and V buttons
    final vButton = SpriteButton(
      onPressed: () => _resetToFormation(BaseFormation.verticalStack),
      label: Text('V'),
      width: 16,
      height: 16,
      sprite: buttonUp, 
      pressedSprite: buttonDown,

    );

    final hButton = SpriteButton(
      onPressed: () => _resetToFormation(BaseFormation.horizontalStack),
      label: Text('H'),
      width: 16,
      height: 16,
      sprite: buttonUp, 
      pressedSprite: buttonDown,

    );    

    //world.add(vButton)
    

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
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final worldPosition = camera.globalToLocal(event.localPosition);
    _fadingLineComponent.addPoint(worldPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // Send the local game position of the finger to the line renderer
    // Use pagePosition and convert it to world coordinates if your game has a moving camera

    final worldPosition = camera.globalToLocal(event.localEndPosition);

    _fadingLineComponent.addPoint(worldPosition);
    super.onDragUpdate(event);
  }

  // @override
  // void onHorizontalDragStart(DragStartInfo info) {
  //   debugPrint('Horizontal Drag Started on ${info.eventPosition.widget}');
  //   super.onHorizontalDragStart(info);
  // }

  // @override
  // void onHorizontalDragEnd(DragEndInfo info) {
  //   debugPrint('Horiztonal Drag End ${info.velocity}');
  //   super.onHorizontalDragEnd(info);
  // }

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

  // @override
  // void onTapDown(TapDownEvent event) {
  //   super.onTapDown(event);
  //   if(!event.handled) {
  //     final touchPoint = event.localPosition;
  //     add(PenComponent(touchPoint));
  //   }
  // }

  Vector2 _getDefaultPlayerPosition(
    PlayerType playerType,
    int player,
    BaseFormation formation,
  ) {
    switch (formation) {
      case BaseFormation.horizontalStack:
        switch (playerType) {
          case PlayerType.disc:
            return Vector2(
              width / 2 - playerRadius,
              height * 3 / 4 + discRadius * 2,
            );
          case PlayerType.defence:
            switch (player) {
              case 0:
              case 2:
                return Vector2(
                  (player + 1) / 4 * width,
                  height * 3 / 4 - 2.5 * playerRadius,
                );
              //break;
              case 1:
                return Vector2(
                  (player + 1) / 4 * width + playerRadius * 2,
                  height * 3 / 4 - 2.5 * playerRadius,
                );
              //break;
              case 3:
                return Vector2(
                  (player - 2) / 6 * width,
                  height / 2 - 2 * playerRadius,
                );
              //break;
              case 4:
                return Vector2(
                  (player - 2) / 6 * width,
                  height / 2 + 2 * playerRadius,
                );
              //break;
              case 5:
                return Vector2(
                  (player - 2) / 6 * width,
                  height / 2 - 2 * playerRadius,
                );
              //break;

              case 6:
                return Vector2(
                  (player - 2) / 6 * width,
                  height / 2 + 3 * playerRadius,
                );
              //break;
            }

          case PlayerType.offence:
            if (player <= 2) {
              return Vector2((player + 1) / 4 * width, height * 3 / 4);
            } else {
              return Vector2((player - 2) / 6 * width, height / 2);
            }
        }

      case BaseFormation.verticalStack:
        if (playerType == PlayerType.defence) {
          switch (player) {
            case 0:
            case 2:
              return Vector2(
                (player + 1) / 4 * width,
                height * 3 / 4 - 2.5 * playerRadius,
              );
            //break;
            case 1:
              return Vector2(
                (player + 1) / 4 * width + playerRadius * 2,
                height * 3 / 4 - 2.5 * playerRadius,
              );
            //break;
            case 3:
              return Vector2(width / 2, height / 3 - (2.5 * playerRadius));
            //break;
            case 4:
              return Vector2(
                width / 2 - 2 * playerRadius,
                height / 3 + player * (3 * playerRadius),
              );
            //break;
            case 5:
              return Vector2(width / 2 - 2.5 * playerRadius, height / 2);
            //break;

            case 6:
              return Vector2(width / 2 + 2.5 * playerRadius, height / 2);
            //break;
          }
        } else if (playerType == PlayerType.offence) {
          if (player <= 2) {
            return Vector2((player + 1) / 4 * width, height * 3 / 4);
          } else {
            return Vector2(
              width / 2,
              height / 3 + (player - 3) * (3 * playerRadius),
            );
          }
        } else {
          //disc
          return Vector2(
            width / 2 - playerRadius,
            height * 3 / 4 + discRadius * 2,
          );
        }
    }
    //should never get here
    return Vector2(width/2, height/2);
  }

  void _resetToFormation(BaseFormation formation) {
    final offensivePlayers = world.children.where( (c) => c is PlayerSprite && c.playerType == PlayerType.offence ).toList();

    final defensivePlayers = world.children.where( (c) => c is PlayerSprite && c.playerType == PlayerType.defence ).toList();

    final disc = world.children.firstWhere( (c) => c is PlayerSprite && c.playerType == PlayerType.disc ) as PlayerSprite; 

    disc.moveTo(_getDefaultPlayerPosition(PlayerType.disc, 0, formation) );

    for (int player = 0; player < offensivePlayers.length; player++) {
      final oPlayer = offensivePlayers[player] as PlayerSprite;
      oPlayer.moveTo(_getDefaultPlayerPosition(PlayerType.offence, player, formation));
      final dPlayer = defensivePlayers[player] as PlayerSprite;
      dPlayer.moveTo(_getDefaultPlayerPosition(PlayerType.defence, player, formation));
    }  

  }
}
