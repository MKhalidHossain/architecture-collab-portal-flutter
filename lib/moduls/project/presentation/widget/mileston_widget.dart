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
      children: List.generate(milestones.length, (index) {
        final milestone = milestones[index];
        final isLast = index == milestones.length - 1;
        final isDone = milestone.isCompleted;
        final isActive = index == activeIndex && !isDone;
        final title = milestone.name.trim().isNotEmpty
            ? milestone.name.trim()
            : 'Milestone';
        final chips = _buildChips(milestone, isDone, isActive);
        final lineColor = isDone ? const Color(0xFF0C7A7E) : Colors.white24;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 56,
                child: Column(
                  children: [
                    _timelineDot(isDone: isDone, isActive: isActive),
                    if (!isLast)
                      Container(
                        width: 4,
                        height: 50,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: lineColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(spacing: 10, runSpacing: 8, children: chips),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _timelineDot({required bool isDone, required bool isActive}) {
    if (isDone) {
      return Container(
        height: 44,
        width: 44,
        decoration: const BoxDecoration(
          color: Color(0xFF0C7A7E),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.verified_rounded,
          color: Colors.white,
          size: 22,
        ),
      );
    }

    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? const Color(0xFF0C7A7E) : Colors.white70,
          width: 2,
        ),
      ),
      child: isActive
          ? const Center(
              child: CircleAvatar(
                radius: 4,
                backgroundColor: Color(0xFF0C7A7E),
              ),
            )
          : null,
    );
  }

  List<Widget> _buildChips(
    ProjectMilestone milestone,
    bool isDone,
    bool isActive,
  ) {
    if (isDone) {
      return [
        _statusChip(
          label: 'View Documents',
          backgroundColor: const Color(0xFF0C7A7E),
          textColor: Colors.white,
        ),
        _statusChip(
          label: 'Completed',
          backgroundColor: Colors.white.withOpacity(0.85),
          textColor: const Color(0xFF2B2B2B),
        ),
      ];
    }
    if (isActive) {
      return [
        _statusChip(
          label: 'Active',
          backgroundColor: const Color(0xFF0C7A7E),
          textColor: Colors.white,
        ),
      ];
    }
    final statusText = _statusText(milestone);
    return [
      _statusChip(
        label: statusText,
        backgroundColor: const Color(0xFFFFF1D6),
        textColor: const Color(0xFF0C7A7E),
      ),
    ];
  }

  Widget _statusChip({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _statusText(ProjectMilestone milestone) {
    final trimmed = milestone.status.trim();
    if (trimmed.isNotEmpty) {
      final normalized = trimmed.toLowerCase();
      if (normalized == 'pending') {
        return 'In progress';
      }
      return trimmed;
    }
    if (milestone.progress > 0) {
      return 'In progress';
    }
    return 'Pending';
  }

  int _activeMilestoneIndex(List<ProjectMilestone> milestones) {
    for (var i = 0; i < milestones.length; i++) {
      if (!milestones[i].isCompleted) {
        return i;
      }
    }
    return milestones.length - 1;
  }
}
