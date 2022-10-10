import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../block_breaker.dart';

class MyTextButton extends TextBoxComponent
    with TapCallbacks, HasGameRef<BlockBreaker> {
  MyTextButton(String text)
      : super(
          text: text,
        );

  @override
  Future<void> onLoad() {
    size
      ..x = kButtonWidth
      ..y = kButtonHeight;

    position
      ..x = gameRef.size.x / 2 - size.x / 2 * kButtonPositionXAdjustRatio
      ..y = gameRef.size.y / 2 - size.y / 2;

    align = Anchor.center;

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef
      ..resetBall()
      ..paused = false;
    removeFromParent();
    super.onTapDown(event);
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(
      0,
      0,
      size.x,
      size.y,
    );
    final bgPaint = Paint()..color = Colors.blue;
    canvas.drawRect(rect, bgPaint);
    super.render(canvas);
  }
}
