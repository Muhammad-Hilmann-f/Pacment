import 'package:flutter/material.dart';

class MotorcycleImageWidget extends StatelessWidget {
  const MotorcycleImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: Image.asset(
          'lib/assets/images/Motocycle.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.motorcycle,
                  size: 80,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}