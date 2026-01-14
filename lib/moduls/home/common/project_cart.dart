import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_details.dart';
import 'package:flutter/material.dart';
import '../model/project_cart_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: const Color(0xFF4A4A4A).withOpacity(0.45),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image(
                        image: _resolveImage(project.image),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/image/aa.png',
                          height: 180,
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
                          horizontal: 24,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              project.isActive ? Colors.teal : Colors.grey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          project.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
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
                        label: step.label,
                      );
                    }
                  }),
                ),

                const SizedBox(height: 24),

                /// Title
                Text(
                  project.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  project.subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                /// Info Row
                Row(
                  children: [
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      title: 'Deadline',
                      value:
                          '${project.deadline.day}/${project.deadline.month}/${project.deadline.year}',
                    ),
                    const Spacer(),
                    _InfoRow(
                      title: 'Milestone',
                      value:
                          '${project.currentMilestone} / ${project.totalMilestones}',
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
                          TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    Row(
                      children: List.generate(project.teamAvatars.length,
                          (index) {
                        return Align(
                          widthFactor: 0.6,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 19,
                              backgroundImage:
                                  _resolveImage(project.teamAvatars[index]),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Button
                InkWell(
                  borderRadius: BorderRadius.circular(16),
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
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: Colors.white,
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
        height: 3,
        color: active ? Colors.teal : Colors.white38,
      ),
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  final bool active;
  final String label;

  const _ProgressCircle({
    required this.active,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.teal : Colors.white24,
        border: Border.all(
          color: active ? Colors.teal : Colors.white38,
          width: 3,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String value;

  const _InfoRow({
    this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Icon(icon, color: Colors.tealAccent, size: 22),
        if (icon != null) const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Text(
              value,
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