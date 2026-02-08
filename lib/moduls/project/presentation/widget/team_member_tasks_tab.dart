import 'dart:ui';

import 'package:dana_bozzetto/moduls/project/controller/project_tasks_controller.dart';
import 'package:dana_bozzetto/moduls/project/model/project_details_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/project_task_response_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/create_task_screen.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/upload_document_screen.dart';
import 'package:flutter/material.dart';

const Color _accentColor = Color(0xFF0C7A7E);

class TeamMemberTasksTab extends StatefulWidget {
  final ProjectDetailsModel project;

  const TeamMemberTasksTab({super.key, required this.project});

  @override
  State<TeamMemberTasksTab> createState() => _TeamMemberTasksTabState();
}

class _TeamMemberTasksTabState extends State<TeamMemberTasksTab> {
  late final ProjectTasksController _tasksController;
  static const List<String> _defaultStageTitles = [
    'Pre-Design',
    'Schematic Design',
    'Design Developed',
    'Construction Documents',
  ];

  @override
  void initState() {
    super.initState();
    _tasksController = ProjectTasksController();
    _tasksController.fetchTasks(projectId: widget.project.id);
  }

  @override
  void dispose() {
    _tasksController.dispose();
    super.dispose();
  }

  List<_TaskSection> _buildDefaultSections() {
    return [
      _TaskSection(
        milestoneId: '',
        title: 'Pre-Design',
        statusLabel: 'Approved',
        statusColor: _accentColor,
        statusTextColor: Colors.white,
        showCompletedButton: true,
        tasks: const [
          _TaskItem(id: '', title: 'Survey', completed: true),
          _TaskItem(id: '', title: 'Measuring Building', completed: true),
          _TaskItem(id: '', title: 'Drawing Existing conditions', completed: true),
          _TaskItem(id: '', title: 'Drawing site plan', completed: true),
        ],
      ),
      _TaskSection(
        milestoneId: '',
        title: 'Schematic Design',
        statusLabel: 'Pending',
        statusColor: const Color(0xFFE8F1F1),
        statusTextColor: _accentColor,
        tasks: const [
          _TaskItem(id: '', title: 'Made Concept'),
          _TaskItem(id: '', title: 'Design Preliminary Floor Plan'),
          _TaskItem(id: '', title: 'Design Preliminary Elevation'),
          _TaskItem(id: '', title: 'Preliminary 3D view'),
        ],
      ),
      _TaskSection(
        milestoneId: '',
        title: 'Design Developed',
        statusLabel: 'Pending',
        statusColor: const Color(0xFFE8F1F1),
        statusTextColor: _accentColor,
        tasks: const [
          _TaskItem(id: '', title: 'Made floor plan'),
          _TaskItem(id: '', title: 'Made Elevation'),
          _TaskItem(id: '', title: 'Define Structural'),
          _TaskItem(id: '', title: 'Building Sections'),
        ],
      ),
      _TaskSection(
        milestoneId: '',
        title: 'Construction Documents',
        statusLabel: 'Pending',
        statusColor: const Color(0xFFE8F1F1),
        statusTextColor: _accentColor,
        tasks: const [
          _TaskItem(id: '', title: 'Details'),
          _TaskItem(id: '', title: 'Electric Plan'),
          _TaskItem(id: '', title: 'Plumbing Plan'),
          _TaskItem(id: '', title: 'HVSE Plan'),
          _TaskItem(id: '', title: 'Building Sections'),
        ],
      ),
    ];
  }

  List<_TaskSection> _buildSectionsFromTasks(
    List<ProjectTaskResponseModel> tasks,
  ) {
    final milestones = widget.project.milestones;
    if (milestones.isEmpty && tasks.isEmpty) {
      return _buildDefaultSections();
    }

    final tasksByMilestone = <String, List<ProjectTaskResponseModel>>{};
    for (final task in tasks) {
      final key = task.milestoneId;
      if (key.isEmpty) {
        continue;
      }
      tasksByMilestone.putIfAbsent(key, () => <ProjectTaskResponseModel>[]);
      tasksByMilestone[key]!.add(task);
    }

    final usedMilestoneIds = <String>{};
    final sections = <_TaskSection>[];
    for (final title in _defaultStageTitles) {
      final milestone =
          _matchMilestoneForStage(title, milestones, usedMilestoneIds);
      if (milestone != null) {
        usedMilestoneIds.add(milestone.id);
      }
      sections.add(
        _buildSectionFromMilestone(
          milestone: milestone,
          titleFallback: title,
          tasksByMilestone: tasksByMilestone,
        ),
      );
    }

    for (final milestone in milestones) {
      if (usedMilestoneIds.contains(milestone.id)) {
        continue;
      }
      sections.add(
        _buildSectionFromMilestone(
          milestone: milestone,
          titleFallback: milestone.name,
          tasksByMilestone: tasksByMilestone,
        ),
      );
    }

    return sections;
  }

  bool _isTaskCompleted(String status) {
    final normalized = status.trim().toLowerCase();
    return normalized == 'completed' || normalized == 'done';
  }

  String _normalizeStageName(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  ProjectMilestone? _matchMilestoneForStage(
    String stageTitle,
    List<ProjectMilestone> milestones,
    Set<String> usedIds,
  ) {
    final stageKey = _normalizeStageName(stageTitle);
    for (final milestone in milestones) {
      if (usedIds.contains(milestone.id)) {
        continue;
      }
      if (_isStageMatch(stageKey, milestone.name)) {
        return milestone;
      }
    }
    return null;
  }

  bool _isStageMatch(String stageKey, String milestoneName) {
    final name = _normalizeStageName(milestoneName);
    if (name.isEmpty) {
      return false;
    }
    switch (stageKey) {
      case 'predesign':
        return name.contains('predesign') ||
            (name.contains('pre') && name.contains('design')) ||
            name == 'pd';
      case 'schematicdesign':
        return name.contains('schematic') || name == 'sd';
      case 'designdeveloped':
        return name.contains('designdevelop') ||
            (name.contains('design') && name.contains('develop')) ||
            name == 'dd';
      case 'constructiondocuments':
        return name.contains('construction') &&
            (name.contains('document') || name.contains('doc')) ||
            name == 'cd';
      default:
        return name == stageKey || name.contains(stageKey);
    }
  }

  _TaskSection _buildSectionFromMilestone({
    required ProjectMilestone? milestone,
    required String titleFallback,
    required Map<String, List<ProjectTaskResponseModel>> tasksByMilestone,
  }) {
    final milestoneId = milestone?.id ?? '';
    final milestoneTasks =
        milestoneId.isNotEmpty ? (tasksByMilestone[milestoneId] ?? []) : [];
    final tasksCompleted = milestoneTasks.isNotEmpty &&
        milestoneTasks.every((task) => _isTaskCompleted(task.status));
    final isCompleted = (milestone?.isCompleted ?? false) || tasksCompleted;
    final title = milestone != null && milestone.name.trim().isNotEmpty
        ? milestone.name.trim()
        : (titleFallback.trim().isNotEmpty ? titleFallback.trim() : 'Task');
    final visibleTasks = isCompleted
        ? milestoneTasks.where((task) => _isTaskCompleted(task.status)).toList()
        : milestoneTasks;

    return _TaskSection(
      milestoneId: milestoneId,
      title: title,
      statusLabel: isCompleted ? 'Approved' : 'Pending',
      statusColor: isCompleted ? _accentColor : const Color(0xFFE8F1F1),
      statusTextColor: isCompleted ? Colors.white : _accentColor,
      showCompletedButton: isCompleted,
      tasks: visibleTasks
          .map(
            (task) => _TaskItem(
              id: task.id,
              title: task.name.isNotEmpty ? task.name : 'Task',
              completed: _isTaskCompleted(task.status),
            ),
          )
          .toList(),
    );
  }

  Future<void> _openAddTask({
    required String stage,
    required String milestoneId,
  }) async {
    if (milestoneId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Milestone is missing.')),
      );
      return;
    }
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTaskScreen(
          initialStage: stage,
          projectId: widget.project.id,
          milestoneId: milestoneId,
        ),
      ),
    );
    if (created == true) {
      _tasksController.fetchTasks(projectId: widget.project.id);
    }
  }

  Future<void> _openUploadForTask({
    required String stage,
    required _TaskItem task,
  }) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UploadDocumentScreen(
          initialStage: stage,
          initialTaskName: task.title,
          taskId: task.id,
        ),
      ),
    );
    if (updated == true) {
      _tasksController.fetchTasks(projectId: widget.project.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tasksController,
      builder: (context, _) {
        final sections = _buildSectionsFromTasks(_tasksController.tasks);
        final completedIndex = _completedIndex(sections);
        final showLoading =
            _tasksController.isLoading && _tasksController.tasks.isEmpty;
        final showError =
            _tasksController.errorMessage.isNotEmpty &&
                _tasksController.tasks.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _stageStepper(completedIndex),
            const SizedBox(height: 16),
            if (showLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.white70),
              )
            else if (showError)
              _errorState(_tasksController.errorMessage)
            else
              ...sections.map((section) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _sectionBlock(section),
                );
              }),
          ],
        );
      },
    );
  }

  int _completedIndex(List<_TaskSection> sections) {
    final index =
        sections.lastIndexWhere((section) => section.showCompletedButton);
    return index;
  }

  Widget _stageStepper(int completedIndex) {
    const stages = ['PD', 'SD', 'DD', 'CD'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(stages.length * 2 - 1, (index) {
            if (index.isOdd) {
              return Expanded(
                child: Container(
                  height: 3,
                  color: Colors.white54,
                ),
              );
            }
            final stageIndex = index ~/ 2;
            final isComplete =
                completedIndex >= 0 && stageIndex <= completedIndex;
            return _stageDot(isComplete);
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stages
              .map(
                (label) => SizedBox(
                  width: 36,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _stageDot(bool completed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? _accentColor : Colors.white70,
        border: Border.all(
          color: completed ? Colors.white : Colors.white54,
          width: 2,
        ),
      ),
      child: completed
          ? const Icon(Icons.verified_rounded, size: 18, color: Colors.white)
          : null,
    );
  }

  Widget _sectionBlock(_TaskSection section) {
    final sectionTask = section.tasks.firstWhere(
      (task) => task.id.isNotEmpty,
      orElse: () => const _TaskItem(id: '', title: ''),
    );
    final sectionTaskId = sectionTask.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              section.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            _statusPill(
              section.statusLabel,
              section.statusColor,
              section.statusTextColor,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...section.tasks.map((task) => _taskRow(section, task)),
        if (section.showCompletedButton) ...[
          const SizedBox(height: 14),
          _primaryActionButton(
            label: 'Completed',
            icon: Icons.verified_rounded,
            onTap: () {},
          ),
        ],
        if (!section.showCompletedButton) ...[
          const SizedBox(height: 14),
          _secondaryActionButton(
            label: 'Add New Task',
            icon: Icons.add,
            onTap: () => _openAddTask(
              stage: section.title,
              milestoneId: section.milestoneId,
            ),
            alignLeft: true,
            compact: true,
          ),
          const SizedBox(height: 12),
          _primaryActionButton(
            label: 'Upload Documents',
            icon: Icons.upload,
            onTap: () {
              if (sectionTaskId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No task to upload.')),
                );
                return;
              }
              _openUploadForTask(
                stage: section.title,
                task: sectionTask,
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _taskRow(_TaskSection section, _TaskItem task) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (task.id.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task is missing.')),
          );
          return;
        }
        _openUploadForTask(stage: section.title, task: task);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            _taskIndicator(task.completed),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskIndicator(bool completed) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? _accentColor : Colors.white70,
        border: Border.all(
          color: completed ? Colors.white : Colors.white54,
          width: 2,
        ),
      ),
      child: completed
          ? const Icon(Icons.verified_rounded, size: 11, color: Colors.white)
          : null,
    );
  }

  Widget _statusPill(String label, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _primaryActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _accentColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _secondaryActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool alignLeft = false,
    bool compact = false,
  }) {
    final button = ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: compact ? 44 : 52,
            width: compact ? null : double.infinity,
            padding: compact
                ? const EdgeInsets.symmetric(horizontal: 16)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.35)),
            ),
            child: Row(
              mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment:
                  compact ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: compact ? 16 : 18),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (alignLeft) {
      return Align(alignment: Alignment.centerLeft, child: button);
    }
    return button;
  }

  Widget _errorState(String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.isNotEmpty ? message : 'Failed to load tasks.',
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _tasksController.fetchTasks(
            projectId: widget.project.id,
          ),
          child: const Text(
            'Retry',
            style: TextStyle(color: _accentColor),
          ),
        ),
      ],
    );
  }

}

class _TaskSection {
  final String milestoneId;
  final String title;
  final String statusLabel;
  final Color statusColor;
  final Color statusTextColor;
  final bool showCompletedButton;
  final List<_TaskItem> tasks;

  const _TaskSection({
    required this.milestoneId,
    required this.title,
    required this.statusLabel,
    required this.statusColor,
    required this.statusTextColor,
    required this.tasks,
    this.showCompletedButton = false,
  });
}

class _TaskItem {
  final String id;
  final String title;
  final bool completed;

  const _TaskItem({
    required this.id,
    required this.title,
    this.completed = false,
  });
}
