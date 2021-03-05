import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:protein_tracker/domain/proteins/protein.dart';
import 'package:protein_tracker/domain/statistics/time_series_protein.dart';
import 'package:protein_tracker/infrastructure/statistics/statistics_repository.dart';

import './statistics_event.dart';
import './statistics_state.dart';

@injectable
class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final StatisticsRepitory statisticsRepository;
  StatisticsBloc(this.statisticsRepository) : super(StatisticsLoadInProgress());

  @override
  Stream<StatisticsState> mapEventToState(
    StatisticsEvent event,
  ) async* {
    if (event is StatisticsLoaded) {
      yield* _mapStatisticsLoadedToState(event.proteins);
    } else if (event is StatisticsUpdated) {
      yield* _mapStatisticsUpdateToState(event.proteins);
    }
  }

  Stream<StatisticsState> _mapStatisticsLoadedToState(
      List<Protein> proteins) async* {
    try {
      List<TimeSeriesProtein> chartData =
          await this.statisticsRepository.getMonthlyProteinData(proteins);
      print("PROT:${proteins.length}");
      yield StatisticsLoadSuccess(
        chartData,
      );
    } catch (_) {
      yield StatisticsLoadFailure();
    }
  }

  Stream<StatisticsState> _mapStatisticsUpdateToState(
      List<Protein> proteins) async* {
    // try {
    //   List<TimeSeriesProtein> chartData =
    //       await this.proteinRepository.getAllProteins();
    //   print("PROT:${proteins.length}");
    //   yield ProteinsLoadSuccess(
    //     proteins.map((e) => Protein.fromEntity(e)).toList(),
    //   );
    // } catch (_) {
    //   yield ProteinsLoadFailure();
    // }
  }
}
