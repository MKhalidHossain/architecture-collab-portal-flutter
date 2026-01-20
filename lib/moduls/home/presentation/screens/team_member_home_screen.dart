import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/home/interface/home_interface.dart';
import 'package:dana_bozzetto/moduls/home/model/home_response_model.dart';
import 'package:dana_bozzetto/moduls/home/model/team_member_home_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/menu/client_home_screen.dart';

class TeamMemberHomeScreen extends StatefulWidget {
  final String userId;
  const TeamMemberHomeScreen({super.key, required this.userId});

  @override
  State<TeamMemberHomeScreen> createState() => _TeamMemberHomeScreenState();
}

class _TeamMemberHomeScreenState extends State<TeamMemberHomeScreen> {
  late final Future<HomeDashboardResponse> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _fetchTeamDashboard();
  }

  Future<HomeDashboardResponse> _fetchTeamDashboard() async {
    final homeInterface = Get.find<HomeInterface>();
    final result = await homeInterface.fetchTeamDashboard();
    return result.fold(
      (failure) {
        final message = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
        throw Exception(
          message.isNotEmpty ? message : 'Failed to load dashboard',
        );
      },
      (success) => _mapToClientDashboard(
        success.data ?? TeamMemberDashboardResponse.empty(),
      ),
    );
  }

  HomeDashboardResponse _mapToClientDashboard(
    TeamMemberDashboardResponse source,
  ) {
    return HomeDashboardResponse(
      userName: source.userName,
      stats: HomeStats(
        active: source.stats.activeTasks,
        pending: source.stats.pendingTasks,
        documents: source.quickActions.documents,
      ),
      projects: source.assignedProjects.map((project) {
        final avatars = project.teamAvatars
            .where((url) => url.trim().isNotEmpty)
            .map((url) => HomeTeamAvatar(publicId: '', url: url))
            .toList();
        return HomeProject(
          id: project.id,
          name: project.name,
          status: project.status,
          deadline: project.deadline,
          coverImage: project.coverImage,
          milestoneCurrentStep: project.milestoneCurrent,
          milestoneLabel: project.milestoneProgress,
          teamAvatars: avatars,
        );
      }).toList(),
      recentActivity: const <HomeRecentActivity>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClientHomeScreen(
      userId: widget.userId,
      dashboardFuture: _dashboardFuture,
      showCalendarMenu: true,
      isTeamMember: true,
    );
  }
}
