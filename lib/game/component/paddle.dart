import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../../constants/constants.dart';

class Paddle extends RectangleComponent with CollisionCallbacks, DragCallbacks {
  Paddle({required this.draggingPaddle})
      : super(
          size: Vector2(kPaddleWidth, kPaddleHeight),
          paint: Paint()..color = kPaddleColor,
        );

  final void Function(DragUpdateEvent event) draggingPaddle;

  bool isDragging = false;

  @override
  Future<void>? onLoad() {
    final paddleHitBox = RectangleHitbox(
      size: size,
    );

    add(paddleHitBox);

    return super.onLoad();
  }

  @override
  void onDragStart(DragStartEvent event) {
    isDragging = true;
    super.onDragStart(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    isDragging = false;
    super.onDragEnd(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isDragging) {
      draggingPaddle(event);
    }
    super.onDragUpdate(event);
  }
}
