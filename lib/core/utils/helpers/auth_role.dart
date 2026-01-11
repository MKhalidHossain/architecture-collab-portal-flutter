
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';

enum AuthRole {
  client('client'),
  teamMember('team_member'),
  unknown('');

  final String label;

  const AuthRole(this.label);

  factory AuthRole.fromString(String name) {
    final value = name.trim().toLowerCase();
    switch (value) {
      case 'client':
        return AuthRole.client;
      case 'team_member':
      case 'team member':
      case 'teammember':
        return AuthRole.teamMember;
      default:
        return AuthRole.unknown;
    }
  }
}

extension ExtraAuth on Auth {
  String get userId => data['userId'];

  AuthRole get authRole {
    try {
      final role = data['role']?.toString() ?? '';
      return AuthRole.fromString(role);
    } catch (_) {
      return AuthRole.unknown;
    }
  }
}
