import 'dart:ui';
import 'package:flutter/material.dart';

class MilestonesTab extends StatelessWidget {
  const MilestonesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final milestones = [
      {
        "title": "Pre-Design",
        "status": "Completed",
        "isActive": false,
        "isDone": true,
      },
      {
        "title": "Schematic Design",
        "status": "Active",
        "isActive": true,
        "isDone": false,
      },
      {
        "title": "Design Development",
        "status": "In progress",
        "isActive": false,
        "isDone": false,
      },
      {
        "title": "Construction Design",
        "status": "In progress",
        "isActive": false,
        "isDone": false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Project Milestones",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        _glassCard(
          child: Column(
            children: List.generate(milestones.length, (index) {
              final m = milestones[index];
              final isLast = index == milestones.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      _timelineDot(
                        isDone: m["isDone"] as bool,
                        isActive: m["isActive"] as bool,
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 42,
                          color: Colors.white.withOpacity(0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  /// Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m["title"] as String,
                            style: TextStyle(
                              color: m["isActive"] as bool
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.75),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _statusChip(m["status"] as String),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  /// Timeline dot
  Widget _timelineDot({required bool isDone, required bool isActive}) {
    if (isDone) {
      return Container(
        height: 28,
        width: 28,
        decoration: const BoxDecoration(
          color: Colors.teal,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      );
    }

    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? Colors.teal : Colors.white54,
          width: 2,
        ),
      ),
      child: isActive
          ? const Center(
              child: CircleAvatar(radius: 4, backgroundColor: Colors.teal),
            )
          : null,
    );
  }

  /// Status chip
  Widget _statusChip(String text) {
    Color bg;
    Color fg;

    switch (text) {
      case "Completed":
        bg = Colors.teal.withOpacity(0.2);
        fg = Colors.teal;
        break;
      case "Active":
        bg = Colors.blue.withOpacity(0.2);
        fg = Colors.blueAccent;
        break;
      default:
        bg = Colors.orange.withOpacity(0.2);
        fg = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Glass card
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        // decoration: BoxDecoration(
        //   color: Colors.white.withOpacity(0.18),
        //   borderRadius: BorderRadius.circular(24),
        //   border: Border.all(
        //     color: Colors.white.withOpacity(0.25),
        //   ),
        // ),
        child: child,
      ),
    );
  }
}
