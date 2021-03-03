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
    }
  }

  Stream<ProteinsState> _mapProteinsLoadedToState() async* {
    try {
      final proteins = await this.proteinRepository.getAllProteins();
      yield ProteinsLoadSuccess(
        proteins.toList(),
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
      _saveProtein(updatedProteins);
    }
  }

  // Stream<TodosState> _mapTodoUpdatedToState(TodoUpdated event) async* {
  //   if (state is TodosLoadSuccess) {
  //     final List<Todo> updatedTodos =
  //         (state as TodosLoadSuccess).todos.map((todo) {
  //       return todo.id == event.todo.id ? event.todo : todo;
  //     }).toList();
  //     yield TodosLoadSuccess(updatedTodos);
  //     _saveTodos(updatedTodos);
  //   }
  // }

  // Stream<TodosState> _mapTodoDeletedToState(TodoDeleted event) async* {
  //   if (state is TodosLoadSuccess) {
  //     final updatedTodos = (state as TodosLoadSuccess)
  //         .todos
  //         .where((todo) => todo.id != event.todo.id)
  //         .toList();
  //     yield TodosLoadSuccess(updatedTodos);
  //     _saveTodos(updatedTodos);
  //   }
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

  Future _saveProtein(List<Protein> proteins) {
    return proteinRepository.insertProtein(proteins);
  }
}
