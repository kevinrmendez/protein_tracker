import 'package:equatable/equatable.dart';

class Protein extends Equatable {
  final int id;
  final String name;
  final int amount;
  final String date;

  Protein({this.id, this.name, this.amount, this.date});

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

  Protein copyWith({bool complete, String id, String note, String task}) {
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
