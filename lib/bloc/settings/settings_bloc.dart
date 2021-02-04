import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial(Locale('fr', 'FR')));

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
    yield SettingsLocaleChangeState(event.locale);
  }
}
