part of 'settings_bloc.dart';

@immutable
class SettingsState extends Equatable {
  final Locale locale;
  final bool isDarkModeEnabled;
  const SettingsState({this.locale, this.isDarkModeEnabled});
  @override
  List<Object> get props => [isDarkModeEnabled, locale];

  SettingsState copyWith({Locale locale, bool isDarkModeEnabled}) =>
      SettingsState(
        locale: locale ?? this.locale,
        isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      );
}
