import 'dart:async';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/core/utils/helpers/auth_role.dart';
import 'package:dana_bozzetto/moduls/message/controller/chats_controller.dart';
import 'package:dana_bozzetto/moduls/message/model/chat_models.dart';
import 'package:dana_bozzetto/moduls/message/model/message_model.dart';
import 'package:dana_bozzetto/moduls/message/interface/message_interface.dart';
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
      await Get.find<AppPigeon>().socketInit(
        SocketConnetParamX(
          token: null,
          socketUrl: ApiEndpoints.socketUrl,
          joinId: _currentUserId,
        ),
      );
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
    final latestTime =
        chat.latestMessage?.createdAt ?? chat.updatedAt ?? chat.createdAt;
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
        final showError =
            _controller.errorMessage.isNotEmpty && threads.isEmpty;

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
                        child: CircularProgressIndicator(color: Colors.white70),
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
                                      chatId: thread.chatId,
                                      title: thread.name,
                                      avatarUrl: thread.avatarUrl,
                                      currentUserId: _currentUserId,
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
    required this.chatId,
    required this.title,
    required this.avatarUrl,
    required this.currentUserId,
  });

  final String chatId;
  final String title;
  final String avatarUrl;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return _ProjectChatBody(
      chatId: chatId,
      title: title,
      avatarUrl: avatarUrl,
      currentUserId: currentUserId,
    );
  }
}

class _ProjectChatBody extends StatefulWidget {
  const _ProjectChatBody({
    required this.chatId,
    required this.title,
    required this.avatarUrl,
    required this.currentUserId,
  });

  final String chatId;
  final String title;
  final String avatarUrl;
  final String currentUserId;

  @override
  State<_ProjectChatBody> createState() => _ProjectChatBodyState();
}

class _ProjectChatBodyState extends State<_ProjectChatBody> {
  final List<_ChatMessage> _messages = <_ChatMessage>[];
  final Set<String> _messageIds = <String>{};
  final TextEditingController _composerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<MessageModel>? _messageSubscription;
  bool _isLoadingHistory = false;

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
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.22)),
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
  void initState() {
    super.initState();
    _ensureSocketConnected();
    if (widget.chatId.isNotEmpty) {
      Get.find<AppPigeon>().emit('join chat', widget.chatId);
    }
    _loadHistory();
    _messageSubscription = Get.find<MessageInterface>()
        .subscribeToMessages()
        .listen(_handleMessage);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _ensureSocketConnected() async {
    await Get.find<AppPigeon>().socketInit(
      SocketConnetParamX(
        token: null,
        socketUrl: ApiEndpoints.socketUrl,
        joinId: widget.currentUserId,
      ),
    );
  }

  @override
  void dispose() {
    if (widget.chatId.isNotEmpty) {
      Get.find<AppPigeon>().emit('leave chat', widget.chatId);
    }
    _messageSubscription?.cancel();
    _composerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleMessage(MessageModel message) {
    if (message.chatId != widget.chatId || message.content.isEmpty) {
      return;
    }
    if (message.id.isNotEmpty && _messageIds.contains(message.id)) {
      return;
    }
    if (message.id.isNotEmpty) {
      _messageIds.add(message.id);
    }
    final isMe =
        widget.currentUserId.isNotEmpty &&
        widget.currentUserId == message.senderId;
    if (isMe) {
      final localIndex = _messages.indexWhere(
        (item) =>
            item.id.startsWith('local-') &&
            item.isMe &&
            item.text == message.content,
      );
      if (localIndex != -1) {
        setState(() {
          _messages[localIndex] = _ChatMessage(
            id: message.id,
            sender: message.senderName,
            avatarUrl: message.senderAvatarUrl,
            text: message.content,
            time: _formatTime(message.createdAt),
            isMe: isMe,
            createdAt: message.createdAt,
          );
          _sortMessages();
        });
        _scrollToBottom();
        return;
      }
    }
    setState(() {
      _messages.add(
        _ChatMessage(
          id: message.id,
          sender: message.senderName,
          avatarUrl: message.senderAvatarUrl,
          text: message.content,
          time: _formatTime(message.createdAt),
          isMe: isMe,
          createdAt: message.createdAt,
        ),
      );
      _sortMessages();
    });
    _scrollToBottom();
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Future<void> _loadHistory() async {
    if (_isLoadingHistory || widget.chatId.isEmpty) return;
    _isLoadingHistory = true;
    final result = await Get.find<MessageInterface>().fetchMessages(
      chatId: widget.chatId,
    );
    if (!mounted) return;
    result.fold(
      (_) {
        _isLoadingHistory = false;
      },
      (success) {
        final history = success.data ?? <MessageModel>[];
        bool didAdd = false;
        for (final message in history) {
          if (message.chatId != widget.chatId || message.content.isEmpty) {
            continue;
          }
          if (message.id.isNotEmpty && _messageIds.contains(message.id)) {
            continue;
          }
          if (message.id.isNotEmpty) {
            _messageIds.add(message.id);
          }
          final isMe =
              widget.currentUserId.isNotEmpty &&
              widget.currentUserId == message.senderId;
          _messages.add(
            _ChatMessage(
              id: message.id,
              sender: message.senderName,
              avatarUrl: message.senderAvatarUrl,
              text: message.content,
              time: _formatTime(message.createdAt),
              isMe: isMe,
              createdAt: message.createdAt,
            ),
          );
          didAdd = true;
        }
        if (didAdd) {
          setState(() => _sortMessages());
          _scrollToBottom();
        }
        _isLoadingHistory = false;
      },
    );
  }

  void _sortMessages() {
    _messages.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
  }

  void _sendMessage() {
    final text = _composerController.text.trim();
    if (text.isEmpty || widget.chatId.isEmpty) return;

    final now = DateTime.now();
    final localId = 'local-${now.microsecondsSinceEpoch}';
    setState(() {
      _messages.add(
        _ChatMessage(
          id: localId,
          sender: '',
          avatarUrl: '',
          text: text,
          time: _formatTime(now),
          isMe: true,
          createdAt: now,
        ),
      );
      _sortMessages();
    });
    _scrollToBottom();
    _composerController.clear();

    Get.find<AppPigeon>().emit('message:send', {
      'chatId': widget.chatId,
      'content': text,
      'attachments': [],
      'replyTo': null,
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
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
                  title: widget.title,
                  avatarUrl: widget.avatarUrl,
                  onMenuTap: () => _showChatMenu(context),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    reverse: true,
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
                        duration: Duration(milliseconds: 160 + index * 20),
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
                _ChatComposer(
                  controller: _composerController,
                  onSend: _sendMessage,
                ),
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
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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

  ImageProvider _resolveAvatar() {
    if (message.avatarUrl.startsWith('http://') ||
        message.avatarUrl.startsWith('https://')) {
      return NetworkImage(message.avatarUrl);
    }
    return const AssetImage('assets/image/aa.png');
  }

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
                    CircleAvatar(radius: 14, backgroundImage: _resolveAvatar()),
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
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: _roundIcon(
              icon: Icons.attach_file,
              backgroundColor: Colors.white.withOpacity(0.9),
              iconColor: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onSend,
            borderRadius: BorderRadius.circular(24),
            child: _roundIcon(
              icon: Icons.send_rounded,
              backgroundColor: const Color(0xFF0E7A73),
              iconColor: Colors.white,
            ),
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
  final String id;
  final String sender;
  final String avatarUrl;
  final String text;
  final String time;
  final bool isMe;
  final DateTime? createdAt;

  const _ChatMessage({
    required this.id,
    required this.sender,
    required this.avatarUrl,
    required this.text,
    required this.time,
    required this.isMe,
    required this.createdAt,
  });
}
