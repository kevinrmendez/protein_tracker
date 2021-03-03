part of 'settings_bloc.dart';

@immutable
class SettingsState extends Equatable {
  final Locale locale;
  final bool isDarkModeEnabled;
  final bool weigthUnit;

  const SettingsState({this.weigthUnit, this.locale, this.isDarkModeEnabled})
      : assert(weigthUnit != null),
        super();
  @override
  List<Object> get props => [isDarkModeEnabled, locale, weigthUnit];

  SettingsState copyWith(
          {Locale locale, bool isDarkModeEnabled, bool weightUnit}) =>
      SettingsState(
          locale: locale ?? this.locale,
          isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
          weigthUnit: weigthUnit ?? this.weigthUnit);
}
