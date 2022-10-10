import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../block_breaker.dart';

class Paddle extends PositionComponent
    with HasGameRef<BlockBreaker>, CollisionCallbacks {
  late final RectangleComponent paddle;
  late final RectangleHitbox paddleHitBox;

  @override
  Future<void>? onLoad() {
    final worldRect = gameRef.size.toRect();

    size = Vector2(PADDLE_WIDTH, PADDLE_HEIGHT);
    position
      ..x = worldRect.center.dx - size.x / 2
      ..y = worldRect.height - size.y - PADDLE_START_Y;

    paddle = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.blue,
    );

    paddleHitBox = RectangleHitbox(
      size: size,
    );

    addAll([
      paddle,
      paddleHitBox,
    ]);

    return super.onLoad();
  }
}
