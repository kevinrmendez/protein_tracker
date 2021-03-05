import 'dart:async';

import 'package:bloc/bloc.dart';

import './statistics_event.dart';
import './statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc() : super(StatisticsLoadInProgress());

  @override
  Stream<StatisticsState> mapEventToState(
    StatisticsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
