import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../block_breaker.dart';
import 'paddle.dart';

class Ball extends CircleComponent
    with HasGameRef<BlockBreaker>, CollisionCallbacks {
  Ball() {
    paint = Paint()..color = Colors.white;
    radius = kBallRadius;
  }

  late Vector2 velocity;

  @override
  Future<void>? onLoad() {
    _resetBall();

    final hitBox = CircleHitbox(radius: radius);

    add(hitBox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += velocity * dt;

    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    final collisionPoint = intersectionPoints.first;
    if (other is ScreenHitbox) {
      if (collisionPoint.x <= 0 || collisionPoint.x >= gameRef.size.x) {
        velocity.x = -velocity.x;
      }
      if (collisionPoint.y <= 0) {
        velocity.y = -velocity.y;
      }

      if (collisionPoint.y >= gameRef.size.y) {
        gameRef.failed();
      }
    }

    if (other is Paddle) {
      final paddleRect = other.paddle.toAbsoluteRect();

      updateBallTrajectory(collisionPoint, paddleRect);
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  void _resetBall() {
    size = Vector2.all(kBallRadius);
    position
      ..x = gameRef.size.x / 2 - size.x / 2
      ..y = gameRef.size.y * kBallStartYRatio;

    final vx = kBallSpeed * cos(spawnAngle * degree);
    final vy = kBallSpeed * sin(spawnAngle * degree);

    velocity = Vector2(
      vx,
      vy,
    );
  }

  double get spawnAngle {
    final random = Random().nextDouble();
    final spawnAngle =
        lerpDouble(kBallMinSpawnAngle, kBallMaxSpawnAngle, random)!;
    return spawnAngle;
  }

  void updateBallTrajectory(
    Vector2 collisionPoint,
    Rect paddleRect,
  ) {
    final isLeftHit = collisionPoint.x == paddleRect.left;
    final isRightHit = collisionPoint.x == paddleRect.right;
    final isTopHit = collisionPoint.y == paddleRect.top;
    final isBottomHit = collisionPoint.y == paddleRect.bottom;

    final isLeftOrRightHit = isLeftHit || isRightHit;
    final isTopOrBottomHit = isTopHit || isBottomHit;

    if (isLeftOrRightHit) {
      velocity.x = -velocity.x;
    }

    if (isTopOrBottomHit) {
      velocity.y = -velocity.y;
      if (Random().nextInt(kBallRandomRatio) % kBallRandomRatio == 0) {
        velocity.x += kBallNudgeSpeed;
      }
    }
  }
}
