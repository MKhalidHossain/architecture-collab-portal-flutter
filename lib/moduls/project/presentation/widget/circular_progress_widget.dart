import 'package:flutter/material.dart';

class CircularProgressPercent extends StatelessWidget {
  final double percent; // 0.0 ~ 1.0
  final double size;
  final Color progressColor;
  final Color backgroundColor;

  const CircularProgressPercent({
    super.key,
    required this.percent,
    this.size = 110,
    this.progressColor = Colors.teal,
    this.backgroundColor = const Color(0x26FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background full circle (light)
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              backgroundColor: backgroundColor,
              valueColor: const AlwaysStoppedAnimation(Colors.transparent),
            ),
          ),

          // Progress arc with nice rounded end
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),

          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Complete",
                style: TextStyle(
                  color: Colors.white ,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${(percent * 100).toInt()}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Usage example
// ──────────────────────────────────────────────────────────────

class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressPercent(
          percent: 0.5,
          size: 120,
          progressColor: Colors.teal.shade400,
          backgroundColor: Colors.white.withOpacity(0.12),
        ),
      ),
    );
  }
}