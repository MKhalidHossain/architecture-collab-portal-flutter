import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/presentation/screen/documents_screen.dart';
import 'package:flutter/material.dart';
import 'package:dana_bozzetto/moduls/home/common/project_cart.dart';
import 'package:dana_bozzetto/moduls/home/model/project_cart_model.dart';

class HomeScreenT extends StatelessWidget {
  HomeScreenT({super.key});

  final List<ProjectModel> projects = [
    ProjectModel(
      id: '1',
      image: 'assets/image/aa.png',
      status: 'Active',
      isActive: true,
      title: 'Luxury Villa - Malibu',
      subtitle: 'Smith Residence',
      deadline: DateTime(2025, 12, 1),
      currentMilestone: 2,
      totalMilestones: 4,
      steps: [
        ProjectStep(label: 'PD', completed: true),
        ProjectStep(label: 'SD', completed: true),
        ProjectStep(label: 'DD', completed: false),
        ProjectStep(label: 'CD', completed: false),
      ],
      teamAvatars: [
        'assets/avatars/user1.jpg',
        'assets/avatars/user2.jpg',
        'assets/avatars/user3.jpg',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Projects Overview'),
          const SizedBox(height: 12),

          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _OverviewCard(
                  title: 'Active Projects',
                  value: '03',
                  icon: Icons.folder_open,
                ),
                _OverviewCard(
                  title: 'Pending Projects',
                  value: '02',
                  icon: Icons.pending_actions,
                ),
                _OverviewCard(
                  title: 'Documents',
                  value: '24',
                  icon: Icons.description,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          _sectionHeader('New Projects'),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              return ProjectCard(project: projects[index]);
            },
          ),

          const SizedBox(height: 20),

          _sectionHeader('Quick Action'),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            children: [
              QuickAction(
                icon: Icons.description_outlined,
                title: 'Documents',
                number: '08',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DocumentsScreen(),
                    ),
                  );
                },
              ),
              QuickAction(
                icon: Icons.fact_check_outlined,
                title: 'Approvals',
                number: '12',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Approvals opened')),
                  );
                },
              ),
              QuickAction(
                icon: Icons.payments_outlined,
                title: 'Finance',
                number: '03',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Finance opened')),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 22),

          _sectionHeader('Recent Activity'),
          const SizedBox(height: 12),

          const Column(
            children: [
              ActivityTile(
                title: "New document uploaded: Floor Plans",
                subtitle: "Rev. 3",
                time: "2h ago",
                bulletColor: Colors.cyanAccent,
              ),
              ActivityTile(
                title: "Approval required: Design Proposal",
                subtitle: "5h ago",
                time: "5h ago",
                bulletColor: Colors.amberAccent,
              ),
              ActivityTile(
                title: "New message from Sarah Johnson",
                subtitle: "1d ago",
                time: "1d ago",
                bulletColor: Colors.white70,
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.white70),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _OverviewCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4AA).withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Icon(icon, color: const Color(0xFF00D4AA), size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String number;
  final String title;
  final VoidCallback? onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.number,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4AA).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF00D4AA), size: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
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

class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Color bulletColor;
  final bool showDivider;

  const ActivityTile({
    required this.title,
    required this.subtitle,
    required this.time,
    this.bulletColor = Colors.white70,
    this.showDivider = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6, right: 12),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: bulletColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ],
          ),
        ),
        if (showDivider)
          const SizedBox(height: 10),
      ],
    );
  }
}
