part of 'settings_bloc.dart';

@immutable
class SettingsState extends Equatable {
  final Locale locale;
  final bool isDarkModeEnabled;
  final int weigthUnit;
  const SettingsState({this.weigthUnit, this.locale, this.isDarkModeEnabled});
  @override
  List<Object> get props => [isDarkModeEnabled, locale, weigthUnit];

  SettingsState copyWith(
          {Locale locale, bool isDarkModeEnabled, int weightUnit}) =>
      SettingsState(
          locale: locale ?? this.locale,
          isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
          weigthUnit: weigthUnit ?? this.weigthUnit);
}
