import 'dart:ui';

import 'package:dana_bozzetto/moduls/project/model/project_details_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_base_Approval.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_based_documents.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_based_invoices.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/circular_progress_widget.dart';
import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  final ProjectDetailsModel project;
  final bool isTeamMember;

  const OverviewTab({
    super.key,
    required this.project,
    this.isTeamMember = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _progressCard(),
        const SizedBox(height: 16),
        _infoGrid(),
        const SizedBox(height: 16),
        _quickActions(),
        const SizedBox(height: 16),
        _recentActivity(),
      ],
    );
  }

  Widget _progressCard() {
    final milestones = project.milestones;
    final activeMilestone = _activeMilestone(milestones);
    final progressSubtitle = activeMilestone?.name.trim().isNotEmpty == true
        ? '${activeMilestone!.name} in progress'
        : project.status.trim().isNotEmpty
        ? project.status.trim()
        : 'Project status';

    return _glassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Column(
          children: [
            Column(
              children: [
                const Text(
                  "Project Progress",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  progressSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressPercent(
                  percent: _progressPercent(),
                  size: 110,
                  progressColor: const Color(0xFF0C7A7E),
                  backgroundColor: Colors.white.withOpacity(0.15),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (milestones.isEmpty)
                        const Text(
                          'No milestones available.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        )
                      else
                        ...milestones.take(4).map((milestone) {
                          final completed = milestone.isCompleted;
                          final color = completed
                              ? const Color(0xFF0C7A7E)
                              : const Color(0xFFE74C3C);
                          final label = milestone.name.trim().isNotEmpty
                              ? milestone.name.trim()
                              : 'Milestone';
                          return _progressItem(label, color, completed);
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressItem(String label, Color color, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed ? color : color.withOpacity(0.4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: completed ? Colors.white : Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoGrid() {
    final type = project.type.trim().isNotEmpty ? project.type.trim() : '-';
    final location = project.location.trim().isNotEmpty
        ? project.location.trim()
        : '-';

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        _InfoTile(
          icon: Icons.calendar_today_outlined,
          title: "Start Date",
          value: _formatDate(project.startDate),
        ),
        _InfoTile(
          icon: Icons.calendar_today_outlined,
          title: "End Date",
          value: _formatDate(project.endDate),
        ),
        _InfoTile(icon: Icons.home_work_outlined, title: "Type", value: type),
        _InfoTile(
          icon: Icons.location_on_outlined,
          title: "Location",
          value: location,
        ),
      ],
    );
  }

  Widget _quickActions() {
    final documentsCount = project.documents.length;
    final approvalsCount = 2;
    final reviewCount = 2;
    final invoicesCount = 2;

    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Actions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          _ActionTile(
            title: "Documents",
            icon: Icons.description_outlined,
            count: documentsCount.toString().padLeft(2, '0'),
            badgeColor: const Color(0xFF0C7A7E),
            navigateTo: ProjectBasedDocuments(projectId: project.id),
          ),
          const SizedBox(height: 10),
          _ActionTile(
            title: "Approvals",
            icon: Icons.check_box_outlined,
            count: approvalsCount.toString().padLeft(2, '0'),
            badgeColor: const Color(0xFFE74C3C),
            navigateTo: const ProjectBaseApproval(),
          ),
          const SizedBox(height: 10),
          if (isTeamMember)
            _ActionTile(
              title: "Review",
              icon: Icons.fact_check_outlined,
              count: reviewCount.toString().padLeft(2, '0'),
              badgeColor: const Color(0xFFE74C3C),
              navigateTo: const ProjectBaseApproval(),
            )
          else
            _ActionTile(
              title: "Invoices",
              icon: Icons.attach_money,
              count: invoicesCount.toString().padLeft(2, '0'),
              badgeColor: const Color(0xFF0C7A7E),
              navigateTo: const ProjectInvoicesScreen(),
            ),
        ],
      ),
    );
  }

  Widget _recentActivity() {
    final activities = _buildActivities();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Activity",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _glassCard(
          child: Column(
            children: List.generate(activities.length, (index) {
              final item = activities[index];
              final isLast = index == activities.length - 1;
              return _ActivityRow(item: item, isLast: isLast);
            }),
          ),
        ),
      ],
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.22),
                Colors.black.withOpacity(0.25),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: child,
        ),
      ),
    );
  }

  double _progressPercent() {
    final overall = project.overallProgress;
    if (overall > 0) {
      return overall.clamp(0, 100) / 100;
    }
    final milestones = project.milestones;
    if (milestones.isEmpty) return 0;
    final completed = milestones.where((m) => m.isCompleted).length;
    return completed / milestones.length;
  }

  ProjectMilestone? _activeMilestone(List<ProjectMilestone> milestones) {
    for (final milestone in milestones) {
      if (!milestone.isCompleted) {
        return milestone;
      }
    }
    return milestones.isNotEmpty ? milestones.last : null;
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '-';
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
    final monthIndex = value.month - 1;
    final month = monthIndex >= 0 && monthIndex < months.length
        ? months[monthIndex]
        : value.month.toString().padLeft(2, '0');
    return '$month ${value.day.toString().padLeft(2, '0')}, ${value.year}';
  }

  List<_RecentActivityItem> _buildActivities() {
    final items = <_RecentActivityItem>[];
    for (final entry in project.documents) {
      final map = _mapOrEmpty(entry);
      if (map.isEmpty) continue;
      final title = _firstNonEmpty(map, [
        'title',
        'name',
        'fileName',
        'filename',
        'documentName',
      ]);
      if (title.isEmpty) continue;
      final time = _formatTimeAgo(
        _firstDate(map, ['createdAt', 'updatedAt', 'date']),
      );
      items.add(
        _RecentActivityItem(
          title: 'New document uploaded: $title',
          time: time,
          dotColor: const Color(0xFF0C7A7E),
        ),
      );
    }
    for (final entry in project.tasks) {
      final map = _mapOrEmpty(entry);
      if (map.isEmpty) continue;
      final title = _firstNonEmpty(map, ['title', 'name', 'taskName']);
      if (title.isEmpty) continue;
      final time = _formatTimeAgo(
        _firstDate(map, ['createdAt', 'updatedAt', 'date']),
      );
      items.add(
        _RecentActivityItem(
          title: 'Task updated: $title',
          time: time,
          dotColor: Colors.white70,
        ),
      );
    }
    if (items.isEmpty) {
      return _fallbackActivities();
    }
    return items.take(3).toList();
  }

  List<_RecentActivityItem> _fallbackActivities() {
    return const [
      _RecentActivityItem(
        title: 'New document uploaded: Floor Plans Rev. 3',
        time: '2h ago',
        dotColor: Color(0xFF0C7A7E),
      ),
      _RecentActivityItem(
        title: 'Approval required: Design Proposal',
        time: '5h ago',
        dotColor: Colors.white70,
      ),
      _RecentActivityItem(
        title: 'New message from Sarah Johnson',
        time: '1d ago',
        dotColor: Colors.white70,
      ),
    ];
  }

  Map<String, dynamic> _mapOrEmpty(dynamic value) {
    return value is Map
        ? Map<String, dynamic>.from(value)
        : <String, dynamic>{};
  }

  String _firstNonEmpty(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }

  DateTime? _firstDate(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value == null) continue;
      if (value is DateTime) return value;
      final parsed = DateTime.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return null;
  }

  String _formatTimeAgo(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${time.month}/${time.day}/${time.year}';
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color badgeColor;
  final Widget navigateTo;

  const _ActionTile({
    required this.title,
    required this.count,
    required this.icon,
    required this.badgeColor,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.18),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(count, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final _RecentActivityItem item;
  final bool isLast;

  const _ActivityRow({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: item.dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.time,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(0.2), height: 1),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _RecentActivityItem {
  final String title;
  final String time;
  final Color dotColor;

  const _RecentActivityItem({
    required this.title,
    required this.time,
    required this.dotColor,
  });
}
