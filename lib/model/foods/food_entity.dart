import 'package:hive/hive.dart';

part 'food_entity.g.dart';

@HiveType(typeId: 2)
class FoodEntity extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int proteinAmount;

  FoodEntity({this.id, this.name, this.proteinAmount});

  @override
  int get hashCode => name.hashCode ^ proteinAmount.hashCode ^ id.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          proteinAmount == other.proteinAmount &&
          id == other.id;

  static FoodEntity fromJson(Map<String, dynamic> data) => FoodEntity(
        id: data['id'] as String,
        name: data['name'] as String,
        proteinAmount: data['proteinAmount'] as int,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "proteinAmount": proteinAmount,
      };
}

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
