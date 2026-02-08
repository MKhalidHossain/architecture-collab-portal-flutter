import 'package:flutter/material.dart';
import 'package:dana_bozzetto/moduls/home/common/project_cart.dart';
import 'package:dana_bozzetto/moduls/home/model/project_cart_model.dart';
import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';

enum ProjectFilter {
  all,
  ongoing,
  completed,
}

class ProjectBody extends StatefulWidget {
  final Future<ProjectsResponse> projectsFuture;
  final ProjectFilter filter;
  final bool isTeamMember;

  const ProjectBody({
    super.key,
    required this.projectsFuture,
    required this.filter,
    this.isTeamMember = false,
  });

  @override
  State<ProjectBody> createState() => _ProjectBodyState();
}

class _ProjectBodyState extends State<ProjectBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProjectsResponse _cachedProjects = ProjectsResponse.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          /// Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/ab.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Project List
          Padding(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<ProjectsResponse>(
              future: widget.projectsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _cachedProjects = snapshot.data ?? _cachedProjects;
                }
                final projects =
                    snapshot.data?.projects ?? _cachedProjects.projects;
                if (projects.isEmpty) {
                  return _buildEmptyState(snapshot);
                }

                final filteredProjects =
                    _filterProjects(projects, widget.filter);
                if (filteredProjects.isEmpty) {
                  return _buildMessage('No projects for this tab.');
                }

                final projectModels =
                    _buildProjectModels(filteredProjects);
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: projectModels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    return ProjectCard(
                      project: projectModels[index],
                      isTeamMember: widget.isTeamMember,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AsyncSnapshot<ProjectsResponse> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white70),
      );
    }
    if (snapshot.hasError) {
      return _buildMessage('Failed to load projects.');
    }
    return _buildMessage('No projects found.');
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  List<ProjectResponseModel> _filterProjects(
    List<ProjectResponseModel> projects,
    ProjectFilter filter,
  ) {
    if (filter == ProjectFilter.all) return projects;
    return projects.where((project) {
      final isCompleted = project.isCompleted;
      if (filter == ProjectFilter.completed) {
        return isCompleted;
      }
      return !isCompleted;
    }).toList();
  }

  List<ProjectModel> _buildProjectModels(
    List<ProjectResponseModel> projects,
  ) {
    return projects.map((project) {
      final title = project.name.trim().isNotEmpty
          ? project.name.trim()
          : 'Project';
      final subtitle = project.client.name.trim().isNotEmpty
          ? project.client.name.trim()
          : project.projectNo;
      final deadline =
          project.endDate ?? project.startDate ?? DateTime.now();
      final totalMilestones =
          project.totalMilestones > 0 ? project.totalMilestones : 1;
      final completedMilestones = project.completedMilestones;
      final currentMilestone = completedMilestones > 0
          ? completedMilestones
          : (project.isCompleted ? totalMilestones : 1);
      final clampedCurrent = currentMilestone > totalMilestones
          ? totalMilestones
          : currentMilestone;
      final steps = project.milestones.isNotEmpty
          ? project.milestones.asMap().entries.map((entry) {
              final milestone = entry.value;
              return ProjectStep(
                label: _abbreviateMilestone(
                  milestone.name,
                  entry.key,
                ),
                completed: milestone.isCompleted,
              );
            }).toList()
          : _buildFallbackSteps(totalMilestones, clampedCurrent);

      final teamAvatars = project.teamMembers
          .map((member) => member.user.avatar.url.trim())
          .where((url) => url.isNotEmpty)
          .toList();
      if (teamAvatars.isEmpty && project.client.avatar.url.isNotEmpty) {
        teamAvatars.add(project.client.avatar.url);
      }

      return ProjectModel(
        id: project.id,
        image: project.coverImage.url.trim(),
        status: project.status.isNotEmpty ? project.status : 'Unknown',
        isActive: !project.isCompleted,
        title: title,
        subtitle: subtitle,
        deadline: deadline,
        currentMilestone: clampedCurrent,
        totalMilestones: totalMilestones,
        steps: steps,
        teamAvatars: teamAvatars,
      );
    }).toList();
  }

  List<ProjectStep> _buildFallbackSteps(
    int totalMilestones,
    int currentMilestone,
  ) {
    final total = totalMilestones > 0 ? totalMilestones : 1;
    final current = currentMilestone > 0 ? currentMilestone : 1;
    return List.generate(
      total,
      (index) => ProjectStep(
        label: '${index + 1}',
        completed: index + 1 <= current,
      ),
    );
  }

  String _abbreviateMilestone(String name, int index) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '${index + 1}';
    }
    final parts = trimmed.split(RegExp(r'[\s-]+'));
    final letters = parts
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase())
        .join();
    if (letters.isEmpty) {
      return '${index + 1}';
    }
    return letters.length > 3 ? letters.substring(0, 3) : letters;
  }
}
