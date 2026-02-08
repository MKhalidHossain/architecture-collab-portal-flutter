import 'dart:ui';
import 'package:dana_bozzetto/moduls/notification/controller/notification_controller.dart';
import 'package:dana_bozzetto/moduls/notification/model/notification_response_model.dart';
import 'package:dana_bozzetto/moduls/notification/presentation/widget/delete_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum NotificationFilter { all, unread }

class NotificationScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final bool showBackground;

  const NotificationScreen({
    super.key,
    this.onBack,
    this.showBackground = false,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationFilter _selectedFilter = NotificationFilter.all;
  late final NotificationController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<NotificationController>()) {
      _controller = Get.find<NotificationController>();
    } else {
      _controller = Get.put(NotificationController());
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      Get.delete<NotificationController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          if (widget.showBackground) _background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _notificationsHeader(),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Obx(() {
                      final items = _filteredNotifications(
                        _controller.notifications.toList(),
                      );
                      if (_controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (_controller.errorMessage.value.isNotEmpty) {
                        return _errorState(_controller.errorMessage.value);
                      }
                      if (items.isEmpty) {
                        return _emptyState();
                      }
                      return RefreshIndicator(
                        onRefresh: _controller.fetchNotifications,
                        color: const Color(0xFF01676C),
                        child: ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return NotificationItem(
                              item: item,
                              timeLabel: _formatTimeAgo(item.createdAt),
                              onMarkRead: () =>
                                  _controller.markNotificationRead(item.id),
                              onDelete: () =>
                                  _controller.deleteNotification(item.id),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/ab.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  List<NotificationItemModel> _filteredNotifications(
    List<NotificationItemModel> items,
  ) {
    if (_selectedFilter == NotificationFilter.unread) {
      return items.where((item) => !item.isRead).toList();
    }
    return items;
  }

  Widget _notificationsHeader() {
    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.of(context).maybePop();
                  }
                },
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // IconButton(
              //   onPressed: _controller.markAllRead,
              //   icon: const Icon(Icons.checklist, color: Colors.white),
              //   tooltip: 'Mark all as read',
              // ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            final unread = _controller.unreadCount.value;
            final total = _controller.notifications.length;
            return Row(
              children: [
                _filterChip(
                  label: 'All',
                  count: total,
                  selected: _selectedFilter == NotificationFilter.all,
                  onTap: () {
                    setState(() {
                      _selectedFilter = NotificationFilter.all;
                    });
                  },
                ),
                const SizedBox(width: 8),
                _filterChip(
                  label: 'Unread',
                  count: unread,
                  selected: _selectedFilter == NotificationFilter.unread,
                  onTap: () {
                    setState(() {
                      _selectedFilter = NotificationFilter.unread;
                    });
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required int count,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final background = selected
        ? const Color(0xFF01676C)
        : Colors.white.withOpacity(0.7);
    final textColor = selected ? Colors.white : Colors.black87;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF01676C) : Colors.white60,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text(
        'No notifications yet.',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _errorState(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  String _formatTimeAgo(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final diff = now.difference(time);
    final duration = diff.isNegative ? diff.abs() : diff;
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s ago';
    }
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    }
    if (duration.inHours < 24) {
      return '${duration.inHours}h ago';
    }
    if (duration.inDays < 7) {
      return '${duration.inDays}d ago';
    }
    return '${time.month}/${time.day}/${time.year}';
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
  final NotificationItemModel item;
  final String timeLabel;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  const NotificationItem({
    super.key,
    required this.item,
    required this.timeLabel,
    required this.onMarkRead,
    required this.onDelete,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.55)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _icon(),
              const SizedBox(width: 10),
              _content(),
              _actions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    final style = _typeStyle(widget.item.type);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: style.color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(style.icon, color: style.color, size: 22),
    );
  }

  Widget _content() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.type.isNotEmpty ? widget.item.type : 'Notification',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.item.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white.withOpacity(0.9)),
          ),
          const SizedBox(height: 8),
          Text(
            widget.timeLabel,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      children: [
        if (!widget.item.isRead)
          const Icon(Icons.circle, size: 10, color: Color(0xFF01676C)),
        PopupMenuButton<_NotificationAction>(
          icon: const Icon(Icons.more_vert, color: Colors.white, size: 18),
          color: Colors.white,
          onSelected: (action) {
            switch (action) {
              case _NotificationAction.markRead:
                widget.onMarkRead();
                break;
              case _NotificationAction.delete:
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.45),
                  builder: (_) => DeleteDialog(onConfirm: widget.onDelete),
                );
                break;
            }
          },
          itemBuilder: (_) => [
            if (!widget.item.isRead)
              const PopupMenuItem(
                value: _NotificationAction.markRead,
                child: Text('Mark as read'),
              ),
            const PopupMenuItem(
              value: _NotificationAction.delete,
              child: Text('Delete Notification'),
            ),
          ],
        ),
      ],
    );
  }
}

enum _NotificationAction { markRead, delete }

class _NotificationTypeStyle {
  final IconData icon;
  final Color color;

  const _NotificationTypeStyle(this.icon, this.color);
}

_NotificationTypeStyle _typeStyle(String type) {
  switch (type.toLowerCase()) {
    case 'approval request':
      return const _NotificationTypeStyle(Icons.check_circle, Colors.orange);
    case 'task submitted':
      return const _NotificationTypeStyle(
        Icons.assignment_turned_in,
        Colors.teal,
      );
    case 'new message':
      return const _NotificationTypeStyle(Icons.chat_bubble, Colors.green);
    case 'milestone completed':
      return const _NotificationTypeStyle(Icons.flag, Colors.purple);
    case 'new document uploaded':
      return const _NotificationTypeStyle(Icons.description, Colors.cyan);
    default:
      return const _NotificationTypeStyle(Icons.notifications, Colors.blueGrey);
  }
}
