import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

import '../constants/constants.dart';
import 'component/ball.dart';
import 'component/block.dart';
import 'component/countdown_text.dart';
import 'component/my_text_button.dart';
import 'component/paddle.dart';

class BlockBreaker extends FlameGame
    with HasCollisionDetection, HasDraggableComponents, HasTappableComponents {
  int failedCount = kGameTryCount;

  bool get isCleared => children.whereType<Block>().isEmpty;

  bool get isGameOver => failedCount == 0;

  @override
  Future<void> onLoad() async {
    final paddle = Paddle(draggingPaddle: draggingPaddle);
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
    final ball = Ball(
      onBallRemove: onBallRemove,
    );

    ball.position
      ..x = size.x / 2 - ball.size.x / 2
      ..y = size.y * kBallStartYRatio;
    await add(ball);
  }

  Future<void> resetBlocks() async {
    children.whereType<Block>().forEach((block) {
      block.removeFromParent();
    });

    final sizeX = (size.x -
            kBlocksStartXPosition * 2 -
            kBlockPadding * (kBlocksRowCount - 1)) /
        kBlocksRowCount;

    final sizeY = (size.y * kBlocksHeightRatio -
            kBlocksStartYPosition -
            kBlockPadding * (kBlocksColumnCount - 1)) /
        kBlocksColumnCount;

    final blocks =
        List<Block>.generate(kBlocksColumnCount * kBlocksRowCount, (int index) {
      final block = Block(
        blockSize: Vector2(sizeX, sizeY),
        onBlockRemove: onBlockRemove,
      );

      final indexX = index % kBlocksRowCount;
      final indexY = index ~/ kBlocksRowCount;

      block.position
        ..x = kBlocksStartXPosition + indexX * (block.size.x + kBlockPadding)
        ..y = kBlocksStartYPosition + indexY * (block.size.y + kBlockPadding);

      return block;
    });

    await addAll(blocks);
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

  Future<void> onBallRemove() async {
    if (!isCleared) {
      failedCount--;
      if (isGameOver) {
        await addMyTextButton('Game Over!');
      } else {
        await addMyTextButton('Retry');
      }
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

    paddle.position.x += event.delta.x;

    if (paddle.position.x < 0) {
      paddle.position.x = 0;
    }
    if (paddle.position.x > size.x - paddle.size.x) {
      paddle.position.x = size.x - paddle.size.x;
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
    await countdown();
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
    final bgPaint = Paint()
      ..color = isGameOver ? kGameOverButtonColor : kButtonColor;
    canvas.drawRect(rect, bgPaint);
  }

  Future<void> countdown() async {
    for (var i = kCountdownDuration; i > 0; i--) {
      final countdownText = CountdownText(count: i);

      countdownText.position
        ..x = size.x / 2 - countdownText.size.x / 2
        ..y = size.y / 2 - countdownText.size.y / 2;

      await add(countdownText);

      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }
}
