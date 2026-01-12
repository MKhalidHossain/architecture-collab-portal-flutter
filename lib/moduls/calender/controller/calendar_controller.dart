import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/calendar_day_model.dart';

class CalendarController extends GetxController {
  final RxList<CalendarDayModel> calendarDays =
      <CalendarDayModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    calendarDays.addAll([
      CalendarDayModel(
        day: "Wed",
        date: 1,
        title: "Modern villa Design",
        task: "Pre-Design Survey",
        color: Colors.blue,
      ),
      CalendarDayModel(
        day: "Thu",
        date: 2,
        title: "Modern villa Design",
        task: "Pre-Design Measuring Building",
        color: Colors.blue,
      ),
      CalendarDayModel(
        day: "Fri",
        date: 3,
        title: "Modern villa Design",
        task: "Pre-Design Drawing Existing Condition",
        color: Colors.blue,
      ),

      CalendarDayModel(day: "Sat", date: 4),
      CalendarDayModel(day: "Sun", date: 5),

      CalendarDayModel(
        day: "Mon",
        date: 6,
        title: "Modern villa Design",
        task: "SD – Preliminary Floor Plan",
        color: Colors.orange,
      ),
      CalendarDayModel(
        day: "Tue",
        date: 7,
        title: "Modern villa Design",
        task: "SD – Preliminary Elevation",
        color: Colors.orange,
      ),
      CalendarDayModel(
        day: "Wed",
        date: 8,
        title: "Modern villa Design",
        task: "SD – Preliminary 3D View",
        color: Colors.orange,
      ),

      CalendarDayModel(
        day: "Thu",
        date: 9,
        title: "Modern villa Design",
        task: "DD – Made Floor Plan",
        color: Colors.teal,
      ),
      CalendarDayModel(
        day: "Fri",
        date: 10,
        title: "Modern villa Design",
        task: "DD – Made Elevation",
        color: Colors.teal,
      ),

      CalendarDayModel(day: "Sat", date: 11),
      CalendarDayModel(day: "Sun", date: 12),

      CalendarDayModel(
        day: "Mon",
        date: 13,
        title: "Modern villa Design",
        task: "CD – Made Floor Plan",
        color: Colors.grey,
      ),
      CalendarDayModel(
        day: "Tue",
        date: 14,
        title: "Modern villa Design",
        task: "CD – Made Elevation",
        color: Colors.grey,
      ),
      CalendarDayModel(
        day: "Wed",
        date: 15,
        title: "Modern villa Design",
        task: "CD – Define Structural",
        color: Colors.grey,
      ),
      CalendarDayModel(
        day: "Thu",
        date: 16,
        title: "Modern villa Design",
        task: "CD – Building Sections",
        color: Colors.grey,
      ),
    ]);
  }

  /// ADMIN: add task later
  void addTask(CalendarDayModel day) {
    calendarDays.add(day);
  }
}
