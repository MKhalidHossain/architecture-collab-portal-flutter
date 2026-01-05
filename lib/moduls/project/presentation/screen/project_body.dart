import 'package:flutter/material.dart';
import 'package:dana_bozzetto/moduls/home/common/project_cart.dart';
import 'package:dana_bozzetto/moduls/home/model/project_cart_model.dart';

class ProjectBody extends StatelessWidget {
  ProjectBody({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  /// Project List
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
      status: 'On Going',
      isActive: true,
      title: 'Modern Apartment',
      subtitle: 'Johnson Family',
      deadline: DateTime(2025, 10, 15),
      currentMilestone: 1,
      totalMilestones: 3,
      steps: [
        ProjectStep(label: 'PD', completed: true),
        ProjectStep(label: 'SD', completed: false),
        ProjectStep(label: 'DD', completed: false),
        ProjectStep(label: 'CD', completed: false),
      ],
      teamAvatars: [
        'assets/avatars/user2.jpg',
        'assets/avatars/user3.jpg',
      ],
    ),

    ProjectModel(
      id: '3',
      image: 'assets/image/aa.png',
      status: 'Completed',
      isActive: false,
      title: 'Office Interior',
      subtitle: 'Tech Corp',
      deadline: DateTime(2025, 8, 20),
      currentMilestone: 3,
      totalMilestones: 3,
      steps: [
        ProjectStep(label: 'PD', completed: true),
        ProjectStep(label: 'SD', completed: true),
        ProjectStep(label: 'DD', completed: true),
        ProjectStep(label: 'CD', completed: true),
      ],
      teamAvatars: [
        'assets/avatars/user1.jpg',
        'assets/avatars/user2.jpg',
        'assets/avatars/user3.jpg',
        'assets/avatars/user4.jpg',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          /// Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/ab.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Project List
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: projects.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 24),
              itemBuilder: (context, index) {
                return ProjectCard(
                  project: projects[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
