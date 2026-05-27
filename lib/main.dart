

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_coaching_board/src/ultimate_board.dart';

void main() {
  final game = UltimateBoard();
  runApp(GameWidget(game: game));
}