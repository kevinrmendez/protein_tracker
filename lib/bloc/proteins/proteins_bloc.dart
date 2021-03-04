import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/repository/protein_repository.dart';
import './proteins_event.dart';
import './proteins_state.dart';

@injectable
class ProteinsBloc extends Bloc<ProteinsEvent, ProteinsState> {
  final ProteinRepository proteinRepository;
  ProteinsBloc({
    @required this.proteinRepository,
  }) : super(ProteinsLoadInProgress());

  @override
  Stream<ProteinsState> mapEventToState(
    ProteinsEvent event,
  ) async* {
    if (event is ProteinsLoaded) {
      yield* _mapProteinsLoadedToState();
    } else if (event is ProteinAdded) {
      yield* _mapProteinAddedToState(event);
    } else if (event is ProteinDeleted) {
      yield* _mapTodoDeletedToState(event);
    } else if (event is ProteinUpdated) {
      yield* _mapProteinUpdatedToState(event);
    } else if (event is ProteinOrderedAscending) {
      yield* _mapTodoProteinOrderedAscendingState(event);
    } else if (event is ProteinOrderedDescending) {
      yield* _mapTodoProteinOrderedDescendingState(event);
    }
  }

  Stream<ProteinsState> _mapProteinsLoadedToState() async* {
    try {
      List<Protein> proteins = await this.proteinRepository.getAllProteins();
      print("PROT:${proteins.length}");
      yield ProteinsLoadSuccess(
        proteins,
      );
    } catch (_) {
      yield ProteinsLoadFailure();
    }
  }

  Stream<ProteinsState> _mapProteinAddedToState(ProteinAdded event) async* {
    if (state is ProteinsLoadSuccess) {
      final List<Protein> updatedProteins =
          List.from((state as ProteinsLoadSuccess).proteins)
            ..add(event.protein);
      yield ProteinsLoadSuccess(updatedProteins);
      await _saveProtein(event.protein);
    }
  }

  Stream<ProteinsState> _mapProteinUpdatedToState(ProteinUpdated event) async* {
    if (state is ProteinsLoadSuccess) {
      final List<Protein> updatedTodos =
          (state as ProteinsLoadSuccess).proteins.map((protein) {
        return protein.id == event.protein.id ? event.protein : protein;
      }).toList();
      yield ProteinsLoadSuccess(updatedTodos);
      proteinRepository.updateProtein(event.protein);
    }
  }

  Stream<ProteinsState> _mapTodoDeletedToState(ProteinDeleted event) async* {
    if (state is ProteinsLoadSuccess) {
      var deleted =
          await proteinRepository.deleteProteinById(event.protein.toEntity());
      print('PROTEINID deleted2: ${event.protein.id}');
      print("${deleted.toString()}");
      final updatedProteins = (state as ProteinsLoadSuccess)
          .proteins
          .where((protein) => protein.id != event.protein.id)
          .toList();
      yield ProteinsLoadSuccess(updatedProteins);
    }
  }

  Stream<ProteinsState> _mapTodoProteinOrderedAscendingState(
      ProteinOrderedAscending event) async* {
    if (state is ProteinsLoadSuccess) {
      final _updatedProteins =
          List<Protein>.from((state as ProteinsLoadSuccess).proteins)
            ..sort((a, b) => a.name.compareTo(b.name));

      yield ProteinsLoadSuccess(_updatedProteins);
      // _saveProtein(updatedProteins);
    }
  }

  Stream<ProteinsState> _mapTodoProteinOrderedDescendingState(
      ProteinOrderedDescending event) async* {
    if (state is ProteinsLoadSuccess) {
      final _updatedProteins =
          List<Protein>.from((state as ProteinsLoadSuccess).proteins)
            ..sort((a, b) => a.name.compareTo(b.name))
            ..reversed;
      yield ProteinsLoadSuccess(_updatedProteins);
      // _saveProtein(updatedProteins);
    }
  }

  // void orderFoodsAscending() {
  //   List<Protein> orderList = currentList;
  //   orderList.sort((a, b) => a.name.compareTo(b.name));
  //   _proteinList.add(orderList);
  // }

  // void orderFoodsDescending() {
  //   List<Protein> orderList = currentList;
  //   orderList.sort((a, b) => a.name.compareTo(b.name));
  //   List<Protein> reversedList = orderList.reversed.toList();
  //   _proteinList.add(reversedList);
  // }
  // Stream<TodosState> _mapClearCompletedToState() async* {
  //   if (state is TodosLoadSuccess) {
  //     final List<Todo> updatedTodos = (state as TodosLoadSuccess)
  //         .todos
  //         .where((todo) => !todo.complete)
  //         .toList();
  //     yield TodosLoadSuccess(updatedTodos);
  //     _saveTodos(updatedTodos);
  //   }
  // }

  Future _saveProtein(Protein protein) {
    return proteinRepository.insertProtein(protein.toEntity());
  }
}
