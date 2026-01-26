import 'dart:ui';
import 'package:dana_bozzetto/moduls/home/model/home_response_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/documents_screen.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_base_Approval.dart';
import 'package:flutter/material.dart';
import 'package:dana_bozzetto/moduls/home/common/project_cart.dart';
import 'package:dana_bozzetto/moduls/home/model/project_cart_model.dart';

import '../../../project/presentation/screen/project_based_invoices.dart';
const Color _accentColor = Color(0xFF0C7C84);

class HomeScreenT extends StatefulWidget {
  final Future<HomeDashboardResponse> dashboardFuture;
  final bool isTeamMember;

  const HomeScreenT({
    super.key,
    required this.dashboardFuture,
    this.isTeamMember = false,
  });

  @override
  State<HomeScreenT> createState() => _HomeScreenTState();
}

class _HomeScreenTState extends State<HomeScreenT> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _newProjectsController = ScrollController();
  HomeDashboardResponse? _cachedDashboard;
  final Map<String, String> _manualProjectStatus = {};

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset - 160,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset + 160,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollLeftNewProjects() {
    if (_newProjectsController.hasClients) {
      _newProjectsController.animateTo(
        _newProjectsController.offset - 160,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollRightNewProjects() {
    if (_newProjectsController.hasClients) {
      _newProjectsController.animateTo(
        _newProjectsController.offset + 160,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _newProjectsController.dispose();
    super.dispose();
  }

  String _formatStat(int value) => value.toString().padLeft(2, '0');

  List<ProjectModel> _buildProjectModels(List<HomeProject> projects) {
    if (projects.isEmpty) return <ProjectModel>[];
    return projects.map((project) {
      final name = project.name.trim();
      final nameParts = _splitProjectName(name);
      final title = nameParts[0].isNotEmpty ? nameParts[0] : 'Project';
      final subtitle = nameParts.length > 1 ? nameParts[1] : '';
      final totalMilestones = project.milestoneTotal;
      final currentMilestone = project.milestoneCurrent;
      final teamAvatars = project.teamAvatars
          .map((avatar) => avatar.url.trim())
          .where((url) => url.isNotEmpty)
          .toList();

      return ProjectModel(
        id: project.id,
        image: project.coverImage.isNotEmpty
            ? project.coverImage
            : 'assets/image/aa.png',
        status: project.status.isNotEmpty ? project.status : 'Unknown',
        isActive: project.status.toLowerCase() == 'active',
        title: title,
        subtitle: subtitle,
        deadline: project.deadline ?? DateTime.now(),
        currentMilestone: currentMilestone,
        totalMilestones: totalMilestones,
        steps: _buildSteps(totalMilestones, currentMilestone),
        teamAvatars: teamAvatars,
      );
    }).toList();
  }

  List<ProjectStep> _buildSteps(int totalMilestones, int currentMilestone) {
    final total = totalMilestones > 0 ? totalMilestones : 1;
    final current = currentMilestone > 0 ? currentMilestone : 1;
    const stageLabels = ['PD', 'SD', 'DD', 'CD'];
    return List.generate(
      total,
      (index) => ProjectStep(
        label: total <= stageLabels.length
            ? stageLabels[index]
            : '${index + 1}',
        completed: index + 1 <= current,
      ),
    );
  }

  List<String> _splitProjectName(String name) {
    if (name.isEmpty) {
      return const ['Project', ''];
    }
    const separators = [' - ', ': '];
    for (final separator in separators) {
      if (name.contains(separator)) {
        final parts = name.split(separator);
        final title = parts.first.trim();
        final subtitle = parts.sublist(1).join(separator).trim();
        return [title, subtitle];
      }
    }
    return [name, ''];
  }

  String _formatTimeAgo(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final diff = now.difference(time);
    final duration = diff.isNegative ? diff.abs() : diff;
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s ago';
    }
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    }
    if (duration.inHours < 24) {
      return '${duration.inHours}h ago';
    }
    if (duration.inDays < 7) {
      return '${duration.inDays}d ago';
    }
    return '${time.month}/${time.day}/${time.year}';
  }

  Color _activityColor(String type) {
    switch (type.toLowerCase()) {
      case 'document':
        return _accentColor;
      case 'approval':
        return Colors.white70;
      case 'message':
        return Colors.white54;
      default:
        return Colors.white70;
    }
  }

  List<Widget> _buildActivityTiles(List<HomeRecentActivity> activities) {
    if (activities.isEmpty) return <Widget>[];
    return List.generate(activities.length, (index) {
      final activity = activities[index];
      return ActivityTile(
        title: activity.text.isNotEmpty ? activity.text : 'Activity',
        subtitle:
            activity.subText.isNotEmpty ? activity.subText : activity.type,
        time: _formatTimeAgo(activity.time),
        bulletColor: _activityColor(activity.type),
        showDivider: index != activities.length - 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeDashboardResponse>(
      future: widget.dashboardFuture,
      builder: (context, snapshot) {
        final dashboard = snapshot.data ?? _cachedDashboard;
        if (snapshot.hasData) {
          _cachedDashboard = snapshot.data;
        }
        final stats = dashboard?.stats ?? const HomeStats.empty();
        final projectModels =
            _buildProjectModels(dashboard?.projects ?? const []);
        final activityTiles =
            _buildActivityTiles(dashboard?.recentActivity ?? const []);

        final overviewCards = widget.isTeamMember
            ? [
                _OverviewCardData(
                  title: 'Active Tasks',
                  value: _formatStat(stats.active),
                  icon: Icons.description_outlined,
                  iconBackground: _accentColor,
                  iconColor: Colors.white,
                ),
                _OverviewCardData(
                  title: 'Pending Tasks',
                  value: _formatStat(stats.pending),
                  icon: Icons.check_circle_outline,
                  iconBackground: Colors.white70,
                  iconColor: const Color(0xFF5A5A5A),
                ),
              ]
            : [
                _OverviewCardData(
                  title: 'Active Projects',
                  value: _formatStat(stats.active),
                  icon: Icons.description_outlined,
                  iconBackground: _accentColor,
                  iconColor: Colors.white,
                ),
                _OverviewCardData(
                  title: 'Pending Projects',
                  value: _formatStat(stats.pending),
                  icon: Icons.check_circle_outline,
                  iconBackground: Colors.white70,
                  iconColor: const Color(0xFF5A5A5A),
                ),
                _OverviewCardData(
                  title: 'Documents',
                  value: _formatStat(stats.documents),
                  icon: Icons.description,
                  iconBackground: Colors.white70,
                  iconColor: const Color(0xFF5A5A5A),
                  
                  
                ),
              ];

        final quickActions = widget.isTeamMember
            ? [
                _QuickActionData(
                  title: 'Documents',
                  icon: Icons.description_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DocumentsScreen(),
                      ),
                    );
                  },
                ),
                _QuickActionData(
                  title: 'Approvals',
                  icon: Icons.check_circle_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProjectBaseApproval(
                          isTeamMember: widget.isTeamMember,
                        ),
                      ),
                    );
                  },
                ),
              ]
            : [
                _QuickActionData(
                  title: 'Documents',
                  icon: Icons.description_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DocumentsScreen(),
                      ),
                    );
                  },
                ),
                _QuickActionData(
                  title: 'Approvals',
                  icon: Icons.check_circle_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProjectBaseApproval(
                          isTeamMember: widget.isTeamMember,
                        ),
                      ),
                    );
                  },
                ),
                _QuickActionData(
                  title: 'Finance',
                  icon: Icons.attach_money,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProjectInvoicesScreen(),
                      ),
                    );
                  },
                ),
              ];

        final highlightedProject =
            projectModels.isNotEmpty ? projectModels.first : null;
        final quickActionTitle =
            widget.isTeamMember ? 'Quick Actions' : 'Quick Action';
        final projectSectionTitle =
            widget.isTeamMember ? 'Assigned Projects' : 'New Projects';

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isTeamMember) ...[
                _sectionTitle("Today Task's"),
                const SizedBox(height: 12),
                _todayTaskCard(highlightedProject),
                const SizedBox(height: 16),
              ],
              _sectionHeader(
                'Projects Overview',
                onLeft: _scrollLeft,
                onRight: _scrollRight,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: overviewCards
                      .map(
                        (card) => _OverviewCard(
                          title: card.title,
                          value: card.value,
                          icon: card.icon,
                          iconBackground: card.iconBackground,
                          iconColor: card.iconColor,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
               _sectionHeader(
                projectSectionTitle,
                onLeft: _scrollLeftNewProjects,
                onRight: _scrollRightNewProjects,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 560,
                child: ListView.builder(
                  controller: _newProjectsController,
                  scrollDirection: Axis.horizontal,
                  itemCount: projectModels.length,
                  itemBuilder: (context, index) {
                    final cardWidth = MediaQuery.of(context).size.width - 32;
                    return Container(
                      width: cardWidth,
                      margin: const EdgeInsets.only(right: 16),
                      child: ProjectCard(
                        project: projectModels[index],
                        isTeamMember: widget.isTeamMember,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                quickActionTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 165 / 120,
                padding: EdgeInsets.zero,
                children: quickActions
                    .map(
                      (action) => QuickAction(
                        icon: action.icon,
                        title: action.title,
                        onTap: action.onTap,
                      ),
                    )
                    .toList(),
              ),
              if (!widget.isTeamMember) ...[
                const SizedBox(height: 24),
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (activityTiles.isNotEmpty)
                  _activityContainer(activityTiles),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _sectionHeader(
    String title, {
    required VoidCallback onLeft,
    required VoidCallback onRight,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white70,
                size: 18,
              ),
              onPressed: onLeft,
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
                size: 18,
              ),
              onPressed: onRight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _todayTaskCard(ProjectModel? project) {
    final title = project?.title.isNotEmpty == true
        ? project!.title
        : 'No tasks yet';
    final subtitle = project?.subtitle.isNotEmpty == true
        ? project!.subtitle
        : 'Assigned project';
    final statusOptions = _statusOptionsFor(project);
    final storedStatus =
        project == null ? null : _manualProjectStatus[project.id];
    final status = storedStatus ?? _formatStatus(project?.status ?? '');
    final statusValue =
        statusOptions.contains(status) ? status : statusOptions.first;
    final isEnabled = project != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        decoration: BoxDecoration(
          color: _accentColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isEnabled ? 0.95 : 0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: statusValue,
                  items: statusOptions
                      .map(
                        (option) => DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: const TextStyle(
                              color: Color(0xFF3B3B3B),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: isEnabled
                      ? (value) {
                          if (value == null || project == null) return;
                          setState(() {
                            _manualProjectStatus[project.id] = value;
                          });
                        }
                      : null,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: Colors.black54,
                  ),
                  isDense: true,
                  dropdownColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatus(String status) {
    final trimmed = status.trim();
    if (trimmed.isEmpty) {
      return 'Wip';
    }
    if (trimmed.length == 1) {
      return trimmed.toUpperCase();
    }
    return '${trimmed[0].toUpperCase()}${trimmed.substring(1)}';
  }

  List<String> _statusOptionsFor(ProjectModel? project) {
    final options = <String>['Active', 'Pending', 'Completed', 'Wip', 'On hold'];
    final current = _formatStatus(project?.status ?? '');
    if (current.isNotEmpty && !options.contains(current)) {
      options.insert(0, current);
    }
    return options;
  }

  Widget _activityContainer(List<Widget> tiles) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(children: tiles),
        ),
      ),
    );
  }
}

class _OverviewCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;

  const _OverviewCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
  });
}

class _QuickActionData {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _QuickActionData({
    required this.title,
    required this.icon,
    this.onTap,
  });
}

// ===== Overview Card =====
class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;

  const _OverviewCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          width: 160,
          height: 140,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.fromLTRB(16, 16, 12, 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.22)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.22)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: _accentColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(icon, color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Color bulletColor;
  final bool showDivider;

  const ActivityTile({
    required this.title,
    required this.subtitle,
    required this.time,
    this.bulletColor = Colors.white70,
    this.showDivider = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 6, right: 12),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: bulletColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.7),
                    width: 2,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: const TextStyle(color: Colors.white38, fontSize: 12.5),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1.2,
            color: Colors.white.withOpacity(0.12),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
