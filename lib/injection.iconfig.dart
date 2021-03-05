// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:protein_tracker/infrastructure/foods/food_repository.dart';
import 'package:protein_tracker/application/foods/foods_bloc.dart';
import 'package:protein_tracker/infrastructure/proteins/protein_repository.dart';
import 'package:protein_tracker/application/proteins/proteins_bloc.dart';
import 'package:protein_tracker/infrastructure/settings/settings_repository.dart';
import 'package:protein_tracker/infrastructure/statistics/statistics_repository.dart';
import 'package:protein_tracker/application/settings/settings_bloc.dart';
import 'package:protein_tracker/application/statistics/statistics_bloc.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  g.registerLazySingleton<FoodRepository>(() => FoodRepository());
  g.registerFactory<FoodsBloc>(
      () => FoodsBloc(foodRepository: g<FoodRepository>()));
  g.registerLazySingleton<ProteinRepository>(() => ProteinRepository());
  g.registerFactory<ProteinsBloc>(
      () => ProteinsBloc(proteinRepository: g<ProteinRepository>()));
  g.registerLazySingleton<SettingsRepository>(() => SettingsRepository());
  g.registerLazySingleton<StatisticsRepitory>(() => StatisticsRepitory());
  g.registerFactory<SettingsBloc>(() => SettingsBloc(g<SettingsRepository>()));
  g.registerFactory<StatisticsBloc>(
      () => StatisticsBloc(g<StatisticsRepitory>(), g<ProteinsBloc>()));
}
