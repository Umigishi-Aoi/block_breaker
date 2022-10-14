import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../../constants/constants.dart';

class Paddle extends RectangleComponent with CollisionCallbacks, DragCallbacks {
  Paddle({required this.draggingPaddleCallback})
      : super(
          size: Vector2(kPaddleWidth, kPaddleHeight),
          paint: Paint()..color = kPaddleColor,
        );

  final void Function(DragUpdateEvent event) draggingPaddleCallback;

  bool isDragged = false;

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
