import 'dart:ui';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/home/common/menu.dart';
import 'package:dana_bozzetto/moduls/home/common/menu_type.dart';
import 'package:dana_bozzetto/moduls/home/interface/home_interface.dart';
import 'package:dana_bozzetto/moduls/home/model/home_response_model.dart';
import 'package:dana_bozzetto/moduls/home/presentation/screens/home_screen.dart';
import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_body.dart';
import 'package:dana_bozzetto/moduls/message/presentation/screen/message_body.dart';
import 'package:dana_bozzetto/moduls/notification/presentation/screen/notification_screen.dart';
import 'package:dana_bozzetto/moduls/profile/presentation/screen/profile_screen.dart';
import 'package:dana_bozzetto/moduls/setting/presentation/screen/setting_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientHomeScreen extends StatefulWidget {
  final Future<HomeDashboardResponse>? dashboardFuture;

  const ClientHomeScreen({super.key, this.dashboardFuture});
  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MenuType _selectedMenu = MenuType.home;
  ProjectFilter _projectFilter = ProjectFilter.all;
  late Future<Map<String, dynamic>> _profileFuture;
  late Future<HomeDashboardResponse> _dashboardFuture;
  late Future<ProjectsResponse> _projectsFuture;
  HomeDashboardResponse _cachedDashboard = HomeDashboardResponse.empty();

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfile();
    _dashboardFuture = widget.dashboardFuture ?? _fetchDashboard();
    _projectsFuture = _fetchProjects();
  }

  Future<Map<String, dynamic>> _fetchProfile() async {
    final appPigeon = Get.find<AppPigeon>();
    final response = await appPigeon.get(ApiEndpoints.me);
    final data = response.data;
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      if (map['data'] is Map) {
        return Map<String, dynamic>.from(map['data']);
      }
      return map;
    }
    throw Exception('Invalid profile response');
  }

  Future<HomeDashboardResponse> _fetchDashboard() async {
    final homeInterface = Get.find<HomeInterface>();
    final result = await homeInterface.fetchDashboard();
    return result.fold((failure) {
      final message = failure.uiMessage.isNotEmpty
          ? failure.uiMessage
          : failure.fullError;
      throw Exception(
        message.isNotEmpty ? message : 'Failed to load dashboard',
      );
    }, (success) => success.data ?? HomeDashboardResponse.empty());
  }

  Future<ProjectsResponse> _fetchProjects() async {
    final projectInterface = Get.find<ProjectInterface>();
    final result = await projectInterface.fetchProjects();
    return result.fold((failure) {
      final message = failure.uiMessage.isNotEmpty
          ? failure.uiMessage
          : failure.fullError;
      throw Exception(message.isNotEmpty ? message : 'Failed to load projects');
    }, (success) => success.data ?? ProjectsResponse.empty());
  }

  void _reloadProfile() {
    setState(() {
      _profileFuture = _fetchProfile();
    });
  }

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

  Widget _homeHeader() {
    return _glass(
      child: FutureBuilder<HomeDashboardResponse>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          final data = snapshot.data ?? _cachedDashboard;
          if (snapshot.hasData) {
            _cachedDashboard = snapshot.data ?? _cachedDashboard;
          }
          final userName = data.userName.trim();
          final greeting = userName.isNotEmpty ? 'Hi, $userName' : 'Hi, —';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topRow(greeting),
              const Text(
                'Here’s your project overview',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              _searchBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _projectsHeader() {
    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'My Projects',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track all your architectural projects',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _actionButton(
                    icon: Icons.notifications_none,
                    onPressed: () {
                      setState(() => _selectedMenu = MenuType.notifications);
                    },
                  ),
                  const SizedBox(width: 8),
                  _menuButton(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _searchBar(hintText: 'Search Projects, Documents....'),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _messagesHeader() {
    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topRow('Messages'),
          const SizedBox(height: 12),
          _searchBar(),
        ],
      ),
    );
  }

  Widget _notificationsHeader() {
    return _glass(
      child: Column(
        children: [
          _topRow('Notifications'),
          const SizedBox(height: 12),
          Row(
            children: const [
              Chip(label: Text('All')),
              SizedBox(width: 8),
              Chip(label: Text('Unread')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _settingsHeader() {
    return _glass(child: _topRow('Settings'));
  }

  Widget _profileHeader() {
    return _glass(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          final data = snapshot.data ?? const <String, dynamic>{};
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final hasError = snapshot.hasError;

          String readString(String key) {
            final value = data[key];
            final text = value?.toString() ?? '';
            return text.isNotEmpty ? text : '—';
          }

          String readAvatarUrl() {
            final avatar = data['avatar'];
            if (avatar is Map) {
              final url = avatar['url']?.toString() ?? '';
              if (url.isNotEmpty) {
                return url;
              }
            }
            return '';
          }

          final name = isLoading ? 'Loading...' : readString('name');
          final employeeId = readString('employeeId');
          final avatarUrl = readAvatarUrl();
          final avatarImage = avatarUrl.isNotEmpty
              ? NetworkImage(avatarUrl)
              : const AssetImage('assets/image/aa.png') as ImageProvider;

          return Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.black12,
                    backgroundImage: avatarImage,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Client ID : $employeeId',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _menuButton(),
                ],
              ),
              if (hasError) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _reloadProfile,
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Color(0xFF00D4AA)),
                  ),
                ),
              ],

              const SizedBox(height: 18),

              // Stats Container
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: const Row(
                  children: [
                    ProfileStat(title: 'Projects', value: '03'),
                    _VerticalDivider(),
                    ProfileStat(title: 'Documents', value: '24'),
                    _VerticalDivider(),
                    ProfileStat(title: 'Pending', value: '02'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= BODY =================
  Widget _buildBody() {
    switch (_selectedMenu) {
      case MenuType.home:
        return HomeScreenT(dashboardFuture: _dashboardFuture);
      case MenuType.projects:
        return ProjectBody(
          projectsFuture: _projectsFuture,
          filter: _projectFilter,
        );
      case MenuType.messages:
        return MessagesScreen();
      case MenuType.notifications:
        return NotificationScreen();
      case MenuType.profile:
        return ProfileBody(onProfileUpdated: _reloadProfile);
      case MenuType.settings:
        return SettingsScreen();
    }
  }

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

  Widget _menuButton() {
    return _actionButton(
      icon: Icons.menu,
      onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
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
            border: Border.all(color: Colors.white.withOpacity(0.35)),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(icon, color: Colors.white, size: 24),
            onPressed: onPressed,
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
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _searchBar({String hintText = 'Search...'}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

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
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: Colors.white.withOpacity(0.2),
    );
  }
}
