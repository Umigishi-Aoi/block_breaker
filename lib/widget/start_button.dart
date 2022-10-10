import 'package:block_breaker/constants/constants.dart';
import 'package:block_breaker/game/block_breaker.dart';
import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key, required this.game});

  final BlockBreaker game;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: kStartButtonWidth,
        height: kStartButtonHeight,
        child: ElevatedButton(
          onPressed: () {
            game.overlays.remove(kStartButton);
            game.resetBall();
            game.paused = false;
          },
          child: const Text('Start'),
        ),
      ),
    );
  }
}
