import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/block_breaker.dart';

void main() {
  final game = BlockBreaker();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: GameWidget(
          game: game,
        ),
      ),
    ),
  );
}
