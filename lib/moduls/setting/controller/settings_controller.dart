import 'dart:async';
import 'package:dana_bozzetto/moduls/setting/interface/settings_interface.dart';
import 'package:dana_bozzetto/moduls/setting/model/settings_models.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SettingsController extends ChangeNotifier {
  final SettingsInterface _settingsInterface = Get.find<SettingsInterface>();

  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasLoaded = false;
  String _errorMessage = '';
  SettingsData _settings = SettingsData.empty();
  SettingsData _lastSyncedSettings = SettingsData.empty();
  Timer? _notificationsTimer;
  final List<Completer<bool>> _notificationCompleters = [];

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get hasLoaded => _hasLoaded;
  String get errorMessage => _errorMessage;
  SettingsData get settings => _settings;

  Future<void> fetchSettings() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await _settingsInterface.fetchSettings();
    result.fold(
      (failure) {
        _errorMessage = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        _settings = success.data ?? SettingsData.empty();
        _lastSyncedSettings = _settings;
      },
    );

    _isLoading = false;
    _hasLoaded = true;
    notifyListeners();
  }

  Future<bool> updateNotification({
    required String key,
    required bool value,
  }) async {
    final updatedNotifications = _applyNotificationChange(
      _settings.notifications,
      key,
      value,
    );
    _settings = _settings.copyWith(notifications: updatedNotifications);
    notifyListeners();

    return _queueNotificationUpdate();
  }

  Future<bool> updateLanguage(String language) async {
    final prev = _settings;
    _settings = _settings.copyWith(language: language);
    notifyListeners();
    return _submitUpdate(
      param: SettingsUpdateRequestModel(language: language),
      fallback: prev,
    );
  }

  Future<bool> _queueNotificationUpdate() {
    _notificationsTimer?.cancel();
    final completer = Completer<bool>();
    _notificationCompleters.add(completer);
    _notificationsTimer = Timer(const Duration(milliseconds: 250), () async {
      final current = _settings.notifications;
      final ok = await _submitUpdate(
        param: SettingsUpdateRequestModel(
          notifications: SettingsNotificationsUpdate(
            messages: current.messages,
            approvals: current.approvals,
            milestones: current.milestones,
            projectUpdates: current.projectUpdates,
            invoices: current.invoices,
          ),
        ),
        fallback: _lastSyncedSettings,
      );
      final pending = List<Completer<bool>>.from(_notificationCompleters);
      _notificationCompleters.clear();
      for (final item in pending) {
        if (!item.isCompleted) {
          item.complete(ok);
        }
      }
    });
    return completer.future;
  }

  Future<bool> _submitUpdate({
    required SettingsUpdateRequestModel param,
    required SettingsData fallback,
  }) async {
    _isSaving = true;
    _errorMessage = '';
    notifyListeners();

    final result = await _settingsInterface.updateSettings(param: param);
    bool success = true;
    result.fold(
      (failure) {
        _errorMessage = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
        _settings = fallback;
        success = false;
      },
      (response) {
        final updated = response.data?.settings;
        if (updated != null) {
          _settings = updated;
        }
        _lastSyncedSettings = _settings;
      },
    );

    _isSaving = false;
    notifyListeners();
    return success;
  }

  SettingsNotifications _applyNotificationChange(
    SettingsNotifications current,
    String key,
    bool value,
  ) {
    switch (key) {
      case 'messages':
        return current.copyWith(messages: value);
      case 'approvals':
        return current.copyWith(approvals: value);
      case 'milestones':
        return current.copyWith(milestones: value);
      case 'projectUpdates':
        return current.copyWith(projectUpdates: value);
      case 'invoices':
        return current.copyWith(invoices: value);
      default:
        return current;
    }
  }

  @override
  void dispose() {
    _isLoading = false;
    _isSaving = false;
    _hasLoaded = false;
    _errorMessage = '';
    _settings = SettingsData.empty();
    _lastSyncedSettings = SettingsData.empty();
    _notificationsTimer?.cancel();
    super.dispose();
  }
}
