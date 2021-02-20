import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:meta/meta.dart';
import 'package:protein_tracker/repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  SettingsBloc(this.settingsRepository)
      // SettingsBloc()
      : super(SettingsInitial(settingsRepository.getLanguage()));
  // : super(SettingsInitial(Locale('fr', 'FR')));

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsLocaleChanged) {
      yield* _mapSettingsLocaleChangeState(event);
    }
  }

  Stream<SettingsLocaleChangeState> _mapSettingsLocaleChangeState(
      SettingsLocaleChanged event) async* {
    settingsRepository.changeLanguage(event.locale);
    yield SettingsLocaleChangeState(event.locale);
  }
}
