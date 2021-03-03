import 'package:equatable/equatable.dart';
import 'package:protein_tracker/model/protein.dart';

abstract class ProteinsState extends Equatable {
  const ProteinsState();

  @override
  List<Object> get props => [];
}

class ProteinsLoadInProgress extends ProteinsState {}

class ProteinsLoadSuccess extends ProteinsState {
  final List<Protein> proteins;

  const ProteinsLoadSuccess([this.proteins = const []]);

  @override
  List<Object> get props => [proteins];

  @override
  String toString() => 'ProteinLoadSuccess { protein: $proteins }';
}

class ProteinsLoadFailure extends ProteinsState {}
