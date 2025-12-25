import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_base_Approval.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_based_documents.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_based_invoices.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/circular_progress_widget.dart';
import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _progressCard(),
        _infoGrid(),
        SizedBox(height: 16),
        _quickActions(),
      ],
    );
  }

  Widget _progressCard() {
    return _glassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  "Project Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Construction Documents in progress",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressPercent(
                  percent: 0.6,
                  size: 100,
                  progressColor: Colors.teal.shade400,
                  backgroundColor: Colors.white.withOpacity(0.12),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _progressItem("Pre-Design", Colors.teal, true),
                      _progressItem("Schematic Design", Colors.teal, true),
                      _progressItem(
                        "Design Development",
                        Colors.redAccent,
                        false,
                      ),
                      _progressItem(
                        "Construction Documents",
                        Colors.redAccent,
                        false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressItem(String label, Color color, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed ? color : color.withOpacity(0.3),
              border: Border.all(
                color: completed ? color : Colors.white30,
                width: 2,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: completed ? Colors.white : Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _InfoTile(title: "Start Date", value: "Dec 01, 2025"),
        _InfoTile(title: "End Date", value: "Dec 01, 2025"),
        _InfoTile(title: "Type", value: "Residential"),
        _InfoTile(title: "Location", value: "Los Angeles, CA"),
      ],
    );
  }

  Widget _quickActions() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Quick Actions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _ActionTile(
            title: "Documents",
            count: "24",
            navigateTo: DocumentsTab(),
          ),
          SizedBox(height: 8),
          _ActionTile(
            title: "Approvals",
            count: "02",
            navigateTo: ProjectBaseApproval(),
          ),
          SizedBox(height: 8),
          _ActionTile(
            title: "Invoices",
            count: "02",
            navigateTo: ProjectInvoicesScreen(),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black.withOpacity(0.35),
          child: child,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.all(12),
          color: Colors.black.withOpacity(0.35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String count;
  final Widget navigateTo;

  const _ActionTile({
    required this.title,
    required this.count,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 190, 189, 189).withOpacity(0.35),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => navigateTo),
          );
        },
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Count badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF01676C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(count, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
