import 'dart:ui';
import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _progressCard(),
        const SizedBox(height: 16),
        _infoGrid(),
        const SizedBox(height: 16),
        _quickActions(),
      ],
    );
  }

  Widget _progressCard() {
    return _glassCard(
      child: Row(
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: Stack(
              alignment: Alignment.center,
              children: const [
                CircularProgressIndicator(
                  value: 0.5,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation(Colors.teal),
                ),
                Text("50%",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Project Progress",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text("• Pre-Design", style: TextStyle(color: Colors.white70)),
              Text("• Schematic Design",
                  style: TextStyle(color: Colors.white70)),
              Text("• Design Development",
                  style: TextStyle(color: Colors.white70)),
              Text("• Construction Documents",
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: const [
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
          Text("Quick Actions",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          _ActionTile(title: "Documents", count: "24"),
          _ActionTile(title: "Approvals", count: "02"),
          _ActionTile(title: "Invoices", count: "02"),
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
          padding: const EdgeInsets.all(12),
          color: Colors.black.withOpacity(0.35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 6),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
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

  const _ActionTile({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(count,
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
