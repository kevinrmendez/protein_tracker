import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:meta/meta.dart';
import 'package:protein_tracker/infrastructure/settings/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  SettingsBloc(this.settingsRepository)
      : super(SettingsState(
            locale: settingsRepository.getLanguage(),
            isDarkModeEnabled: settingsRepository.getDarkModeValue(),
            goal: settingsRepository.getGoal(),
            weigthUnit: settingsRepository.getWeightUnit()));

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsLocaleChanged) {
      yield* _mapSettingsLocaleChangeState(event);
    }
    if (event is SettingsDarkModeChanged) {
      yield* _mapSettingsDarkModeChangeState(event);
    }
    if (event is SettingsWeightUnitChanged) {
      yield* _mapSettingsWeightUnitChangeState(event);
    }
    if (event is SettingsGoalChanged) {
      yield* _mapSettingsGoalChangeState(event);
    }
  }

  Stream<SettingsState> _mapSettingsLocaleChangeState(
      SettingsLocaleChanged event) async* {
    settingsRepository.changeLanguage(event.locale);
    yield state.copyWith(locale: event.locale);
  }

  Stream<SettingsState> _mapSettingsDarkModeChangeState(
      SettingsDarkModeChanged event) async* {
    settingsRepository.changeDarkModeValue(event.isDarkModeEnabled);
    yield state.copyWith(isDarkModeEnabled: event.isDarkModeEnabled);
  }

  Stream<SettingsState> _mapSettingsWeightUnitChangeState(
      SettingsWeightUnitChanged event) async* {
    settingsRepository.changeWeightUnit(event.weightUnit);
    yield state.copyWith(weightUnit: event.weightUnit);
  }

  Stream<SettingsState> _mapSettingsGoalChangeState(
      SettingsGoalChanged event) async* {
    settingsRepository.changeGoal(event.goal);
    yield state.copyWith(goal: event.goal);
  }
}
