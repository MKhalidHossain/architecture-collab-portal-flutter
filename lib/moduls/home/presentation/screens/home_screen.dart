import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/presentation/screen/documents_screen.dart';
import 'package:flutter/material.dart';
import 'package:dana_bozzetto/moduls/home/common/project_cart.dart';
import 'package:dana_bozzetto/moduls/home/model/project_cart_model.dart';

class HomeScreenT extends StatelessWidget {
  HomeScreenT({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          /// Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/ab.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  const Text(
                    'Projects Overview',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 12),

                  /// Overview Cards
                  SizedBox(
                    height: 150,
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

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      return ProjectCard(project: projects[index]);
                    },
                  ),

                  /// Quick Action
                  const Text(
                    'Quick Action',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 160 / 120,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      QuickAction(
                        icon: Icons.home,
                        title: 'Home Services',
                        number: '03',
                        onTap: () {
                          // Home Services action
                        },
                      ),
                      QuickAction(
                        icon: Icons.car_repair,
                        title: 'Car Repair',
                        number: '12',
                        onTap: () {
                          // Car Repair action
                        },
                      ),
                      QuickAction(
                        icon: Icons.description, // Documents
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
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Recent Activity
                  const Text(
                    'Recent Activity',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
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
            ),
          ),
        ],
      ),
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
      width: 160,
      height: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.tealAccent),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
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
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: Colors.tealAccent, size: 32),
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
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.12),
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
          Divider(
            height: 1,
            thickness: 1.2,
            color: Colors.white.withOpacity(0.98),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
