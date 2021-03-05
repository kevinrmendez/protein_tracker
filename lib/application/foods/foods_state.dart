import 'package:equatable/equatable.dart';
import 'package:protein_tracker/model/foods/food.dart';

// abstract class FoodsState extends Equatable {
//   const FoodsState();

//   @override
//   List<Object> get props => [];
// }

// class FoodsInitial extends FoodsState {}

abstract class FoodsState extends Equatable {
  const FoodsState();

  @override
  List<Object> get props => [];
}

class FoodsLoadInProgress extends FoodsState {}

class FoodsLoadSuccess extends FoodsState {
  final List<Food> foods;

  const FoodsLoadSuccess([this.foods = const []]);

  @override
  List<Object> get props => [foods];

  @override
  String toString() => 'FoodLoadSuccess { food: $foods }';
}

class FoodsLoadFailure extends FoodsState {}
