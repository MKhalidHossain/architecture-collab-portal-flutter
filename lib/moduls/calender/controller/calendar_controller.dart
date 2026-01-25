import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/model/project_task_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import '../model/calendar_day_model.dart';

class CalendarController extends GetxController {
  final RxList<CalendarDayModel> calendarDays = <CalendarDayModel>[].obs;
  final RxList<ProjectTaskResponseModel> _tasks =
      <ProjectTaskResponseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  DateTime get selectedDate => _selectedDate.value;

  void setSelectedDate(DateTime date) {
    _selectedDate.value = _normalizeDate(date);
    _applyFilter();
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;
    errorMessage.value = '';

    final projectInterface = Get.find<ProjectInterface>();
    List<String> projectIds = <String>[];

    try {
      final projectResult = await projectInterface.fetchProjects();
      projectResult.fold(
        (failure) {
          errorMessage.value = failure.uiMessage.isNotEmpty
              ? failure.uiMessage
              : failure.fullError;
        },
        (success) {
          final projects = success.data?.projects ?? <ProjectResponseModel>[];
          projectIds = projects
              .map((project) => project.id.trim())
              .where((id) => id.isNotEmpty)
              .toList();
        },
      );
    } catch (error) {
      errorMessage.value = error.toString();
    }

    if (projectIds.isEmpty) {
      _tasks.assignAll(<ProjectTaskResponseModel>[]);
      _applyFilter();
      isLoading.value = false;
      return;
    }

    try {
      final results = await Future.wait(
        projectIds
            .map((id) => projectInterface.fetchProjectTasks(projectId: id))
            .toList(),
      );

      final combined = <ProjectTaskResponseModel>[];
      String failureMessage = '';

      for (final result in results) {
        result.fold(
          (failure) {
            if (failureMessage.isEmpty) {
              failureMessage = failure.uiMessage.isNotEmpty
                  ? failure.uiMessage
                  : failure.fullError;
            }
          },
          (success) {
            combined.addAll(success.data ?? <ProjectTaskResponseModel>[]);
          },
        );
      }

      if (combined.isEmpty && failureMessage.isNotEmpty) {
        errorMessage.value = failureMessage;
      }

      _tasks.assignAll(combined);
    } catch (error) {
      errorMessage.value = error.toString();
      _tasks.assignAll(<ProjectTaskResponseModel>[]);
    }

    _applyFilter();
    isLoading.value = false;
  }

  void _applyFilter() {
    final selected = _selectedDate.value;
    final filtered = _tasks
        .where((task) => _matchesDate(task, selected))
        .toList();

    if (filtered.isEmpty) {
      calendarDays.clear();
      return;
    }

    filtered.sort((a, b) {
      final aDate = a.startDate ?? a.endDate ?? a.createdAt ?? a.updatedAt;
      final bDate = b.startDate ?? b.endDate ?? b.createdAt ?? b.updatedAt;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return aDate.compareTo(bDate);
    });

    calendarDays.assignAll(
      filtered.map((task) => _mapTaskToDay(task)).toList(),
    );
  }

  CalendarDayModel _mapTaskToDay(ProjectTaskResponseModel task) {
    final primaryDate =
        task.startDate ?? task.endDate ?? task.createdAt ?? task.updatedAt;
    final safeDate = primaryDate != null
        ? _normalizeDate(primaryDate)
        : _selectedDate.value;
    final projectName = task.projectName.isNotEmpty
        ? task.projectName
        : (task.projectId.isNotEmpty ? 'Project' : '');
    final taskName = task.name.isNotEmpty ? task.name : 'Task';

    return CalendarDayModel(
      day: _weekdayLabel(safeDate),
      date: safeDate.day,
      title: projectName,
      task: taskName,
      color: _taskColor(task),
    );
  }

  bool _matchesDate(ProjectTaskResponseModel task, DateTime selected) {
    final start = task.startDate ?? task.createdAt ?? task.updatedAt;
    if (start == null) return false;
    final normalizedStart = _normalizeDate(start);
    final endDate = task.endDate ?? start;
    final normalizedEnd = _normalizeDate(endDate);
    if (selected.isBefore(normalizedStart)) return false;
    if (selected.isAfter(normalizedEnd)) return false;
    return true;
  }

  DateTime _normalizeDate(DateTime date) {
    final localDate = date.isUtc ? date.toLocal() : date;
    return DateTime(localDate.year, localDate.month, localDate.day);
  }

  String _weekdayLabel(DateTime date) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[date.weekday - 1];
  }

  Color _taskColor(ProjectTaskResponseModel task) {
    final status = task.status.toLowerCase();
    if (status.contains('approval')) {
      return Colors.teal;
    }
    if (status.contains('complete')) {
      return Colors.green;
    }
    if (status.contains('pending')) {
      return Colors.orange;
    }
    final priority = task.priority.toLowerCase();
    if (priority == 'high') {
      return Colors.redAccent;
    }
    if (priority == 'medium') {
      return Colors.orangeAccent;
    }
    return Colors.blueGrey;
  }
}
