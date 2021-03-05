import 'package:equatable/equatable.dart';
import 'package:protein_tracker/domain/proteins/protein.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

class StatisticsLoaded extends StatisticsEvent {
  final List<Protein> proteins;
  const StatisticsLoaded(this.proteins);

  @override
  List<Object> get props => [proteins];

  @override
  String toString() => 'FilterUpdated { filter: $proteins }';
}

class StatisticsUpdated extends StatisticsEvent {
  final List<Protein> proteins;

  const StatisticsUpdated(this.proteins);

  @override
  List<Object> get props => [proteins];

  @override
  String toString() => 'FilterUpdated { filter: $proteins }';
}
