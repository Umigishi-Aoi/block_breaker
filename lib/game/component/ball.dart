import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../constants/constants.dart';
import 'block.dart' as b;
import 'paddle.dart';

class Ball extends CircleComponent with CollisionCallbacks {
  Ball({
    required this.onBallRemove,
  }) {
    radius = kBallRadius;
    paint = Paint()..color = kBallColor;
    final vx = kBallSpeed * cos(spawnAngle * kRad);
    final vy = kBallSpeed * sin(spawnAngle * kRad);
    velocity = Vector2(vx, vy);
  }
  late Vector2 velocity;

  bool isCollidedScreenHitboxX = false;
  bool isCollidedScreenHitboxY = false;

  final Future<void> Function() onBallRemove;

  double get spawnAngle {
    final random = Random().nextDouble();
    final spawnAngle =
        lerpDouble(kBallMinSpawnAngle, kBallMaxSpawnAngle, random)!;
    return spawnAngle;
  }

  @override
  Future<void>? onLoad() async {
    final hitbox = CircleHitbox(radius: radius);

    await add(hitbox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += velocity * dt;
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
    if (other is b.Block) {
      final blockRect = other.toAbsoluteRect();

      updateBallTrajectory(collisionPoint, blockRect);
    }

    if (other is Paddle) {
      final paddleRect = other.toAbsoluteRect();

      updateBallTrajectory(collisionPoint, paddleRect);
    }

    FlameAudio.play('20221011_ball_hit.wav');

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ScreenHitbox) {
      final screenHitBoxRect = other.toAbsoluteRect();

      for (final point in intersectionPoints) {
        if (point.x == screenHitBoxRect.left && !isCollidedScreenHitboxX) {
          velocity.x = -velocity.x;
          isCollidedScreenHitboxX = true;
        }
        if (point.x == screenHitBoxRect.right && !isCollidedScreenHitboxX) {
          velocity.x = -velocity.x;
          isCollidedScreenHitboxX = true;
        }
        if (point.y == screenHitBoxRect.top && !isCollidedScreenHitboxY) {
          velocity.y = -velocity.y;
          isCollidedScreenHitboxY = true;
        }
        if (point.y == screenHitBoxRect.bottom && !isCollidedScreenHitboxY) {
          removeFromParent();
        }
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    isCollidedScreenHitboxX = false;
    isCollidedScreenHitboxY = false;
    super.onCollisionEnd(other);
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
