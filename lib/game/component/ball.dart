import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../block_breaker.dart';

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
}
