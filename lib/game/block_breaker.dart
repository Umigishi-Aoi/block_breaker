import 'package:block_breaker/game/component/paddle.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

class BlockBreaker extends FlameGame
    with HasCollisionDetection, HasDraggableComponents {
  @override
  Future<void> onLoad() async {
    await addAll(
      [
        Paddle(),
      ],
    );
  }
}
