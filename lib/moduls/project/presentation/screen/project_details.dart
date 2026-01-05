import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/presentation/widget/mileston_widget.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/overview_widget.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/team_widget.dart';
import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  int _selectedTab = 0;
  final bool isClient = true;

  @override
  Widget build(BuildContext context) {
    final tabs = _tabsList();

    return Scaffold(
      body: Column(
        children: [
          _header(context, tabs),
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  'assets/image/ab.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildTabContent(tabs),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB LIST =================

  List<String> _tabsList() {
    return [
      "Overview",
      if (!isClient) "Tasks", // ✅ only for team member
      "Team",
      "Milestones",
    ];
  }

  // ================= TAB CONTENT =================

  Widget _buildTabContent(List<String> tabs) {
    final currentTab = tabs[_selectedTab];

    switch (currentTab) {
      case "Overview":
        return const OverviewTab();
      case "Tasks":
        return const Center(
          child: Text(
            "Tasks Screen",
            style: TextStyle(color: Colors.white),
          ),
        );
      case "Team":
        return const TeamTab();
      case "Milestones":
        return const MilestonesTab();
      default:
        return const SizedBox();
    }
  }

  // ================= HEADER =================

  Widget _header(BuildContext context, List<String> tabs) {
    return Stack(
      children: [
        Image.asset(
          'assets/image/aa.png',
          width: double.infinity,
          height: 320,
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            height: 320,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            color: Colors.black.withOpacity(0.45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// BACK
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Back to Projects",
                      style:
                          TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// TITLE
                const Text(
                  "Modern Villa Design",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Smith Residence",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 12),

                /// STATUS
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF01676C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Active",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16),

                /// ---------------- TABS ----------------
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(tabs.length, (index) {
                      final isActive = _selectedTab == index;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTab = index;
                            });
                          },
                          child: Container(
                            width: 120,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF01676C)
                                  : Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              tabs[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
