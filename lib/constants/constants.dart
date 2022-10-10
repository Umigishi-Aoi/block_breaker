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

//Start Button Settings
const String kStartButton = 'StartButton';
const double kStartButtonWidth = 200;
const double kStartButtonHeight = 50;

//Countdown Settings
const double kCountdownSize = 200;
const TextStyle kCountdownTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 200,
);
const double kCountDownPositionXRatio = 0.7;
const int kCountdownDuration = 3;
