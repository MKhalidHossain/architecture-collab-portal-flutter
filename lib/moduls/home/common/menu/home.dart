// import 'dart:ui';
// import 'package:dana_bozzetto/moduls/home/common/menu.dart';
// import 'package:dana_bozzetto/moduls/home/presentation/screens/home_screen.dart';
// import 'package:dana_bozzetto/moduls/home/presentation/widgets/project_body.dart';
// import 'package:flutter/material.dart';
// import '../menu_type.dart';

// class HomeScreentest extends StatefulWidget {
//   const HomeScreentest({super.key});

//   @override
//   State<HomeScreentest> createState() => _HomeScreentestState();
// }

// class _HomeScreentestState extends State<HomeScreentest> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   MenuType _selectedMenu = MenuType.home;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       endDrawer: SideMenu(
//         selectedMenu: _selectedMenu,
//         onSelect: (menu) {
//           setState(() {
//             _selectedMenu = menu;
//           });
//         },
//       ),
//       body: Stack(
//         children: [
//           _background(),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _header(context),
//               const SizedBox(height: 8),
//               Expanded(child: _buildBody()),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _background() {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/image/ab.png'),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   Widget _header(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.22),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: Colors.white.withOpacity(0.2)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: MediaQuery.of(context).padding.top),

//               /// 🔹 TOP ROW (Title + Menu)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Hi, Jhon',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Here’s your project overview',
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
//                         onPressed: () {}
//                       ),

//                       IconButton(
//                         icon: const Icon(Icons.menu, color: Colors.white),
//                         onPressed: () =>
//                             _scaffoldKey.currentState?.openEndDrawer(),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//                   child: Container(
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.18),
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: Colors.white.withOpacity(0.2)),
//                     ),
//                     child: const TextField(
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.search, color: Colors.white),
//                         hintText: 'Search projects, documents...',
//                         hintStyle: TextStyle(color: Colors.white70),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(vertical: 12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     switch (_selectedMenu) {
//       case MenuType.home:
//         return HomeScreenT();

//       case MenuType.projects:
//         return ProjectBody();

//       case MenuType.messages:
//         return _simplePage('Messages');

//       case MenuType.notifications:
//         return _simplePage('Notifications');

//       case MenuType.profile:
//         return _simplePage('Profile');

//       case MenuType.settings:
//         return _simplePage('Settings');
//     }
//   }

//   // ================= SIMPLE PAGES =================
//   Widget _simplePage(String title) {
//     return Center(
//       child: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 22,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

// class ProjectCard extends StatelessWidget {
//   const ProjectCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: const Center(
//         child: Text('Project Card', style: TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }

// class ActivityTile extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String time;

//   const ActivityTile({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.time,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(title, style: const TextStyle(color: Colors.white)),
//       subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
//       trailing: Text(time, style: const TextStyle(color: Colors.white54)),
//     );
//   }
// }


import 'dart:ui';
import 'package:dana_bozzetto/moduls/home/common/menu.dart';
import 'package:dana_bozzetto/moduls/home/common/menu_type.dart';
import 'package:dana_bozzetto/moduls/home/presentation/screens/home_screen.dart';
import 'package:dana_bozzetto/moduls/home/presentation/widgets/project_body.dart';
import 'package:flutter/material.dart';

class HomeScreentest extends StatefulWidget {
  const HomeScreentest({super.key});

  @override
  State<HomeScreentest> createState() => _HomeScreentestState();
}

class _HomeScreentestState extends State<HomeScreentest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MenuType _selectedMenu = MenuType.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SideMenu(
        selectedMenu: _selectedMenu,
        onSelect: (menu) {
          setState(() => _selectedMenu = menu);
        },
      ),
      body: Stack(
        children: [
          _background(),
          Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 8),
              Expanded(child: _buildBody()),
            ],
          ),
        ],
      ),
    );
  }

  // ================= BACKGROUND =================
  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/ab.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ================= HEADER SWITCH =================
  Widget _buildHeader(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_selectedMenu) {
        MenuType.home => _homeHeader(),
        MenuType.projects => _projectsHeader(),
        MenuType.messages => _messagesHeader(),
        MenuType.notifications => _notificationsHeader(),
        MenuType.profile => _profileHeader(),
        MenuType.settings => _settingsHeader(),
      },
    );
  }

  // ================= HEADERS =================

  Widget _homeHeader() {
    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topRow('Hi, John'),
          const Text(
            'Here’s your project overview',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          _searchBar(),
        ],
      ),
    );
  }

  Widget _projectsHeader() {
    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topRow('Projects'),
          const SizedBox(height: 12),
          Row(
            children: const [
              Chip(label: Text('All')),
              SizedBox(width: 8),
              Chip(label: Text('Ongoing')),
              SizedBox(width: 8),
              Chip(label: Text('Completed')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _messagesHeader() {
    return _glass(
      child: Row(
        children: [
          _topRow('Messages', showMenu: false),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '3',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          _menuButton(),
        ],
      ),
    );
  }

  Widget _notificationsHeader() {
    return _glass(child: _topRow('Notifications'));
  }

  Widget _settingsHeader() {
    return _glass(child: _topRow('Settings'));
  }

  Widget _profileHeader() {
    return _glass(
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage('assets/image/aa.png'),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Client ID : 353553545',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _menuButton(),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              ProfileStat(title: 'Projects', value: '03'),
              ProfileStat(title: 'Documents', value: '24'),
              ProfileStat(title: 'Pending', value: '02'),
            ],
          ),
        ],
      ),
    );
  }

  // ================= BODY =================
  Widget _buildBody() {
    switch (_selectedMenu) {
      case MenuType.home:
        return  HomeScreenT();
      case MenuType.projects:
        return  ProjectBody();
      case MenuType.messages:
        return _simplePage('Messages');
      case MenuType.notifications:
        return _simplePage('Notifications');
      case MenuType.profile:
        return ProfileBody();
      case MenuType.settings:
        return _simplePage('Settings');
    }
  }

  // ================= COMMON WIDGETS =================

  Widget _topRow(String title, {bool showMenu = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (showMenu) _menuButton(),
      ],
    );
  }

  // Widget _menuButton() {
  //   return IconButton(
  //     icon: const Icon(Icons.menu, color: Colors.white),
  //     onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
  //   );
  // }

  Widget _menuButton() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.menu, color: Colors.white, size: 24),
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
      ),
    ),
  );
}


  Widget _glass({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white),
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _simplePage(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ================= PROFILE BODY =================
class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.person, color: Colors.white),
          title: Text('Edit Profile', style: TextStyle(color: Colors.white)),
        ),
        ListTile(
          leading: Icon(Icons.lock, color: Colors.white),
          title:
              Text('Change Password', style: TextStyle(color: Colors.white)),
        ),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.white),
          title: Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// ================= PROFILE STAT =================
class ProfileStat extends StatelessWidget {
  final String title;
  final String value;

  const ProfileStat({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
