import 'package:flutter/material.dart';

class GradientBackground extends BoxDecoration {
  const GradientBackground()
      : super(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9370DB),
              Color(0xFF1E213A),
            ],
            stops: [0.65, 1.0],
          ),
        );
}
