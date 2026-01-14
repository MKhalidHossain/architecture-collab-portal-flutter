import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/controller/project_details_controller.dart';
import 'package:dana_bozzetto/moduls/project/model/documents_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_based_documents.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/project_all_documents_widget.dart';
import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String selectedTab = "All";
  String searchQuery = "";
 

  final  _projectDetailsController = ProjectDetailsController ;
  final TextEditingController searchController = TextEditingController();


  final List<DocumentModel> documents = [
    DocumentModel(
      subtitle: "Modern Villa Design",
      size: "2.1 MB",
      date: "11/10/2025",
      category: "Pre-Design",
      type: "PNG File",
    ),
    DocumentModel(
      subtitle: "Modern Villa Design",
      size: "2.4 MB",
      date: "12/10/2025",
      category: "Schematic Design",
      type: "PDF File",
    ),
    DocumentModel(
      subtitle: "Modern Villa Design",
      size: "3.2 MB",
      date: "13/10/2025",
      category: "Construction Design",
      type: "JPG File",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    /// 🔹 TAB + SEARCH FILTER
    final filteredDocs = documents.where((doc) {
      final matchesTab = selectedTab == "All" || doc.category == selectedTab;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          doc.category.toLowerCase().contains(query) ||
          (doc.subtitle ?? "").toLowerCase().contains(query) ||
          doc.type.toLowerCase().contains(query);

      return matchesTab && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/image/ab.png", fit: BoxFit.cover),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 12),

              /// ---------------- LIST ----------------
              Expanded(
                child: filteredDocs.isEmpty
                    ? const Center(
                        child: Text(
                          "No documents found",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredDocs.length,
                        itemBuilder: (_, i) => DocumentPreviewCard(
                          title: filteredDocs[i].category,
                          subtitle: filteredDocs[i].subtitle ?? "",
                          size: filteredDocs[i].size,
                          date: filteredDocs[i].date,
                          type: filteredDocs[i].type,
                          onView: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProjectBasedDocuments(),
                              ),
                            );
                          },
                          onDownload: () {},
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F504C), Color(0xFF7E7E7B)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),
          _appBar(),
          _searchBar(),
          _tabs(),
        ],
      ),
    );
  }

  /// ---------------- APP BAR ----------------
  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Text(
            "Documents",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- SEARCH BAR (ACTIVE) ----------------
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.white54),
                hintText: "Search Projects, Documents....",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabs() {
    final tabs = [
      "All",
      "Pre-Design",
      "Schematic Design",
      "Design Development",
      "Construction Design",
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((tab) {
            final active = selectedTab == tab;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = tab;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF006B6F)
                        : Colors.white.withOpacity(.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tab,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
