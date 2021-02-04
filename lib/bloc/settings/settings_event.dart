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
