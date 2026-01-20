import 'dart:ui';

import 'package:dana_bozzetto/moduls/project/model/project_details_response_model.dart';
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
  late final List<_TaskSection> _sections;

  @override
  void initState() {
    super.initState();
    _sections = _buildDefaultSections();
  }

  List<_TaskSection> _buildDefaultSections() {
    return [
      _TaskSection(
        title: 'Pre-Design',
        statusLabel: 'Approved',
        statusColor: _accentColor,
        statusTextColor: Colors.white,
        showCompletedButton: true,
        tasks: const [
          _TaskItem(title: 'Survey', completed: true),
          _TaskItem(title: 'Measuring Building', completed: true),
          _TaskItem(title: 'Drawing Existing conditions', completed: true),
          _TaskItem(title: 'Drawing site plan', completed: true),
        ],
      ),
      _TaskSection(
        title: 'Schematic Design',
        statusLabel: 'Pending',
        statusColor: const Color(0xFFE8F1F1),
        statusTextColor: _accentColor,
        tasks: const [
          _TaskItem(title: 'Made Concept'),
          _TaskItem(title: 'Design Preliminary Floor Plan'),
          _TaskItem(title: 'Design Preliminary Elevation'),
          _TaskItem(title: 'Preliminary 3D view'),
        ],
      ),
      _TaskSection(
        title: 'Design Developed',
        statusLabel: 'Pending',
        statusColor: const Color(0xFFE8F1F1),
        statusTextColor: _accentColor,
        tasks: const [
          _TaskItem(title: 'Made floor plan'),
          _TaskItem(title: 'Made Elevation'),
          _TaskItem(title: 'Define Structural'),
          _TaskItem(title: 'Building Sections'),
        ],
      ),
      _TaskSection(
        title: 'Construction Documents',
        statusLabel: 'Pending',
        statusColor: const Color(0xFFE8F1F1),
        statusTextColor: _accentColor,
        tasks: const [
          _TaskItem(title: 'Details'),
          _TaskItem(title: 'Electric Plan'),
          _TaskItem(title: 'Plumbing Plan'),
          _TaskItem(title: 'HVSE Plan'),
          _TaskItem(title: 'Building Sections'),
        ],
      ),
    ];
  }

  void _openUpload({required String stage, String? task}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UploadDocumentScreen(
          initialStage: stage,
          initialTaskName: task,
        ),
      ),
    );
  }

  void _openAddTask({required String stage}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTaskScreen(initialStage: stage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stageStepper(),
        const SizedBox(height: 16),
        ..._sections.map((section) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _sectionBlock(section),
          );
        }),
      ],
    );
  }

  Widget _stageStepper() {
    const stages = ['PD', 'SD', 'DD', 'CD'];
    const completedIndex = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(stages.length * 2 - 1, (index) {
            if (index.isOdd) {
              final lineIndex = index ~/ 2;
              final isActive = lineIndex <= completedIndex;
              return Expanded(
                child: Container(
                  height: 2,
                  color: isActive ? _accentColor : Colors.white54,
                ),
              );
            }
            final stageIndex = index ~/ 2;
            final isComplete = stageIndex <= completedIndex;
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
          color: completed ? _accentColor : Colors.white70,
          width: 2,
        ),
      ),
      child: completed
          ? const Icon(Icons.check, size: 18, color: Colors.white)
          : null,
    );
  }

  Widget _sectionBlock(_TaskSection section) {
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
            icon: Icons.check,
            onTap: () {},
          ),
        ],
        if (!section.showCompletedButton) ...[
          const SizedBox(height: 14),
          _secondaryActionButton(
            label: 'Add New Task',
            icon: Icons.add,
            onTap: () => _openAddTask(stage: section.title),
          ),
          const SizedBox(height: 12),
          _primaryActionButton(
            label: 'Upload Documents',
            icon: Icons.upload,
            onTap: () => _openUpload(stage: section.title),
          ),
        ],
      ],
    );
  }

  Widget _taskRow(_TaskSection section, _TaskItem task) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openUpload(stage: section.title, task: task.title),
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
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? _accentColor : Colors.white70,
        border: Border.all(
          color: completed ? _accentColor : Colors.white70,
          width: 2,
        ),
      ),
      child: completed
          ? const Icon(Icons.check, size: 14, color: Colors.white)
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
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.35)),
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
}

class _TaskSection {
  final String title;
  final String statusLabel;
  final Color statusColor;
  final Color statusTextColor;
  final bool showCompletedButton;
  final List<_TaskItem> tasks;

  const _TaskSection({
    required this.title,
    required this.statusLabel,
    required this.statusColor,
    required this.statusTextColor,
    required this.tasks,
    this.showCompletedButton = false,
  });
}

class _TaskItem {
  final String title;
  final bool completed;

  const _TaskItem({required this.title, this.completed = false});
}
