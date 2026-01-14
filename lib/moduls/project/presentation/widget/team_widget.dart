import 'dart:ui';

import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import 'package:flutter/material.dart';

class TeamTab extends StatelessWidget {
  final List<ProjectTeamMember> teamMembers;

  const TeamTab({super.key, required this.teamMembers});

  @override
  Widget build(BuildContext context) {
    if (teamMembers.isEmpty) {
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

        ...teamMembers.map(
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
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 18,
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
