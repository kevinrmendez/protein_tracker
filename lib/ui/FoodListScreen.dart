import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/bloc/FoodService.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

enum Order { ascending, descending }

class FoodListScreen extends StatefulWidget {
  FoodListScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow('Food List', context, actions: [
        PopupMenuButton<Order>(
          onSelected: (order) {
            switch (order) {
              case Order.ascending:
                {
                  foodListServices.orderFoodsAscending();
                }
                break;
              case Order.descending:
                {
                  foodListServices.orderFoodsDescending();
                }
                break;
              default:
            }
          },
          icon: Icon(Icons.more_vert, color: SecondaryColor),
          itemBuilder: (
            BuildContext context,
          ) {
            return [
              const PopupMenuItem<Order>(
                child: Text('Ascending Order'),
                value: Order.ascending,
              ),
              const PopupMenuItem<Order>(
                child: Text('Descending Order'),
                value: Order.descending,
              ),
            ];
          },
        )
      ]),
      body: StreamBuilder<List<Food>>(
        stream: foodListServices.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if (snapshot.data.length == 0) {
            return Center(
                child: WidgetUtils.iconText(context,
                    icon: Icons.room_service, text: 'your food list is empty'));
          } else {
            return ListView.builder(
                itemCount: foodListServices.currentList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  Food foodItem = snapshot.data[index];
                  return Card(
                    child: ListTile(
                        title: Text(foodItem.name),
                        subtitle:
                            Text("${foodItem.proteinAmount.toString()} gr"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => EditFoodDialog(foodItem));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                var foodId =
                                    await foodListServices.getFoodId(foodItem);

                                foodListServices.remove(foodId, index);
                              },
                            ),
                          ],
                        )),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PrimaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          print('add food');
          showDialog(context: context, builder: (_) => AddProteinDialog());
        },
      ),
    );
  }
}

class AddProteinDialog extends StatefulWidget {
  @override
  _AddProteinDialogState createState() => _AddProteinDialogState();
}

class _AddProteinDialogState extends State<AddProteinDialog> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValueGoal = "";
  String foodName;
  int proteinAmount;
  final _foodNameController = TextEditingController();
  final _proteinAmountController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .39,
        title: 'Add food',
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  WidgetUtils.inputField(
                    controller: _foodNameController,
                    labelText: 'Food name',
                    onChanged: (value) {
                      setState(() {
                        foodName = value;
                      });
                    },
                    validator: (value) {
                      List<String> currentFoods =
                          foodListServices.currentListFoodName;
                      if (value.isEmpty) {
                        return 'food is empty';
                      }
                      if (currentFoods.contains(value)) {
                        return "food already added";
                      }
                      return null;
                    },
                  ),
                  WidgetUtils.inputField(
                    keyboardType: TextInputType.number,
                    controller: _proteinAmountController,
                    labelText: 'Protein amount in gr',
                    onChanged: (value) {
                      setState(() {
                        proteinAmount = int.parse(value);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'protein amount is empty';
                      }
                      if (value == "0") {
                        return 'protein amount must be greater than 0';
                      }
                      return null;
                    },
                  ),
                  WidgetUtils.button(context, text: "Add", onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      print('add food');
                      print(foodName);
                      print(proteinAmount);
                      Food food =
                          Food(name: foodName, proteinAmount: proteinAmount);
                      foodListServices.add(food);

                      Navigator.pop(context);
                    } else {}
                  })
                ]),
              ),
            ],
          ),
        ));
  }
}

class EditFoodDialog extends StatefulWidget {
  final Food food;

  EditFoodDialog(this.food);

  @override
  _EditFoodDialogState createState() => _EditFoodDialogState();
}

class _EditFoodDialogState extends State<EditFoodDialog> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValueGoal = "";
  String foodName;
  int proteinAmount;
  final _foodNameController = TextEditingController();
  final _proteinAmountController = TextEditingController();
  @override
  void initState() {
    _foodNameController.text = widget.food.name;
    _proteinAmountController.text = widget.food.proteinAmount.toString();
    foodName = widget.food.name;
    proteinAmount = widget.food.proteinAmount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .39,
        title: 'Edit food',
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  WidgetUtils.inputField(
                    controller: _foodNameController,
                    labelText: 'Food name',
                    onChanged: (value) {
                      setState(() {
                        foodName = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'food is empty';
                      }
                      return null;
                    },
                  ),
                  WidgetUtils.inputField(
                    keyboardType: TextInputType.number,
                    controller: _proteinAmountController,
                    labelText: 'Protein amount in gr',
                    onChanged: (value) {
                      setState(() {
                        proteinAmount = int.parse(value);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'protein amount is empty';
                      }
                      if (value == "0") {
                        return 'protein amount must be greater than 0';
                      }
                      return null;
                    },
                  ),
                  WidgetUtils.button(context, text: "Edit",
                      onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      var foodId =
                          await foodListServices.getFoodId(widget.food);
                      widget.food.id = foodId;
                      widget.food.name = foodName;
                      widget.food.proteinAmount = proteinAmount;
                      foodListServices.update(widget.food);

                      Navigator.pop(context);
                    } else {}
                  })
                ]),
              ),
            ],
          ),
        ));
  }
}
