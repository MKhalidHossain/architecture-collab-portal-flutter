import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/presentation/screen/documents_screen.dart';
import 'package:flutter/material.dart';
import 'package:dana_bozzetto/moduls/home/common/project_cart.dart';
import 'package:dana_bozzetto/moduls/home/model/project_cart_model.dart';

class HomeScreenT extends StatefulWidget {
  const HomeScreenT({super.key});

  @override
  State<HomeScreenT> createState() => _HomeScreenTState();
}

class _HomeScreenTState extends State<HomeScreenT> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();
  final ScrollController _newProjectsController = ScrollController();

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset - 160,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset + 160,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollLeftNewProjects() {
    if (_newProjectsController.hasClients) {
      _newProjectsController.animateTo(
        _newProjectsController.offset - 160,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollRightNewProjects() {
    if (_newProjectsController.hasClients) {
      _newProjectsController.animateTo(
        _newProjectsController.offset + 160,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _newProjectsController.dispose();
    super.dispose();
  }

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
    ProjectModel(
      id: '2',
      image: 'assets/image/aa.png',
      status: 'Active',
      isActive: true,
      title: 'Beach House Renovation',
      subtitle: 'Johnson Residence',
      deadline: DateTime(2025, 12, 15),
      currentMilestone: 1,
      totalMilestones: 3,
      steps: [
        ProjectStep(label: 'PD', completed: true),
        ProjectStep(label: 'SD', completed: false),
        ProjectStep(label: 'DD', completed: false),
      ],
      teamAvatars: ['assets/avatars/user4.jpg', 'assets/avatars/user5.jpg'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/ab.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Projects Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            ),
                            onPressed: _scrollLeft,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            ),
                            onPressed: _scrollRight,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 135,
                    child: ListView(
                      controller: _scrollController,
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'New Projects',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            ),
                            onPressed: _scrollLeftNewProjects,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            ),
                            onPressed: _scrollRightNewProjects,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 585,
                    child: ListView.builder(
                      controller: _newProjectsController,
                      scrollDirection: Axis.horizontal,
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 360,
                          margin: const EdgeInsets.only(right: 16),
                          child: ProjectCard(project: projects[index]),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Quick Action',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
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
                        icon: Icons.description,
                        title: 'Documents',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DocumentsScreen(),
                            ),
                          );
                        },
                      ),
                      QuickAction(
                        icon: Icons.home,
                        title: 'Home Services',
                        onTap: () {},
                      ),
                      QuickAction(
                        icon: Icons.car_repair,
                        title: 'Car Repair',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // ===== Recent Activity =====
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

// ===== Overview Card =====
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
      width: 165,
      height: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF747572),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white60, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF01676C),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
          ),
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
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const QuickAction({
    super.key,
    required this.icon,
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
                color: const Color(0xFF747572),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white60, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: const Color(0xFF01676C),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(icon, color: Colors.white, size: 32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 6, right: 12),
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
