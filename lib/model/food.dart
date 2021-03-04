// class Food {
//   int id;
//   String name;
//   int proteinAmount;

//   Food({this.id, this.name, this.proteinAmount});

//   factory Food.fromJson(Map<String, dynamic> data) => Food(
//         id: data['id'],
//         name: data['name'],
//         proteinAmount: data['proteinAmount'],
//       );

//   Map<String, dynamic> toJson() => {
//         // "id": this.id,
//         "name": this.name,
//         "proteinAmount": this.proteinAmount,
//       };
// }

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import './food_entity.dart';

class Food extends Equatable {
  final String id;
  final String name;
  final int proteinAmount;

  Food({String id, this.name, this.proteinAmount})
      : this.id = id ?? Uuid().v1();

  factory Food.fromJson(Map<String, dynamic> data) => Food(
        id: data['id'],
        name: data['name'],
        proteinAmount: data['proteinAmount'],
      );

  Map<String, dynamic> toJson() => {
        // "id": this.id,
        "name": this.name,
        "proteinAmount": this.proteinAmount,
      };

  Food copyWith({String id, String name, int proteinAmount, String date}) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      proteinAmount: proteinAmount ?? this.proteinAmount,
    );
  }

  @override
  List<Object> get props => [id, name, proteinAmount];

  FoodEntity toEntity() {
    return FoodEntity(id: id, name: name, proteinAmount: proteinAmount);
  }

  static Food fromEntity(FoodEntity entity) {
    return Food(
      id: entity.id ?? Uuid().v1(),
      name: entity.name,
      proteinAmount: entity.proteinAmount,
    );
  }
}
