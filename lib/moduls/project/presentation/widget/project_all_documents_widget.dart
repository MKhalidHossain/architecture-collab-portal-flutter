import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/model/documents_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/view_documents.dart';
import 'package:flutter/material.dart';

class AllTab extends StatelessWidget {
  final String selectedCategory;

  const AllTab({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final filteredDocs = selectedCategory == "All"
        ? documents
        : documents.where((doc) => doc.category == selectedCategory).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedCategory == "All"
              ? "All Documents"
              : "$selectedCategory Documents",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        if (filteredDocs.isEmpty)
          const Text(
            "No documents found",
            style: TextStyle(color: Colors.white70),
          ),

        ...filteredDocs.map(
          (doc) => DocumentPreviewCard(
            title: doc.category,
            subtitle: doc.subtitle,
            size: doc.size,
            date: doc.date,
            type: doc.type,
          ),
        ),
      ],
    );
  }
}

/// ------------------ DATA SOURCE ------------------

final List<DocumentModel> documents = [
  DocumentModel(
    category: "Pre-Design",
    subtitle: "Modern Villa Design",
    size: "2.1 MB",
    date: "11/10/2025",
    type: "PNG File",
  ),
  DocumentModel(
    category: "Schematic Design",
    subtitle: "Modern Villa Design",
    size: "2.4 MB",
    date: "12/10/2025",
    type: "PDF File",
  ),
  DocumentModel(
    category: "Construction Design",
    subtitle: "Modern Villa Design",
    size: "3.2 MB",
    date: "13/10/2025",
    type: "JPG File",
  ),
  DocumentModel(
    category: "Design Development",
    subtitle: "Modern Villa Design",
    size: "1.8 MB",
    date: "10/10/2025",
    type: "PNG File",
  ),
];

/// ------------------ CARD UI ------------------

class DocumentPreviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String size;
  final String date;
  final String type;

  const DocumentPreviewCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.size,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF6B6B68),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white54),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF01676C),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.description, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          meta(size),
                          dot(),
                          meta(date),
                          dot(),
                          meta(type),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          actionButton(
                            context,
                            Icons.remove_red_eye,
                            "View",
                            DocumentDetailScreen(),
                          ),
                          const SizedBox(width: 12),
                          actionButton(
                            context,
                            Icons.download,
                            "Download",
                            const Scaffold(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget meta(String text) =>
      Text(text, style: const TextStyle(color: Colors.white70));

  Widget dot() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: Text("|", style: TextStyle(color: Colors.white70)),
  );

  Widget actionButton(
    BuildContext context,
    IconData icon,
    String label,
    Widget targetScreen,
  ) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => targetScreen),
          );
        },
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white38),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
