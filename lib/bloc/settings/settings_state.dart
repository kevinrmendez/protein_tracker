part of 'settings_bloc.dart';

@immutable
abstract class SettingsState extends Equatable {
  final locale;
  const SettingsState(this.locale);
  @override
  List<Object> get props => [locale];
}

class SettingsInitial extends SettingsState {
  final Locale locale;
  SettingsInitial(this.locale) : super(null);
}

class SettingsLocaleChangeState extends SettingsState {
  final Locale locale;

  SettingsLocaleChangeState(this.locale) : super(null);
}
