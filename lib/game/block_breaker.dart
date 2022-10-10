import 'dart:async';

import 'package:block_breaker/game/component/paddle.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import '../constants/constants.dart';
import 'component/ball.dart';
import 'component/countdown_text.dart';

class BlockBreaker extends FlameGame
    with HasCollisionDetection, HasDraggableComponents, TapDetector {
  @override
  Future<void> onLoad() async {
    await addAll(
      [
        Paddle(),
      ],
    );
  }

  Future<void> resetBall() async {
    for (var i = kCountdownDuration; i > 0; i--) {
      await add(
        CountdownText(
          count: i,
        ),
      );
      await Future<void>.delayed(const Duration(seconds: 1));
    }

    await add(Ball());
  }
}
