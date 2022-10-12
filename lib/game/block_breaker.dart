import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:block_breaker/game/component/my_text_button.dart';
import 'package:block_breaker/game/component/paddle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'component/ball.dart';
import 'component/block.dart';
import 'component/countdown_text.dart';

class BlockBreaker extends FlameGame
    with HasCollisionDetection, HasDraggableComponents, HasTappableComponents {
  int failedCount = kGameTryCount;
  bool uncontrolledFailure = false;

  bool get isCleared => children.whereType<Block>().isEmpty;

  bool get isGameOver => failedCount == 0;

  double get spawnAngle {
    final random = Random().nextDouble();
    final spawnAngle =
        lerpDouble(kBallMinSpawnAngle, kBallMaxSpawnAngle, random)!;
    return spawnAngle;
  }

  @override
  Future<void> onLoad() async {
    final paddle = Paddle(draggingPaddleCallback: draggingPaddle);
    final paddleSize = paddle.size;
    paddle
      ..position.x = size.x / 2 - paddleSize.x / 2
      ..position.y = size.y - paddleSize.y - kPaddleStartY;

    await addMyTextButton('Start!');

    await addAll(
      [
        ScreenHitbox(),
        paddle,
      ],
    );
    await resetBlocks();
  }

  Future<void> resetBall() async {
    for (var i = kCountdownDuration; i > 0; i--) {
      final countdownText = CountdownText(count: i);

      countdownText.position
        ..x = size.x / 2 - countdownText.size.x / 2
        ..y = size.y / 2 - countdownText.size.y / 2;

      await add(countdownText);

      await Future<void>.delayed(const Duration(seconds: 1));
    }

    final ball = Ball(
      updateBall: updateBall,
      collisionBallScreenHitBox: collisionBallScreenHitBox,
      onBallRemove: onBallRemove,
    );

    ball.position
      ..x = size.x / 2 - ball.size.x / 2
      ..y = size.y * kBallStartYRatio;

    final vx = kBallSpeed * cos(spawnAngle * kDegree);
    final vy = kBallSpeed * sin(spawnAngle * kDegree);

    ball.velocity = Vector2(
      vx,
      vy,
    );

    await add(ball);
  }

  Future<void> resetBlocks() async {

    children.whereType<Block>().forEach((block) {
      block.removeFromParent();
    });

    failedCount = kGameTryCount;
    final blocks =
        List<Block>.generate(kBlocksColumnCount * kBlocksRowCount, (int index) {
      final sizeX = (size.x -
              kBlocksStartXPosition * 2 -
              kBlockPadding * (kBlocksRowCount - 1)) /
          kBlocksRowCount;

      final sizeY = (size.y * kBlocksHeightRatio -
              kBlocksStartYPosition -
              kBlockPadding * (kBlocksColumnCount - 1)) /
          kBlocksRowCount;

      final block = Block(
        blockSize: Vector2(sizeX, sizeY),
        onBlockRemove: onBlockRemove,
      );

      final indexX = index % kBlocksRowCount;
      final indexY = index ~/ kBlocksRowCount;

      final blockPositionIndex = {
        kBlockPositionX: indexX,
        kBlockPositionY: indexY,
      };

      block.position
        ..x = kBlocksStartXPosition +
            blockPositionIndex[kBlockPositionX]! *
                (block.size.x + kBlockPadding)
        ..y = kBlocksStartYPosition +
            blockPositionIndex[kBlockPositionY]! *
                (block.size.y + kBlockPadding);

      return block;
    });

    await addAll(blocks);
  }

  Future<void> failed({required bool uncontrolledFailure}) async {
    if (!uncontrolledFailure) {
      failedCount--;
    }
    if (isGameOver) {
      await addMyTextButton('Game Over!');
    } else {
      await addMyTextButton('Retry');
    }
  }

  Future<void> onBlockRemove() async {
    if (isCleared) {
      await addMyTextButton('Clear!');
      children.whereType<Ball>().forEach((ball) {
        ball.removeFromParent();
      });
    }
  }

  void draggingPaddle(DragUpdateEvent event) {
    final paddle = children.whereType<Paddle>().first;
    if (paddle.position.x >= 0 && paddle.position.x <= size.x - paddle.size.x) {
      paddle.position.x += event.delta.x;
    }
    if (paddle.position.x < 0) {
      paddle.position.x = 0;
    }
    if (paddle.position.x > size.x - paddle.size.x) {
      paddle.position.x = size.x - paddle.size.x;
    }
  }

  void updateBall(double dt) {
    final ball = children.whereType<Ball>().first;
    ball.position += ball.velocity * dt;

    if (ball.position.y < -kBallUncontrolledPositionY) {
      uncontrolledFailure = true;
      ball.removeFromParent();
    }

    if (ball.position.y > size.y + kBallUncontrolledPositionY) {
      ball.removeFromParent();
    }
  }

  void collisionBallScreenHitBox(Vector2 collisionPoint) {
    final ball = children.whereType<Ball>().first;
    if (collisionPoint.x <= 0 || collisionPoint.x >= size.x) {
      ball.velocity.x = -ball.velocity.x;
    }
    if (collisionPoint.y <= 0) {
      ball.velocity.y = -ball.velocity.y;
    }

    if (collisionPoint.y >= size.y) {
      ball.removeFromParent();
    }
  }

  Future<void> onBallRemove() async {
    if (!isCleared) {
      await failed(uncontrolledFailure: uncontrolledFailure);
      uncontrolledFailure = false;
    }
  }

  Future<void> onTapDownMyTextButton() async {
    children.whereType<MyTextButton>().forEach((button) {
      button.removeFromParent();
    });

    if (isCleared || isGameOver) {
      await resetBlocks();
      failedCount = kGameTryCount;
    }
    await resetBall();
  }

  void renderMyTextButton(Canvas canvas) {
    final myTextButton = children.whereType<MyTextButton>().first;
    final rect = Rect.fromLTWH(
      0,
      0,
      myTextButton.size.x,
      myTextButton.size.y,
    );
    final bgPaint = Paint()..color = isGameOver ? Colors.red : Colors.blue;
    canvas.drawRect(rect, bgPaint);
  }

  Future<void> addMyTextButton(String text) async {
    final myTextButton = MyTextButton(
      text,
      onTapDownMyTextButton: onTapDownMyTextButton,
      renderMyTextButton: renderMyTextButton,
    );

    myTextButton.position
      ..x = size.x / 2 - myTextButton.size.x / 2
      ..y = size.y / 2 - myTextButton.size.y / 2;

    await add(myTextButton);
  }
}
