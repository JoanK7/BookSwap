import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Settings state class
class SettingsState {
  final bool notificationReminders;
  final bool emailUpdates;

  SettingsState({
    this.notificationReminders = true,
    this.emailUpdates = true,
  });

  SettingsState copyWith({
    bool? notificationReminders,
    bool? emailUpdates,
  }) {
    return SettingsState(
      notificationReminders: notificationReminders ?? this.notificationReminders,
      emailUpdates: emailUpdates ?? this.emailUpdates,
    );
  }
}

/// State notifier for settings
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState());

  /// Toggle notification reminders
  void toggleNotificationReminders() {
    state = state.copyWith(
      notificationReminders: !state.notificationReminders,
    );
  }

  /// Toggle email updates
  void toggleEmailUpdates() {
    state = state.copyWith(
      emailUpdates: !state.emailUpdates,
    );
  }
}

/// Provider for settings notifier
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});