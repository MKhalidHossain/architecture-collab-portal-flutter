import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import 'package:flutter/material.dart';

class MilestonesTab extends StatelessWidget {
  final List<ProjectMilestone> milestones;

  const MilestonesTab({super.key, required this.milestones});

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) {
      return const Center(
        child: Text(
          "No milestones available.",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final activeIndex = _activeMilestoneIndex(milestones);

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
              final milestone = milestones[index];
              final isLast = index == milestones.length - 1;
              final isDone = milestone.isCompleted;
              final isActive = index == activeIndex && !isDone;
              final title = milestone.name.trim().isNotEmpty
                  ? milestone.name.trim()
                  : 'Milestone';
              final statusLabel = _statusLabel(milestone, isActive);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      _timelineDot(isDone: isDone, isActive: isActive),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 42,
                          color: Colors.white.withOpacity(0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.75),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _statusChip(statusLabel, isActive, isDone),
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
  Widget _statusChip(String text, bool isActive, bool isDone) {
    Color bg;
    Color fg;

    if (isDone || text.toLowerCase().contains('complete')) {
      bg = Colors.teal.withOpacity(0.2);
      fg = Colors.teal;
    } else if (isActive || text.toLowerCase().contains('active')) {
      bg = Colors.blue.withOpacity(0.2);
      fg = Colors.blueAccent;
    } else {
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

  String _statusLabel(ProjectMilestone milestone, bool isActive) {
    final trimmed = milestone.status.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
    if (milestone.isCompleted) {
      return "Completed";
    }
    return isActive ? "Active" : "Pending";
  }

  int _activeMilestoneIndex(List<ProjectMilestone> milestones) {
    for (var i = 0; i < milestones.length; i++) {
      if (!milestones[i].isCompleted) {
        return i;
      }
    }
    return milestones.length - 1;
  }

  /// Glass card
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}
