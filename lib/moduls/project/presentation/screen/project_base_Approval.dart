// import 'dart:ui';
// import 'package:flutter/material.dart';

// class ProjectBaseApproval extends StatefulWidget {
//   const ProjectBaseApproval({super.key});

//   @override
//   State<ProjectBaseApproval> createState() => _ProjectBaseApprovalState();
// }

// class _ProjectBaseApprovalState extends State<ProjectBaseApproval> {
//   int _selectedTab = 0;

//   final tabs = [
//     "All (24)",
//     "Pending (3)",
//     "Approved (6)",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           _buildHeader(context),
//           Expanded(
//             child: Stack(
//               children: [
//                 // Optional subtle background - you can keep or remove
//                 Positioned.fill(
//                   child: Image.asset(
//                     'assets/image/ab.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 ListView.builder(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//                   itemCount: 10, // for demo - in real app use real data length
//                   itemBuilder: (context, index) {
//                     // Simple simulation of filtering
//                     final status = index % 3 == 0
//                         ? "Pending"
//                         : index % 3 == 1
//                             ? "Approved"
//                             : "Reviewed";

//                     if (_selectedTab == 1 && status != "Pending") return const SizedBox.shrink();
//                     if (_selectedTab == 2 && status != "Approved") return const SizedBox.shrink();

//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 14),
//                       child: _buildApprovalCard(
//                         isPending: status == "Pending",
//                         isApproved: status == "Approved",
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Stack(
//       children: [
//         Image.asset(
//           'assets/image/aa.png',
//           width: double.infinity,
//           height: 320,
//           fit: BoxFit.cover,
//         ),
//         BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//           child: Container(
//             height: 300,
//             padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.42),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back_ios_new_rounded,
//                           color: Colors.white, size: 22),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       "Approvals",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Modern Villa Design",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   "Smith Residence",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF01676C),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Text(
//                     "Active",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Tabs
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: List.generate(tabs.length, (i) {
//                       final active = _selectedTab == i;
//                       return GestureDetector(
//                         onTap: () => setState(() => _selectedTab = i),
//                         child: Container(
//                           margin: const EdgeInsets.only(right: 12),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 18, vertical: 12),
//                           decoration: BoxDecoration(
//                             color: active ? const Color(0xFF01676C) : Colors.white.withOpacity(0.12),
//                             borderRadius: BorderRadius.circular(30),
//                             border: active ? null : Border.all(color: Colors.white24),
//                           ),
//                           child: Text(
//                             tabs[i],
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: active ? FontWeight.w700 : FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildApprovalCard({
//     required bool isPending,
//     required bool isApproved,
//   }) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.09),
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(color: Colors.white.withOpacity(0.12)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Final Design Proposal",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 17,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     _buildStatusBadge(isPending: isPending, isApproved: isApproved),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Please review and approve the final design proposal including all revisions discussed in our last meeting.",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     height: 1.4,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // People & Date row
//                 Row(
//                   children: [
//                     const Icon(Icons.person_outline_rounded, size: 16, color: Colors.white60),
//                     const SizedBox(width: 6),
//                     const Text(
//                       "Requested by Team",
//                       style: TextStyle(color: Colors.white60, fontSize: 13),
//                     ),
//                     const Spacer(),
//                     const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.white60),
//                     const SizedBox(width: 6),
//                     const Text(
//                       "Dec 01, 2025",
//                       style: TextStyle(color: Colors.white60, fontSize: 13),
//                     ),
//                   ],
//                 ),

//                 // Due date
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.flag_outlined, size: 16, color: Colors.white60),
//                       const SizedBox(width: 6),
//                       const Text(
//                         "Due Dec 24, 2025",
//                         style: TextStyle(color: Colors.white60, fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ),

//                 if (isPending) ...[
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildButton(
//                           label: "Reject",
//                           isPrimary: false,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildButton(
//                           label: "Review",
//                           isPrimary: true,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusBadge({
//     required bool isPending,
//     required bool isApproved,
//   }) {
//     final color = isPending
//         ? Colors.orange
//         : isApproved
//             ? Colors.green
//             : Colors.blue;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.18),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         isPending
//             ? "Pending"
//             : isApproved
//                 ? "Approved"
//                 : "Reviewed",
//         style: TextStyle(
//           color: color,
//           fontSize: 12,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }

//   Widget _buildButton({
//     required String label,
//     required bool isPrimary,
//   }) {
//     return Container(
//       height: 44,
//       decoration: BoxDecoration(
//         color: isPrimary ? const Color(0xFF01676C) : Colors.transparent,
//         borderRadius: BorderRadius.circular(14),
//         border: isPrimary ? null : Border.all(color: Colors.white30, width: 1.2),
//       ),
//       child: Center(
//         child: Text(
//           label,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';

class ProjectBaseApproval extends StatefulWidget {
  const ProjectBaseApproval({super.key});

  @override
  State<ProjectBaseApproval> createState() => _ProjectBaseApprovalState();
}

class _ProjectBaseApprovalState extends State<ProjectBaseApproval> {
  int _selectedTab = 0;

  final tabs = [
    "All (24)",
    "Pending (3)",
    "Approved (6)",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Stack(
              children: [
                // Background image (optional - you can remove if not needed)
                Positioned.fill(
                  child: Image.asset(
                    'assets/image/ab.png',
                    fit: BoxFit.cover,
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: 12, // Demo count - replace with real data length
                  itemBuilder: (context, index) {
                    // Simple demo status cycling - replace with your real data logic
                    final statusIndex = index % 4;
                    String status;

                    if (statusIndex == 0 || statusIndex == 2) {
                      status = "Pending";
                    } else if (statusIndex == 1) {
                      status = "Approved";
                    } else {
                      status = "Reviewed";
                    }

                    // Apply tab filtering
                    if (_selectedTab == 1 && status != "Pending") {
                      return const SizedBox.shrink();
                    }
                    if (_selectedTab == 2 && status != "Approved") {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildApprovalCard(
                        isPending: status == "Pending",
                        isApproved: status == "Approved",
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/image/aa.png',
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 300,
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.42),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Approvals",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
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
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF01676C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Active",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(tabs.length, (i) {
                        final active = _selectedTab == i;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTab = i),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFF01676C)
                                  : Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(30),
                              border: active ? null : Border.all(color: Colors.white24),
                            ),
                            child: Text(
                              tabs[i],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
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
        ),
      ],
    );
  }

  Widget _buildApprovalCard({
    required bool isPending,
    required bool isApproved,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 12, 11, 11).withOpacity(0.25),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Final Design Proposal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _buildStatusBadge(
                      isPending: isPending,
                      isApproved: isApproved,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please review and approve the final design proposal including all revisions discussed in our last meeting.",
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),

                // Requested by & Requested Date
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded,
                        size: 16, color: Colors.white60),
                    const SizedBox(width: 6),
                    const Text(
                      "Requested by Team",
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                    const Spacer(),
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: Colors.white60),
                    const SizedBox(width: 6),
                    const Text(
                      "Dec 01, 2025",
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),

                // Due Date
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.flag_outlined,
                          size: 16, color: Colors.white60),
                      const SizedBox(width: 6),
                      const Text(
                        "Due Dec 24, 2025", // ← Current date as per prompt
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                if (isPending) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          label: "Reject",
                          isPrimary: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildButton(
                          label: "Review",
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge({
    required bool isPending,
    required bool isApproved,
  }) {
    final color = isPending
        ? Colors.orange
        : isApproved
            ? Colors.green
            : Colors.blueAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPending
            ? "Pending"
            : isApproved
                ? "Approved"
                : "Reviewed",
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required bool isPrimary,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF01676C) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: isPrimary ? null : Border.all(color: Colors.white30, width: 1.2),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}