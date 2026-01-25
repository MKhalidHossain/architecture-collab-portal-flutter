import 'dart:ui';

import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/core/utils/helpers/auth_role.dart';
import 'package:dana_bozzetto/moduls/message/interface/message_interface.dart';
import 'package:dana_bozzetto/moduls/message/model/chat_models.dart';
import 'package:dana_bozzetto/moduls/message/model/create_chat_request_model.dart';
import 'package:dana_bozzetto/moduls/message/presentation/screen/message_body.dart';
import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamTab extends StatefulWidget {
  final List<ProjectTeamMember> teamMembers;
  final String projectId;

  const TeamTab({
    super.key,
    required this.teamMembers,
    required this.projectId,
  });

  @override
  State<TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends State<TeamTab> {
  final Set<String> _loadingUserIds = <String>{};

  Future<void> _createChat(
    BuildContext context, {
    required ProjectTeamMember member,
  }) async {
    final userId = member.user.id.trim();
    final projectIdValue = widget.projectId.trim();
    final currentUserId = await _currentUserId();
    if (userId.isEmpty || projectIdValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID or project ID is missing.')),
      );
      return;
    }
    if (mounted) {
      setState(() => _loadingUserIds.add(userId));
    }
    final messageInterface = Get.find<MessageInterface>();
    ChatModel? chat;
    try {
      final result = await messageInterface.createChat(
        param: CreateChatRequestModel(
          userId: userId,
          projectId: projectIdValue,
        ),
      );
      await result.fold(
        (failure) async {
          chat = await _findExistingChat(
            messageInterface,
            userId: userId,
            projectId: projectIdValue,
            currentUserId: currentUserId,
          );
          if (chat == null) {
            final message = failure.uiMessage.isNotEmpty
                ? failure.uiMessage
                : failure.fullError;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.isNotEmpty ? message : 'Failed')),
            );
          }
        },
        (success) async {
          chat = success.data;
          if (chat == null || chat!.id.isEmpty) {
            chat = await _findExistingChat(
              messageInterface,
              userId: userId,
              projectId: projectIdValue,
              currentUserId: currentUserId,
            );
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() => _loadingUserIds.remove(userId));
      }
    }
    if (chat != null) {
      final preview = _buildPreviewFromChat(
        chat!,
        member,
        currentUserId,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProjectChatScreen(
            chatId: chat!.id,
            title: preview.name,
            avatarUrl: preview.avatarUrl,
            currentUserId: currentUserId,
          ),
        ),
      );
    }
  }

  Future<String> _currentUserId() async {
    final status = await Get.find<AppPigeon>().currentAuth();
    if (status is Authenticated) {
      return status.auth.userId;
    }
    return '';
  }

  Future<ChatModel?> _findExistingChat(
    MessageInterface messageInterface, {
    required String userId,
    required String projectId,
    required String currentUserId,
  }) async {
    final result = await messageInterface.fetchChats();
    ChatModel? chat;
    result.fold((_) {}, (success) {
      final chats = success.data ?? <ChatModel>[];
      for (final item in chats) {
        if (item.projectId.isNotEmpty && item.projectId != projectId) {
          continue;
        }
        final userIds = item.users.map((u) => u.id).toSet();
        if (userIds.contains(userId) &&
            (currentUserId.isEmpty || userIds.contains(currentUserId))) {
          chat = item;
          break;
        }
      }
    });
    return chat;
  }

  _ChatPreview _buildPreviewFromChat(
    ChatModel chat,
    ProjectTeamMember member,
    String currentUserId,
  ) {
    ChatUser? otherUser;
    if (chat.users.isNotEmpty) {
      otherUser = chat.users.firstWhere(
        (user) => currentUserId.isEmpty || user.id != currentUserId,
        orElse: () => chat.users.first,
      );
    }
    final title = chat.chatName.trim().isNotEmpty
        ? chat.chatName.trim()
        : otherUser?.name.trim().isNotEmpty == true
            ? otherUser!.name.trim()
            : member.user.name.trim().isNotEmpty
                ? member.user.name.trim()
                : 'Chat';
    final avatarUrl = otherUser?.avatar.url.isNotEmpty == true
        ? otherUser!.avatar.url
        : member.user.avatar.url;
    return _ChatPreview(
      avatarUrl: avatarUrl,
      name: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.teamMembers.isEmpty) {
      return const Center(
        child: Text(
          "No team members found.",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Project Team",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        ...widget.teamMembers.map(
          (member) {
            final name = member.user.name.trim().isNotEmpty
                ? member.user.name.trim()
                : 'Team Member';
            final role = member.role.trim().isNotEmpty
                ? member.role.trim()
                : member.user.role.trim().isNotEmpty
                    ? member.user.role.trim()
                    : '-';
            final avatarUrl = member.user.avatar.url.trim();
            final isLoading = _loadingUserIds.contains(member.user.id);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _glassCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: _resolveAvatar(avatarUrl),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            role,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: isLoading
                            ? null
                            : () => _createChat(context, member: member),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white70,
                                  ),
                                )
                              : const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                  size: 18,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  ImageProvider _resolveAvatar(String source) {
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return NetworkImage(source);
    }
    if (source.isNotEmpty) {
      return AssetImage(source);
    }
    return const AssetImage('assets/image/aa.png');
  }
}

class _ChatPreview {
  final String avatarUrl;
  final String name;

  const _ChatPreview({
    required this.avatarUrl,
    required this.name,
  });
}
