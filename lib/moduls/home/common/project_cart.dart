import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_details.dart';
import 'package:flutter/material.dart';
import '../model/project_cart_model.dart';

const Color _accentColor = Color(0xFF0C7C84);
const double _stepSize = 34;

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  ImageProvider _resolveImage(String source) {
    final value = source.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return NetworkImage(value);
    }
    if (value.isNotEmpty) {
      return AssetImage(value);
    }
    return const AssetImage('assets/image/aa.png');
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    final day = date.day.toString().padLeft(2, '0');
    return '$month $day, ${date.year}';
  }

  Widget _milestoneText(int current, int total) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: '$current',
            style: const TextStyle(color: _accentColor),
          ),
          TextSpan(
            text: ' / $total',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _formatStatusLabel(String status) {
    final trimmed = status.trim();
    if (trimmed.isEmpty) {
      return 'Active';
    }
    if (trimmed.length == 1) {
      return trimmed.toUpperCase();
    }
    return '${trimmed[0].toUpperCase()}${trimmed.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final statusLabel = _formatStatusLabel(project.status);

    return SizedBox(
      height: 560,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3F3F3F).withOpacity(0.55),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image(
                        image: _resolveImage(project.image),
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/image/aa.png',
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: project.isActive
                              ? _accentColor
                              : Colors.white70,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            color:
                                project.isActive ? Colors.white : Colors.black87,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Progress Stepper
                Row(
                  children: List.generate(project.steps.length * 2 - 1, (i) {
                    if (i.isOdd) {
                      return _buildLine(
                        active: project.steps[i ~/ 2].completed,
                      );
                    } else {
                      final step = project.steps[i ~/ 2];
                      return _ProgressCircle(
                        active: step.completed,
                        size: _stepSize,
                      );
                    }
                  }),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: project.steps
                      .map(
                        (step) => SizedBox(
                          width: _stepSize,
                          child: Text(
                            step.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: step.completed
                                  ? _accentColor
                                  : Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 20),

                /// Title
                Text(
                  project.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (project.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    project.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                /// Info Row
                Row(
                  children: [
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      title: 'Deadline',
                      value: _formatDate(project.deadline),
                    ),
                    const Spacer(),
                    _InfoRow(
                      title: 'Milestone',
                      valueWidget: _milestoneText(
                        project.currentMilestone,
                        project.totalMilestones,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Team
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Team Members',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Row(
                      children: project.teamAvatars
                          .take(3)
                          .map(
                            (avatar) => Align(
                              widthFactor: 0.6,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage: _resolveImage(avatar),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Button
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProjectDetailScreen(projectId: project.id),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: _accentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLine({required bool active}) {
    return Expanded(
      child: Container(
        height: 2.5,
        color: active ? _accentColor : Colors.white38,
      ),
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  final bool active;
  final double size;

  const _ProgressCircle({
    required this.active,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? _accentColor : Colors.white24,
        border: Border.all(
          color: active ? _accentColor : Colors.white38,
          width: 2.5,
        ),
      ),
      child: Center(
        child: active
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? value;
  final Widget? valueWidget;

  const _InfoRow({
    this.icon,
    required this.title,
    this.value,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Icon(icon, color: _accentColor, size: 22),
        if (icon != null) const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            valueWidget ??
                Text(
                  value ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ],
        ),
      ],
    );
  }
}
