import 'dart:ui';

import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/core/utils/helpers/auth_role.dart';
import 'package:dana_bozzetto/moduls/message/controller/chats_controller.dart';
import 'package:dana_bozzetto/moduls/message/model/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late final ChatsController _controller;
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    _controller = ChatsController();
    _controller.fetchChats();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final status = await Get.find<AppPigeon>().currentAuth();
    if (!mounted) return;
    if (status is Authenticated) {
      setState(() => _currentUserId = status.auth.userId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  ChatUser? _resolveOtherUser(ChatModel chat) {
    if (chat.users.isEmpty) return null;
    if (_currentUserId.isEmpty) return chat.users.first;
    final other = chat.users.firstWhere(
      (user) => user.id != _currentUserId,
      orElse: () => chat.users.first,
    );
    return other;
  }

  _ThreadPreview _buildThreadPreview(ChatModel chat) {
    final otherUser = _resolveOtherUser(chat);
    final name = otherUser?.name.trim().isNotEmpty == true
        ? otherUser!.name.trim()
        : chat.chatName.trim().isNotEmpty
            ? chat.chatName.trim()
            : 'Chat';
    final avatarUrl = otherUser?.avatar.url ?? '';
    final latestText = chat.latestMessage?.content ?? 'No messages yet';
    final latestTime = chat.latestMessage?.createdAt ?? chat.updatedAt ?? chat.createdAt;
    return _ThreadPreview(
      chatId: chat.id,
      avatarUrl: avatarUrl,
      name: name,
      message: latestText,
      time: _formatTimeAgo(latestTime),
      unread: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final threads = _controller.chats.map(_buildThreadPreview).toList();
        final showLoading = _controller.isLoading && threads.isEmpty;
        final showError = _controller.errorMessage.isNotEmpty && threads.isEmpty;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x996F6E6E),
                  Color(0xAA5A5959),
                  Color(0xCC3A3939),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.18),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (showLoading)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white70,
                        ),
                      ),
                    )
                  else if (showError)
                    Expanded(
                      child: Center(
                        child: Text(
                          _controller.errorMessage,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(18, 6, 18, 24),
                        itemCount: threads.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final thread = threads[index];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 320 + index * 70),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 12 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: _MessageThreadTile(
                              thread: thread,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProjectChatScreen(
                                      title: thread.name,
                                      avatarUrl: thread.avatarUrl,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MessageThreadTile extends StatelessWidget {
  const _MessageThreadTile({required this.thread, required this.onTap});

  final _ThreadPreview thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(20)),
          ),
          child: Row(
            children: [
              _AvatarRing(imageUrl: thread.avatarUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      thread.message,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    thread.time,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 12,
                    ),
                  ),
                  if (thread.unread > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9483F),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        thread.unread.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarRing extends StatelessWidget {
  const _AvatarRing({required this.imageUrl});

  final String imageUrl;

  ImageProvider _resolveImage() {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    }
    return const AssetImage('assets/image/aa.png');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(radius: 26, backgroundImage: _resolveImage()),
    );
  }
}

class ProjectChatScreen extends StatelessWidget {
  const ProjectChatScreen({
    super.key,
    required this.title,
    required this.avatarUrl,
  });

  final String title;
  final String avatarUrl;

  static const List<_ChatMessage> _messages = [
    _ChatMessage(
      sender: 'Sarah Mitchell',
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      text: 'Hey, I just uploaded the latest floor plans',
      time: '10:30 AM',
      isMe: false,
    ),
    _ChatMessage(
      sender: '',
      avatarUrl: '',
      text: 'Hey, I just uploaded the latest floor plans',
      time: '10:30 AM',
      isMe: true,
    ),
    _ChatMessage(
      sender: 'Sarah Mitchell',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      text: 'Hey, I just uploaded the latest floor plans',
      time: '10:30 AM',
      isMe: false,
    ),
    _ChatMessage(
      sender: '',
      avatarUrl: '',
      text: 'Hey, I just uploaded the latest floor plans',
      time: '10:30 AM',
      isMe: true,
    ),
  ];

  void _showChatMenu(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Chat Menu',
      barrierColor: Colors.black.withOpacity(0.12),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 16, 0),
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 240,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.22),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          _MenuOption(text: 'Mute Notifications'),
                          _MenuOption(text: 'Clear Chat'),
                          _MenuOption(text: 'Media, Links, and Docs'),
                          _MenuOption(text: 'Reports'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/ab.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x996F6E6E),
                    Color(0xAA5A5959),
                    Color(0xCC3A3939),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _ChatHeader(
                  title: title,
                  avatarUrl: avatarUrl,
                  onMenuTap: () => _showChatMenu(context),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    itemCount: _messages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 280 + index * 60),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 10 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: _ChatBubble(message: message),
                      );
                    },
                  ),
                ),
                const _ChatComposer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.title,
    required this.avatarUrl,
    required this.onMenuTap,
  });

  final String title;
  final String avatarUrl;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
                _AvatarRing(imageUrl: avatarUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Project Chat',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onMenuTap,
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuOption extends StatelessWidget {
  const _MenuOption({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.white.withOpacity(0.14)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.74;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(22),
      topRight: const Radius.circular(22),
      bottomLeft: Radius.circular(message.isMe ? 22 : 6),
      bottomRight: Radius.circular(message.isMe ? 6 : 22),
    );

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(message.isMe ? 0.2 : 0.16),
                borderRadius: borderRadius,
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe) ...[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(message.avatarUrl),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            message.sender,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    message.text,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.time,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      if (message.isMe)
                        const Icon(
                          Icons.done_all,
                          size: 18,
                          color: Color(0xFF28B6A5),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          _roundIcon(
            icon: Icons.attach_file,
            backgroundColor: Colors.white.withOpacity(0.9),
            iconColor: Colors.black87,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _roundIcon(
            icon: Icons.send_rounded,
            backgroundColor: const Color(0xFF0E7A73),
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _roundIcon({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: backgroundColor,
      child: Icon(icon, color: iconColor),
    );
  }
}

class _ThreadPreview {
  final String chatId;
  final String avatarUrl;
  final String name;
  final String message;
  final String time;
  final int unread;

  const _ThreadPreview({
    required this.chatId,
    required this.avatarUrl,
    required this.name,
    required this.message,
    required this.time,
    required this.unread,
  });
}

class _ChatMessage {
  final String sender;
  final String avatarUrl;
  final String text;
  final String time;
  final bool isMe;

  const _ChatMessage({
    required this.sender,
    required this.avatarUrl,
    required this.text,
    required this.time,
    required this.isMe,
  });
}
