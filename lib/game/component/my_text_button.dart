import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../../constants/constants.dart';

class MyTextButton extends TextBoxComponent with TapCallbacks {
  MyTextButton(
    String text, {
    required this.onTapDownMyTextButton,
    required this.renderMyTextButton,
  }) : super(
          text: text,
          size: Vector2(kButtonWidth, kButtonHeight),
          align: Anchor.center,
        );

  final Future<void> Function() onTapDownMyTextButton;
  final void Function(Canvas canvas) renderMyTextButton;

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    await onTapDownMyTextButton();
    super.onTapDown(event);
  }

  @override
  void render(Canvas c) {
    renderMyTextButton(c);
    super.render(c);
  }
}
