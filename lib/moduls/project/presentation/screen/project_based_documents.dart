import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/presentation/widget/project_all_documents_widget.dart';
import 'package:flutter/material.dart';

class ProjectBasedDocuments extends StatefulWidget {
  const ProjectBasedDocuments({super.key});

  @override
  State<ProjectBasedDocuments> createState() => _ProjectBasedDocumentsState();
}

class _ProjectBasedDocumentsState extends State<ProjectBasedDocuments> {
  int _selectedTab = 0;

  final titles = [
    "All",
    "Pre-Design",
    "Schematic Design",
    "Design Development",
    "Construction Design",
  ];

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
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: AllTab(selectedCategory: titles[_selectedTab]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
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
                      "Documents",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
                Text(
                  "Moderman Villa Design",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Smith Residence",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 8),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(titles.length, (index) {
                      final isActive = _selectedTab == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTab = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF01676C)
                                : Colors.black38,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            titles[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
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
