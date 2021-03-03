import 'package:equatable/equatable.dart';
import 'package:protein_tracker/model/protein.dart';

abstract class ProteinsEvent extends Equatable {
  const ProteinsEvent();

  @override
  List<Object> get props => [];
}

class ProteinsLoaded extends ProteinsEvent {}

class ProteinAdded extends ProteinsEvent {
  final Protein protein;

  const ProteinAdded(this.protein);

  @override
  List<Object> get props => [protein];

  @override
  String toString() => 'ProteinAdded { protein: $protein }';
}

class ProteinUpdated extends ProteinsEvent {
  final Protein protein;

  const ProteinUpdated(this.protein);

  @override
  List<Object> get props => [protein];

  @override
  String toString() => 'ProteinUpdated { updatedProtein: $protein }';
}

class ProteinDeleted extends ProteinsEvent {
  final Protein protein;

  const ProteinDeleted(this.protein);

  @override
  List<Object> get props => [protein];

  @override
  String toString() => 'ProteinDeleted { protein: $protein }';
}
