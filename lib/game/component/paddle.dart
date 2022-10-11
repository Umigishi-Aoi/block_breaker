import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class Paddle extends PositionComponent with CollisionCallbacks, DragCallbacks {
  Paddle({required this.draggingPaddleCallback}) {
    size = Vector2(kPaddleWidth, kPaddleHeight);
  }

  late final RectangleComponent paddle;
  late final RectangleHitbox paddleHitBox;

  final void Function(DragUpdateEvent event) draggingPaddleCallback;

  @override
  Future<void>? onLoad() {
    paddle = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.blue,
    );

    paddleHitBox = RectangleHitbox(
      size: size,
    );

    addAll([
      paddle,
      paddleHitBox,
    ]);

    return super.onLoad();
  }

  bool isDragged = false;

  @override
  void onDragStart(DragStartEvent event) {
    isDragged = true;
    super.onDragStart(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    isDragged = false;
    super.onDragEnd(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isDragged) {
      draggingPaddleCallback(event);
    }
    super.onDragUpdate(event);
  }
}
