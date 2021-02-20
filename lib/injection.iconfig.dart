// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:protein_tracker/repository/settings_repository.dart';
import 'package:protein_tracker/bloc/settings/settings_bloc.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  g.registerLazySingleton<SettingsRepository>(() => SettingsRepository());
  g.registerFactory<SettingsBloc>(() => SettingsBloc(g<SettingsRepository>()));
}
