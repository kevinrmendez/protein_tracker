class Protein {
  int id;
  String name;
  int amount;
  String date;

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
}
