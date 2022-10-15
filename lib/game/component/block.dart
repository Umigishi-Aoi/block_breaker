import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../constants/constants.dart';
import 'ball.dart';

class Block extends RectangleComponent with CollisionCallbacks {
  Block({required this.blockSize, required this.onBlockRemove})
      : super(
          size: blockSize,
          paint: Paint()
            ..color = kBlockColors[Random().nextInt(kBlockColors.length)],
        );

  final Vector2 blockSize;
  final Future<void> Function() onBlockRemove;

  @override
  Future<void>? onLoad() async {
    final blockHitbox = RectangleHitbox(
      size: size,
    );

    await add(blockHitbox);

    return super.onLoad();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Ball) {
      removeFromParent();
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  Future<void> onRemove() async {
    await onBlockRemove();
    super.onRemove();
  }
}
