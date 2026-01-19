import 'dart:ui';
import 'package:dana_bozzetto/core/common/widget/glass_card.dart';
import 'package:dana_bozzetto/moduls/project/model/documents_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/view_documents.dart';
import 'package:flutter/material.dart';

class AllTab extends StatelessWidget {
  final String selectedCategory;
  final List<DocumentModel> documents;

  const AllTab({
    super.key,
    required this.selectedCategory,
    required this.documents,
  });

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
            subtitle: doc.subtitle ?? "",
            size: doc.size,
            date: doc.date,
            type: doc.type,
            onView: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DocumentDetailScreen(document: doc),
                ),
              );
            },
            onDownload: () {
              // Add download logic here
            },
          ),
        ),
      ],
    );
  }
}

class DocumentPreviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String size;
  final String date;
  final String type;
  final VoidCallback? onView;
  final VoidCallback? onDownload;

  const DocumentPreviewCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.size,
    required this.date,
    required this.type,
    this.onView,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: glassCard(
            
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF01676C),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.description_outlined, color: Colors.white),
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
                            _meta(size),
                            _dot(),
                            _meta(date),
                            _dot(),
                            _meta(type),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _actionButton(
                              context,
                              Icons.remove_red_eye,
                              "View",
                              onView,
                            ),
                            const SizedBox(width: 12),
                            _actionButton(
                              context,
                              Icons.download,
                              "Download",
                              onDownload,
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
      ),
    );
  }

  Widget _meta(String text) =>
      Text(text, style: const TextStyle(color: Colors.white70));

  Widget _dot() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: Text("|", style: TextStyle(color: Colors.white70)),
  );

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback? onTap,
  ) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
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
