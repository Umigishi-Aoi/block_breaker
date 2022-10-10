import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../block_breaker.dart';

class CountdownText extends TextComponent with HasGameRef<BlockBreaker> {
  CountdownText({
    required this.count,
  });

  @override
  Future<void>? onLoad() {
    size = Vector2.all(kCountdownSize);
    position
      ..x = gameRef.size.x / 2 - size.x / 2 * kCountDownPositionXRatio
      ..y = gameRef.size.y / 2 - size.y / 2;
    textRenderer = TextPaint(
      style: kCountdownTextStyle,
    );
    text = '$count';
    return super.onLoad();
  }

  final int count;

  @override
  Future<void> render(Canvas canvas) async {
    super.render(canvas);
    await Future<void>.delayed(const Duration(seconds: 1));
    removeFromParent();
  }
}
