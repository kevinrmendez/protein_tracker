import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Protein extends Equatable {
  final String id;
  final String name;
  final int amount;
  final String date;

  Protein({String id, this.name, this.amount, this.date})
      : this.id = id ?? Uuid().v4();

  factory Protein.fromJson(Map<String, dynamic> data) => Protein(
      id: data['id'],
      name: data['name'],
      amount: data['amount'],
      date: data['date']);

  Map<String, dynamic> toJson() => {
        // "id": this.id,
        "name": this.name,
        "amount": this.amount,
        "date": this.date,
      };

  Protein copyWith({String id, String name, int amount, String date}) {
    return Protein(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  @override
  List<Object> get props => [id, name, amount, date];
}
