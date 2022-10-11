import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'block.dart' as b;
import 'paddle.dart';

class Ball extends CircleComponent with CollisionCallbacks {
  Ball({
    required this.updateBall,
    required this.collisionBallScreenHitBox,
    required this.onBallRemove,
  }) {
    radius = kBallRadius;
    size = Vector2.all(kBallRadius);
    paint = Paint()..color = Colors.white;
  }
  late Vector2 velocity;

  final void Function(double dt) updateBall;
  final void Function(Vector2 collisionPoint) collisionBallScreenHitBox;
  final Future<void> Function() onBallRemove;

  @override
  Future<void>? onLoad() async {
    final hitBox = CircleHitbox(radius: radius);

    await add(hitBox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    updateBall(dt);

    super.update(dt);
  }

  @override
  Future<void> onRemove() async {
    await onBallRemove();
    super.onRemove();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    final collisionPoint = intersectionPoints.first;
    if (other is ScreenHitbox) {
      collisionBallScreenHitBox(collisionPoint);
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

  void updateBallTrajectory(
    Vector2 collisionPoint,
    Rect rect,
  ) {
    final isLeftHit = collisionPoint.x == rect.left;
    final isRightHit = collisionPoint.x == rect.right;
    final isTopHit = collisionPoint.y == rect.top;
    final isBottomHit = collisionPoint.y == rect.bottom;

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
      if (Random().nextInt(kBallRandomNumber) % kBallRandomNumber == 0) {
        velocity.x += kBallNudgeSpeed;
      }
    }
  }
}
