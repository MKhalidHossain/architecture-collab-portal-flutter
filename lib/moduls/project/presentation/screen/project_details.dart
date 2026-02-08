import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/controller/project_details_controller.dart';
import 'package:dana_bozzetto/moduls/project/model/project_details_response_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/mileston_widget.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/overview_widget.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/team_widget.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/team_member_tasks_tab.dart';
import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;
  final bool isClient;

  const ProjectDetailScreen({
    super.key,
    required this.projectId,
    this.isClient = true,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  int _selectedTab = 0;
  late final ProjectDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProjectDetailsController();
    _controller.fetchProjectDetails(widget.projectId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final tabs = _tabsList();
        final project = _controller.details.project;
        final hasData = project.id.isNotEmpty || project.name.isNotEmpty;
        final showLoading = _controller.isLoading && !hasData;
        final showError = _controller.errorMessage.isNotEmpty && !hasData;

        return Scaffold(
          body: Column(
            children: [
              _header(context, tabs, project),
              Expanded(
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/image/ab.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    if (showLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white70,
                        ),
                      )
                    else if (showError)
                      _buildMessage(
                        _controller.errorMessage,
                        onRetry: _retry,
                      )
                    else
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: _buildTabContent(tabs, project),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= TAB LIST =================

  List<String> _tabsList() {
    if (widget.isClient) {
      return [
        "Overview",
        "Team",
        "Milestones",
      ];
    }
    return [
      "Overview",
      "Tasks",
      "Milestones",
      "Team",
    ];
  }

  // ================= TAB CONTENT =================

  Widget _buildTabContent(List<String> tabs, ProjectDetailsModel project) {
    final currentTab = tabs[_selectedTab];

    switch (currentTab) {
      case "Overview":
        return OverviewTab(project: project, isTeamMember: !widget.isClient);
      case "Tasks":
        return TeamMemberTasksTab(project: project);
      case "Team":
        return TeamTab(
          teamMembers: project.teamMembers,
          projectId: project.id,
        );
      case "Milestones":
        return MilestonesTab(milestones: project.milestones);
      default:
        return const SizedBox();
    }
  }

  // ================= HEADER =================

  Widget _header(
    BuildContext context,
    List<String> tabs,
    ProjectDetailsModel project,
  ) {
    final title = project.name.trim().isNotEmpty
        ? project.name.trim()
        : 'Project';
    final subtitle = project.client.name.trim().isNotEmpty
        ? project.client.name.trim()
        : project.projectNo.trim().isNotEmpty
            ? project.projectNo.trim()
            : '-';
    final status = project.status.trim().isNotEmpty
        ? project.status.trim()
        : 'Unknown';
    final tabWidth = widget.isClient ? 130.0 : 120.0;
    final tabHeight = widget.isClient ? 50.0 : 44.0;
    final tabRadius = widget.isClient ? 16.0 : 14.0;

    return Stack(
      children: [
        Image(
          image: _resolveImage(project.coverImage.url),
          width: double.infinity,
          height: 360,
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            height: 360,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            color: Colors.black.withOpacity(0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// BACK
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Back to Projects",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                const Text(
                  "Track all your architectural projects",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),

                const SizedBox(height: 18),

                /// TITLE
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),

                const SizedBox(height: 12),

                /// STATUS
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C7A7E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ---------------- TABS ----------------
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(tabs.length, (index) {
                      final isActive = _selectedTab == index;
                      final backgroundColor = isActive
                          ? const Color(0xFF0C7A7E)
                          : Colors.white.withOpacity(0.4);
                      final textColor = isActive
                          ? Colors.white
                          : const Color(0xFF2B2B2B);

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTab = index;
                            });
                          },
                          child: Container(
                            width: tabWidth,
                            height: tabHeight,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(tabRadius),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                tabs[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isNotEmpty ? message : 'Failed to load project details.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onRetry,
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Color(0xFF00D4AA)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _retry() {
    _controller.fetchProjectDetails(widget.projectId);
  }

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
}
