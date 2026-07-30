import 'package:flutter/material.dart';

class GiftAnimationOverlay extends StatelessWidget {
  final String sender;
  final String amount;
  final VoidCallback onDismiss;

  const GiftAnimationOverlay({
    super.key,
    required this.sender,
    required this.amount,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.2),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  size: 110,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'SUPER TIP SENT! ⚡',
                style: TextStyle(
                  color: Colors.amber[400],
                  fontSize: 22,
                  fontWeight: FontWeight.black,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$sender tipped \$$amount!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tap anywhere to dismiss',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
