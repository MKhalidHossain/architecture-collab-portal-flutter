import 'package:dana_bozzetto/moduls/calender/controller/calendar_controller.dart';
import 'package:dana_bozzetto/moduls/calender/model/calendar_day_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CalendarController controller =
        Get.put(CalendarController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: controller.calendarDays.length,
          itemBuilder: (context, index) {
            return CalendarRow(
              item: controller.calendarDays[index],
            );
          },
        ),
      ),
    );
  }
}

/// ===============================
/// CALENDAR ROW
/// ===============================
class CalendarRow extends StatelessWidget {
  final CalendarDayModel item;

  const CalendarRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DATE COLUMN
          SizedBox(
            width: 52,
            child: Column(
              children: [
                Text(
                  item.day,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.date.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// TASK OR EMPTY
          Expanded(
            child: item.task == null
                ? const SizedBox(height: 58) // BLANK DAY
                : Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.task!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
