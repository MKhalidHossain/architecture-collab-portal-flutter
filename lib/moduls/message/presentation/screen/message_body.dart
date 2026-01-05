import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  final List<Map<String, dynamic>> messages = const [
    {
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'name': 'Villa Renovation Team',
      'message': 'Floor Plans Rev. 3 has been.......',
      'time': '2 hour ago',
      'unread': 2,
    },
    {
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'name': 'Villa Renovation Team',
      'message': 'Floor Plans Rev. 3 has been.......',
      'time': '2 hour ago',
      'unread': 2,
    },
    {
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'name': 'Villa Renovation Team',
      'message': 'Floor Plans Rev. 3 has been.......',
      'time': '2 hour ago',
      'unread': 0,
    },
    {
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'name': 'Villa Renovation Team',
      'message': 'Floor Plans Rev. 3 has been.......',
      'time': '2 hour ago',
      'unread': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final msg = messages[index];
            return Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(msg['avatar']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        msg['message'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      msg['time'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    if (msg['unread'] > 0) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg['unread'].toString().padLeft(2, '0'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
