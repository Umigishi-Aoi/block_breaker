//Paddle Settings
import 'dart:math';

import 'package:flutter/material.dart';

const double kPaddleWidth = 100;
const double kPaddleHeight = 20;
//Start position from bottom.
const double kPaddleStartY = 50;

//Ball Settings
const double kBallRadius = 20;
const double kBallSpeed = 500;
const double kBallStartYRatio = 1 / 2;
const double kBallMinSpawnAngle = 45;
const double kBallMaxSpawnAngle = 135;
const int kBallRandomRatio = 5;
const double kBallNudgeSpeed = 300;

// Math Settings
const double degree = pi / 180;

//Button Settings
const double kButtonWidth = 200;
const double kButtonHeight = 50;
const double kButtonPositionXAdjustRatio = 1.1;

//Countdown Settings
const double kCountdownSize = 200;
const TextStyle kCountdownTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 200,
);
const double kCountDownPositionXRatio = 0.7;
const int kCountdownDuration = 3;

//kRestartButton Settings
const String kRestartButton = 'RestartButton';

//Game Settings
const int kGameTryCount = 3;
const int kBlocksColumnCount = 4;
const int kBlocksRowCount = 5;

//Block Settings
const double kBlocksStartYPosition = 50;
const double kBlocksStartXPosition = 50;
const double kBlocksHeightRatio = 1 / 3;
const List<MaterialColor> kBlockColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
];
const String kBlockPositionX = 'x';
const String kBlockPositionY = 'y';
const double kBlockPadding = 5;
