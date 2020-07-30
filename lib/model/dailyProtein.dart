class DailyProtein {
  int id;
  String date;
  int totalProtein;
  int goal;
  int isGoalAchieved;

  DailyProtein(
      {this.id, this.date, this.totalProtein, this.goal, this.isGoalAchieved});

  factory DailyProtein.fromJson(Map<String, dynamic> data) => DailyProtein(
        id: data['id'],
        date: data['date'],
        totalProtein: data['totalProtein'],
        goal: data['goal'],
        isGoalAchieved: data['isGoalAchieved'],
      );

  Map<String, dynamic> toJson() => {
        // "id": this.id,
        "date": this.date,
        "totalProtein": this.totalProtein,
        "goal": this.goal,
        "isGoalAchieved": this.isGoalAchieved,
      };

  @override
  String toString() {
    return 'Contact{id: $id, date: $date, totalProtein: $totalProtein, goal: $goal, isGoalAchieved: $isGoalAchieved}';
  }
}
