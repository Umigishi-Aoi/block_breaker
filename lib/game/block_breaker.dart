import 'dart:async';

import 'package:block_breaker/game/component/my_text_button.dart';
import 'package:block_breaker/game/component/paddle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

import '../constants/constants.dart';
import 'component/ball.dart';
import 'component/countdown_text.dart';

class BlockBreaker extends FlameGame
    with HasCollisionDetection, HasDraggableComponents, HasTappableComponents {
  @override
  Future<void> onLoad() async {
    await addAll(
      [
        ScreenHitbox(),
        Paddle(),
        MyTextButton('Start'),
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

  int failedCount = kGameTryCount;

  Future<void> failed() async {
    failedCount--;
    if (failedCount == 0) {
      failedCount = kGameTryCount;
      await add(MyTextButton('Game Over', isGameOver: true));
    } else {
      await add(MyTextButton('Retry'));
    }
  }
}
