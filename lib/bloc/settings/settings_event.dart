part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsLocaleChanged extends SettingsEvent {
  final Locale locale;
  const SettingsLocaleChanged(this.locale);

  @override
  List<Object> get props => [locale];
}

class SettingsDarkModeChanged extends SettingsEvent {
  final bool isDarkModeEnabled;
  const SettingsDarkModeChanged(this.isDarkModeEnabled);

  @override
  List<Object> get props => [isDarkModeEnabled];
}

class SettingsWeightUnitChanged extends SettingsEvent {
  final int weightUnit;
  const SettingsWeightUnitChanged(this.weightUnit);

  @override
  List<Object> get props => [weightUnit];
}
