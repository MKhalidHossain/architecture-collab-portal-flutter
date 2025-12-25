import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dana_bozzetto/moduls/notification/presentation/widget/delete_widget.dart';

enum NotificationFilter { all, unread }

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationFilter _selectedFilter = NotificationFilter.all;

  final List<Map<String, dynamic>> _notifications = [
    {
      'icon': Icons.description,
      'color': Colors.blue,
      'title':
          'New document uploaded New document uploaded New document uploaded',
      'subtitle': 'Marketing Plan 2026 has been uploaded',
      'time': '2h ago',
      'isread': true,
    },
    {
      'icon': Icons.design_services,
      'color': Colors.orange,
      'title': 'Approval Required',
      'subtitle':
          'Design Proposal for DeltaDrive Office Headquarters needs your review',
      'time': '2h ago',
      'isread': true,
    },
    {
      'icon': Icons.message,
      'color': Colors.green,
      'title': 'New Message',
      'subtitle':
          'Design Proposal for DeltaDrive Office Comments needs your review',
      'time': '2h ago',
      'isread': false,
    },
    {
      'icon': Icons.check_box_outlined,
      'color': Colors.purple,
      'title': 'Milestone Completed',
      'subtitle': 'Design completed for Modern Villa Design Phase',
      'time': '2h ago',
      'isread': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == NotificationFilter.unread) {
      return _notifications.where((e) => e['isread'] == false).toList();
    }
    return _notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // _notificationsHeader(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: _filteredNotifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _filteredNotifications[index];
                    return NotificationItem(
                      icon: item['icon'],
                      iconColor: item['color'],
                      title: item['title'],
                      subtitle: item['subtitle'],
                      time: item['time'],
                      isread: item['isread'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Header with filter chips
  // Widget _notificationsHeader() {
  //   return _glass(
  //     child: Column(
  //       children: [
  //         _topRow('Notifications'),
  //         const SizedBox(height: 12),
  //         Row(
  //           children: [
  //             _filterChip(
  //               label: 'All',
  //               selected: _selectedFilter == NotificationFilter.all,
  //               onTap: () {
  //                 setState(() {
  //                   _selectedFilter = NotificationFilter.all;
  //                 });
  //               },
  //             ),
  //             const SizedBox(width: 8),
  //             _filterChip(
  //               label: 'Unread',
  //               selected: _selectedFilter == NotificationFilter.unread,
  //               onTap: () {
  //                 setState(() {
  //                   _selectedFilter = NotificationFilter.unread;
  //                 });
  //               },
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selected,
      selectedColor: const Color(0xFF01676C),
      backgroundColor: Colors.white.withOpacity(0.6),
      onSelected: (_) => onTap(),
    );
  }

  /// 🔹 Helpers
  Widget _topRow(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _glass({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// =======================================================
/// 🔔 Notification Item
/// =======================================================

class NotificationItem extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isread;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isread,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.8)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _icon(),
                const SizedBox(width: 8),
                _content(),
                _actions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: widget.iconColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(widget.icon, color: widget.iconColor, size: 24),
    );
  }

  Widget _content() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            firstChild: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            secondChild: Text(
              widget.title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
          const SizedBox(height: 4),
          AnimatedCrossFade(
            firstChild: Text(
              widget.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),
            secondChild: Text(
              widget.subtitle,
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
          const SizedBox(height: 8),
          Text(
            widget.time,
            style:
                TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      children: [
        if (!widget.isread)
          const Icon(Icons.circle, size: 10, color: Color(0xFF01676C)),
        IconButton(
          icon:
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          onPressed: () {
            showDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(0.4),
              builder: (_) => DeleteDialog(
                onConfirm: () => Navigator.pop(context),
              ),
            );
          },
        ),
      ],
    );
  }
}
