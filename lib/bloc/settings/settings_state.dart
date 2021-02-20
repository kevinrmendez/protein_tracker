part of 'settings_bloc.dart';

@immutable
abstract class SettingsState extends Equatable {
  final locale;
  final isDarkModeEnabled;
  const SettingsState(this.locale, this.isDarkModeEnabled);
  @override
  List<Object> get props => [locale, isDarkModeEnabled];
}

class SettingsInitial extends SettingsState {
  final Locale locale;
  final bool isDarkModeEnabled;
  SettingsInitial(this.locale, this.isDarkModeEnabled) : super(null, null);
}

class SettingsLocaleChangeState extends SettingsState {
  final Locale locale;

  SettingsLocaleChangeState(this.locale) : super(null, null);
}

class SettingsDarkModeChangeState extends SettingsState {
  final bool isDarkModeEnabled;

  SettingsDarkModeChangeState(this.isDarkModeEnabled) : super(null, null);
}
