// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:protein_tracker/repository/protein_repository.dart';
import 'package:protein_tracker/bloc/proteins/proteins_bloc.dart';
import 'package:protein_tracker/repository/settings_repository.dart';
import 'package:protein_tracker/bloc/settings/settings_bloc.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  g.registerLazySingleton<ProteinRepository>(() => ProteinRepository());
  g.registerFactory<ProteinsBloc>(
      () => ProteinsBloc(proteinRepository: g<ProteinRepository>()));
  g.registerLazySingleton<SettingsRepository>(() => SettingsRepository());
  g.registerFactory<SettingsBloc>(() => SettingsBloc(g<SettingsRepository>()));
}
