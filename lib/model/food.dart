class Food {
  int id;
  String name;
  int proteinAmount;

  Food({this.id, this.name, this.proteinAmount});

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
}
