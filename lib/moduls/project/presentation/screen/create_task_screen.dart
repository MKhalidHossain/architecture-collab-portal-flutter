import 'dart:ui';

import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/core/utils/helpers/auth_role.dart';
import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/model/create_task_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color _accentColor = Color(0xFF0C7A7E);

class CreateTaskScreen extends StatefulWidget {
  final String? initialStage;
  final String projectId;
  final String milestoneId;

  const CreateTaskScreen({
    super.key,
    this.initialStage,
    required this.projectId,
    required this.milestoneId,
  });

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _descriptionController =
      TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  String _formatDate(DateTime? value) {
    if (value == null) return 'Dec 01, 2025';
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
    final month = months[value.month - 1];
    return '$month ${value.day.toString().padLeft(2, '0')}, ${value.year}';
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final name = _descriptionController.text.trim();
    if (name.isEmpty) {
      _showMessage('Please add a task description.');
      return;
    }
    if (_startDate == null || _endDate == null) {
      _showMessage('Please select start and end dates.');
      return;
    }
    if (widget.projectId.trim().isEmpty ||
        widget.milestoneId.trim().isEmpty) {
      _showMessage('Project or milestone is missing.');
      return;
    }

    final authStatus = await Get.find<AppPigeon>().currentAuth();
    if (!mounted) return;
    final assignedTo =
        authStatus is Authenticated ? authStatus.auth.userId : '';
    if (assignedTo.isEmpty) {
      _showMessage('Unable to detect user.');
      return;
    }

    setState(() => _isSubmitting = true);
    final param = CreateTaskRequestModel(
      name: name,
      projectId: widget.projectId,
      milestoneId: widget.milestoneId,
      assignedTo: assignedTo,
      priority: 'High',
      startDate: _startDate!,
      endDate: _endDate!,
      status: 'Pending',
    );

    final result =
        await Get.find<ProjectInterface>().createTask(param: param);
    if (!mounted) return;
    result.fold(
      (failure) {
        _showMessage(
          failure.uiMessage.isNotEmpty
              ? failure.uiMessage
              : failure.fullError,
        );
      },
      (_) {
        final stage = widget.initialStage?.trim() ?? '';
        _showMessage(
          stage.isNotEmpty ? 'Task added to $stage.' : 'Task added.',
        );
        Navigator.pop(context, true);
      },
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            'assets/image/ab.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Create New Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Create new Task with fill those information.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Start Date',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _dateField(
                    label: _formatDate(_startDate),
                    onTap: () => _pickDate(isStart: true),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'End Date',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _dateField(
                    label: _formatDate(_endDate),
                    onTap: () => _pickDate(isStart: false),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Task Description',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _descriptionField(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _ghostButton(
                          label: 'Cancel',
                          icon: Icons.close,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _primaryButton(
                          label: 'Add Task',
                          onTap: _isSubmitting ? () {} : _submit,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateField({required String label, required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white70,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _descriptionField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 140,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Add any additional notes or comments...',
              hintStyle: TextStyle(color: Colors.white60, fontSize: 13),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _ghostButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _primaryButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: _accentColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
