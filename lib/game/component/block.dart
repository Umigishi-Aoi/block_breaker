import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../block_breaker.dart';
import 'ball.dart';

class Block extends PositionComponent
    with HasGameRef<BlockBreaker>, CollisionCallbacks {
  Block({required this.blockPosition});

  late final RectangleComponent block;
  late final RectangleHitbox blockHitBox;

  final Map<String, int> blockPosition;

  @override
  Future<void>? onLoad() {
    size
      ..x = (gameRef.size.x -
              kBlocksStartXPosition * 2 -
              kBlockPadding * (kBlocksRowCount - 1)) /
          kBlocksRowCount
      ..y = (gameRef.size.y * kBlocksHeightRatio -
              kBlocksStartYPosition -
              kBlockPadding * (kBlocksColumnCount - 1)) /
          kBlocksRowCount;

    position
      ..x = kBlocksStartXPosition +
          blockPosition[kBlockPositionX]! * (size.x + kBlockPadding)
      ..y = kBlocksStartYPosition +
          blockPosition[kBlockPositionY]! * (size.y + kBlockPadding);

    block = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = kBlockColors[Random().nextInt(kBlockColors.length)],
    );

    blockHitBox = RectangleHitbox(
      size: size,
    );

    addAll([
      block,
      blockHitBox,
    ]);

    return super.onLoad();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Ball) {
      gameRef.hit();
      removeFromParent();
    }

    super.onCollisionStart(intersectionPoints, other);
  }
}
