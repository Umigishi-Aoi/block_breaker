import 'package:block_breaker/constants/constants.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/block_breaker.dart';
import 'widget/start_button.dart';

void main() {
  final game = BlockBreaker();
  runApp(
    GameWidget(
      game: game..paused = true,
      overlayBuilderMap: {
        kStartButton: (_, __) => StartButton(
              game: game,
            ),
      },
      initialActiveOverlays: const [kStartButton],
    ),
  );
}
