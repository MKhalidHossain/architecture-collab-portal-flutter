import 'dart:ui';
import 'package:flutter/material.dart';
import 'menu_type.dart';

class SideMenu extends StatelessWidget {
  final MenuType selectedMenu;
  final Function(MenuType) onSelect;

  const SideMenu({
    super.key,
    required this.selectedMenu,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Image.asset(
                            "assets/image/aa.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Spacer(),
                      ClipRRect(
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
                                color: Colors.white.withOpacity(0.25),
                              ),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    _menuItem(context, Icons.dashboard, 'Home', MenuType.home),
                    _menuItem(
                      context,
                      Icons.work,
                      'Projects',
                      MenuType.projects,
                    ),
                    _menuItem(
                      context,
                      Icons.message,
                      'Messages',
                      MenuType.messages,
                    ),
                    _menuItem(
                      context,
                      Icons.calendar_today,
                      'Calendar',
                      MenuType.calendar,
                    ),
                    _menuItem(
                      context,
                      Icons.notifications,
                      'Notifications',
                      MenuType.notifications,
                    ),
                    _menuItem(
                      context,
                      Icons.person,
                      'Profile',
                      MenuType.profile,
                    ),
                    _menuItem(
                      context,
                      Icons.settings,
                      'Settings',
                      MenuType.settings,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    MenuType type,
  ) {
    final isActive = selectedMenu == type;

    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.white : Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white70,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onSelect(type);
      },
    );
  }
}
