import 'package:flutter/material.dart';

class CalendarDayModel {
  final String day;
  final int date;
  final String? title;
  final String? task;
  final Color? color;

  CalendarDayModel({
    required this.day,
    required this.date,
    this.title,
    this.task,
    this.color,
  });
}
