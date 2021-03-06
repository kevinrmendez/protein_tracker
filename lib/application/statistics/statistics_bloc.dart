import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:protein_tracker/application/proteins/proteins.dart';
import 'package:protein_tracker/application/statistics/statistics.dart';
import 'package:protein_tracker/domain/proteins/protein.dart';
import 'package:protein_tracker/domain/statistics/time_series_protein.dart';
import 'package:protein_tracker/infrastructure/statistics/statistics_repository.dart';

import './statistics_event.dart';
import './statistics_state.dart';

@injectable
class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final StatisticsRepitory statisticsRepository;
  final ProteinsBloc proteinsBloc;

  StreamSubscription proteinsSubscription;

  StatisticsBloc(this.statisticsRepository, this.proteinsBloc)
      : assert(proteinsBloc != null),
        assert(statisticsRepository != null),
        super(proteinsBloc.state is ProteinsLoadSuccess
                ? StatisticsLoadSuccess((proteinsBloc as ProteinsLoadSuccess)
                    .proteins
                    .map((e) => TimeSeriesProtein(DateTime.now(), e.amount))
                    .toList())
                : StatisticsLoadInProgress()
            // StatisticsLoadInProgress()
            ) {
    print('hello');
    print(proteinsBloc.isEmpty);
    proteinsSubscription = proteinsBloc.listen((state) {
      if (state is ProteinsLoadSuccess) {
        print('proteins updated');
        add(StatisticsUpdated((proteinsBloc as ProteinsLoadSuccess)
            .proteins
            .map((e) => TimeSeriesProtein(DateTime.now(), e.amount))
            .toList()));
      }
    });
  }

  @override
  Future<void> close() {
    proteinsSubscription.cancel();
    return super.close();
  }

  @override
  Stream<StatisticsState> mapEventToState(
    StatisticsEvent event,
  ) async* {
    if (event is StatisticsLoaded) {
      yield* _mapStatisticsLoadedToState();
    } else if (event is StatisticsUpdated) {
      yield* _mapStatisticsUpdateToState(event.proteins);
    }
  }

  Stream<StatisticsState> _mapStatisticsLoadedToState() async* {
    try {
      List<TimeSeriesProtein> chartData =
          await this.statisticsRepository.getMonthlyProteinData(
              // (proteinsBloc.state as ProteinsLoadSuccess).proteins
              );

      yield StatisticsLoadSuccess(
        chartData,
      );
    } catch (_) {
      yield StatisticsLoadFailure();
    }
  }

  Stream<StatisticsState> _mapStatisticsUpdateToState(
      List<TimeSeriesProtein> proteins) async* {
    try {
      List<TimeSeriesProtein> chartData =
          await this.statisticsRepository.getMonthlyProteinData();
      print("PROT2222:${proteins.length}");
      yield StatisticsLoadSuccess(
        chartData,
      );
    } catch (_) {
      yield StatisticsLoadFailure();
    }
  }
}
