import 'package:equatable/equatable.dart';

// abstract class FoodsEvent extends Equatable {
//   const FoodsEvent();

//   @override
//   List<Object> get props => [];
// }

import 'package:protein_tracker/model/foods/food.dart';

abstract class FoodsEvent extends Equatable {
  const FoodsEvent();

  @override
  List<Object> get props => [];
}

class FoodsLoaded extends FoodsEvent {}

class FoodAdded extends FoodsEvent {
  final Food food;

  const FoodAdded(this.food);

  @override
  List<Object> get props => [food];

  @override
  String toString() => 'FoodAdded { food: $food }';
}

class FoodUpdated extends FoodsEvent {
  final Food food;

  const FoodUpdated(this.food);

  @override
  List<Object> get props => [food];

  @override
  String toString() => 'FoodUpdated { updatedFood: $food }';
}

class FoodDeleted extends FoodsEvent {
  final Food food;

  const FoodDeleted(this.food);

  @override
  List<Object> get props => [food];

  @override
  String toString() => 'FoodDeleted { food: $food }';
}

class FoodOrderedAscending extends FoodsEvent {
  final List<Food> foods;

  const FoodOrderedAscending(this.foods);

  @override
  List<Object> get props => [foods];

  @override
  String toString() => 'FoodOrderedAscending { foods: $foods}';
}

class FoodOrderedDescending extends FoodsEvent {
  final List<Food> foods;

  const FoodOrderedDescending(this.foods);

  @override
  List<Object> get props => [foods];

  @override
  String toString() => 'FoodOrderedAscending { foods: $foods}';
}
