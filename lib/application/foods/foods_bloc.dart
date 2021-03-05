import 'dart:async';

import 'package:bloc/bloc.dart';
// import 'package:food_tracker/domain/food.dart';
// import 'package:food_tracker/repository/food_repository.dart';
import 'package:protein_tracker/domain/foods/food.dart';
import './foods_event.dart';
import './foods_state.dart';

// class FoodsBloc extends Bloc<FoodsEvent, FoodsState> {
//   FoodsBloc() : super(FoodsInitial());

//   @override
//   Stream<FoodsState> mapEventToState(
//     FoodsEvent event,
//   ) async* {
//     // TODO: implement mapEventToState
//   }
// }

// import 'dart:async';

// import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:protein_tracker/infrastructure/foods/food_repository.dart';
// import './foods_event.dart';
// import './foods_state.dart';
import 'package:protein_tracker/infrastructure/foods/food_entity.dart';

@injectable
class FoodsBloc extends Bloc<FoodsEvent, FoodsState> {
  final FoodRepository foodRepository;
  FoodsBloc({
    @required this.foodRepository,
  }) : super(FoodsLoadInProgress());

  @override
  Stream<FoodsState> mapEventToState(
    FoodsEvent event,
  ) async* {
    if (event is FoodsLoaded) {
      yield* _mapFoodsLoadedToState();
    } else if (event is FoodAdded) {
      yield* _mapFoodAddedToState(event);
    } else if (event is FoodDeleted) {
      yield* _mapTodoDeletedToState(event);
    } else if (event is FoodUpdated) {
      yield* _mapFoodUpdatedToState(event);
    } else if (event is FoodOrderedAscending) {
      yield* _mapTodoFoodOrderedAscendingState(event);
    } else if (event is FoodOrderedDescending) {
      yield* _mapTodoFoodOrderedDescendingState(event);
    }
  }

  Stream<FoodsState> _mapFoodsLoadedToState() async* {
    try {
      List<FoodEntity> foods = await this.foodRepository.getAllFoods();
      print("PROT:${foods.length}");
      yield FoodsLoadSuccess(
        foods.map((e) => Food.fromEntity(e)).toList(),
      );
    } catch (_) {
      yield FoodsLoadFailure();
    }
  }

  Stream<FoodsState> _mapFoodAddedToState(FoodAdded event) async* {
    if (state is FoodsLoadSuccess) {
      final List<Food> updatedFoods =
          List.from((state as FoodsLoadSuccess).foods)..add(event.food);
      yield FoodsLoadSuccess(updatedFoods);
      await _saveFood(event.food);
    }
  }

  Stream<FoodsState> _mapFoodUpdatedToState(FoodUpdated event) async* {
    if (state is FoodsLoadSuccess) {
      final List<Food> updatedTodos =
          (state as FoodsLoadSuccess).foods.map((food) {
        return food.id == event.food.id ? event.food : food;
      }).toList();
      yield FoodsLoadSuccess(updatedTodos);
      foodRepository.updateFood(event.food.toEntity());
    }
  }

  Stream<FoodsState> _mapTodoDeletedToState(FoodDeleted event) async* {
    if (state is FoodsLoadSuccess) {
      await foodRepository.deleteFoodById(event.food.toEntity());
      // print('PROTEINID deleted2: ${event.food.id}');
      final updatedFoods = (state as FoodsLoadSuccess)
          .foods
          .where((food) => food.id != event.food.id)
          .toList();
      yield FoodsLoadSuccess(updatedFoods);
    }
  }

  Stream<FoodsState> _mapTodoFoodOrderedAscendingState(
      FoodOrderedAscending event) async* {
    if (state is FoodsLoadSuccess) {
      final _updatedFoods = List<Food>.from((state as FoodsLoadSuccess).foods)
        ..sort((a, b) => a.name.compareTo(b.name));

      yield FoodsLoadSuccess(_updatedFoods);
      // _saveFood(updatedFoods);
    }
  }

  Stream<FoodsState> _mapTodoFoodOrderedDescendingState(
      FoodOrderedDescending event) async* {
    if (state is FoodsLoadSuccess) {
      final _updatedFoodsDescending =
          List<Food>.from((state as FoodsLoadSuccess).foods)
            ..sort((b, a) => a.name.compareTo(b.name));
      yield FoodsLoadSuccess(_updatedFoodsDescending);
      // _saveFood(updatedFoods);
    }
  }

  // void orderFoodsAscending() {
  //   List<Food> orderList = currentList;
  //   orderList.sort((a, b) => a.name.compareTo(b.name));
  //   _foodList.add(orderList);
  // }

  // void orderFoodsDescending() {
  //   List<Food> orderList = currentList;
  //   orderList.sort((a, b) => a.name.compareTo(b.name));
  //   List<Food> reversedList = orderList.reversed.toList();
  //   _foodList.add(reversedList);
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

  _saveFood(Food food) {
    foodRepository.insertFood(food.toEntity());
  }
}
