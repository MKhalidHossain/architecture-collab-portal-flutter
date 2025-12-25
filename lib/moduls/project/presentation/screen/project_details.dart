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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _header(context),
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
                  child: _buildTabContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB CONTENT =================

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return const OverviewTab();
      case 1:
        return const TeamTab();
      case 2:
        return const MilestonesTab();
      default:
        return const SizedBox();
    }
  }

  Widget _header(BuildContext context) {
    return ClipRRect(
      // borderRadius: const BorderRadius.vertical(
      //   // bottom: Radius.circular(24),
      // ),
      child: Stack(
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
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Back to Projects",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                  
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF01676C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Active",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Tabs
                  Row(
                    children: List.generate(3, (index) {
                      final titles = ["Overview", "Team", "Milestones"];
                      final isActive = _selectedTab == index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Color(0xFF01676C)
                                  : Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              titles[index],
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
