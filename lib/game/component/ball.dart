import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../block_breaker.dart';
import 'block.dart' as b;
import 'paddle.dart';

class Ball extends CircleComponent
    with HasGameRef<BlockBreaker>, CollisionCallbacks {
  late Vector2 velocity;

  @override
  Future<void>? onLoad() {
    paint = Paint()..color = Colors.white;
    radius = kBallRadius;

    _resetBall();

    final hitBox = CircleHitbox(radius: radius);

    add(hitBox);

    return super.onLoad();
  }

  bool uncontrolledFailure = false;

  @override
  void update(double dt) {
    position += velocity * dt;

    if (position.y < -kBallUncontrolledPositionY) {
      uncontrolledFailure = true;
      removeFromParent();
    }

    if (position.y > gameRef.size.y + kBallUncontrolledPositionY) {
      removeFromParent();
    }

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
        removeFromParent();
      }
    }

    if (other is b.Block) {
      final blockRect = other.block.toAbsoluteRect();

      updateBallTrajectory(collisionPoint, blockRect);
    }

    if (other is Paddle) {
      final paddleRect = other.paddle.toAbsoluteRect();

      updateBallTrajectory(collisionPoint, paddleRect);
    }

    FlameAudio.play('20221011_ball_hit.wav');

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
      if (isRightHit && velocity.x > 0) {
        velocity.x += kBallNudgeSpeed;
        return;
      }

      if (isLeftHit && velocity.x < 0) {
        velocity.x -= kBallNudgeSpeed;
        return;
      }

      velocity.x = -velocity.x;
      return;
    }

    if (isTopOrBottomHit) {
      velocity.y = -velocity.y;
      if (Random().nextInt(kBallRandomRatio) % kBallRandomRatio == 0) {
        velocity.x += kBallNudgeSpeed;
      }
    }
  }

  @override
  Future<void> onRemove() async {
    if (!gameRef.isCleared) {
      await gameRef.failed(uncontrolledFailure: uncontrolledFailure);
      uncontrolledFailure = false;
    }
    super.onRemove();
  }
}
