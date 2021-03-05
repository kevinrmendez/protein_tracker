import 'package:equatable/equatable.dart';
import 'package:protein_tracker/domain/proteins/protein.dart';
import 'package:protein_tracker/domain/statistics/time_series_protein.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

class StatisticsLoadInProgress extends StatisticsState {}

class StatisticsLoadSuccess extends StatisticsState {
  final List<TimeSeriesProtein> proteins;

  const StatisticsLoadSuccess([this.proteins = const []]);

  @override
  List<Object> get props => [proteins];

  @override
  String toString() => 'ProteinLoadSuccess { protein: $proteins }';
}

class StatisticsLoadFailure extends StatisticsState {}
