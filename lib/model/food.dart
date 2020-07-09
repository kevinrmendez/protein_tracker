class Food {
  int id;
  String name;
  int proteinAmount;

  Food({this.id, this.name, this.proteinAmount});

  factory Food.fromJson(Map<String, dynamic> data) => Food(
        id: data['id'],
        name: data['name'],
        //Since sqlite doesn't have boolean type for true/false
        //we will 0 to denote that it is false
        //and 1 for true
        proteinAmount: data['proteinAmount'],
      );

  Map<String, dynamic> toJson() => {
        //This will be used to convert Todo objects that
        //are to be stored into the datbase in a form of JSON
        "id": this.id,
        "name": this.name,
        "proteinAmount": this.proteinAmount,
      };
}
