part of 'settings_bloc.dart';

@immutable
class SettingsState extends Equatable {
  final Locale locale;
  final bool isDarkModeEnabled;
  final bool weigthUnit;
  final int goal;

  const SettingsState(
      {this.goal, this.weigthUnit, this.locale, this.isDarkModeEnabled})
      : assert(weigthUnit != null),
        super();
  @override
  List<Object> get props => [isDarkModeEnabled, locale, weigthUnit, goal];

  SettingsState copyWith(
          {Locale locale, bool isDarkModeEnabled, bool weightUnit, int goal}) =>
      SettingsState(
          locale: locale ?? this.locale,
          isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
          goal: goal ?? this.goal,
          weigthUnit: weigthUnit ?? this.weigthUnit);
}
