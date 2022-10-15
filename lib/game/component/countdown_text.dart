import 'dart:ui';

import 'package:flame/components.dart';

import '../../constants/constants.dart';

class CountdownText extends TextComponent {
  CountdownText({
    required this.count,
  }) : super(
          size: Vector2.all(kCountdownSize),
          textRenderer: TextPaint(
            style: kCountdownTextStyle,
          ),
          text: '$count',
        );

  final int count;

  @override
  Future<void> render(Canvas canvas) async {
    super.render(canvas);
    await Future<void>.delayed(const Duration(seconds: 1));
    removeFromParent();
  }
}
