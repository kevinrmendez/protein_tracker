import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/bloc/FoodService.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

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
      appBar: WidgetUtils.appBarBackArrow(
          translatedText(
            "appbar_food_list",
            context,
          ),
          context,
          actions: [
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
                child: WidgetUtils.iconText(
              context,
              icon: Icons.room_service,
              text: translatedText(
                "food_list_text_empty",
                context,
              ),
            ));
          } else {
            return ListView.builder(
                itemCount: foodListServices.currentList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  Food foodItem = snapshot.data[index];
                  return Column(
                    children: <Widget>[
                      Card(
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
                                        builder: (_) =>
                                            EditFoodDialog(foodItem));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    var foodId = await foodListServices
                                        .getFoodId(foodItem);

                                    foodListServices.remove(foodId, index);
                                  },
                                ),
                              ],
                            )),
                      ),
                      index == snapshot.data.length - 1
                          ? Container(
                              margin: EdgeInsets.only(top: 30),
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                            )
                          : SizedBox()
                    ],
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SecondaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
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
        height: MediaQuery.of(context).size.height * .46,
        title: translatedText(
          "food_dialog_add_title",
          context,
        ),
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
                    labelText: translatedText(
                      "food_dialog_label_food_name",
                      context,
                    ),
                    onChanged: (value) {
                      setState(() {
                        foodName = value;
                      });
                    },
                    validator: (value) {
                      List<String> currentFoods =
                          foodListServices.currentListFoodName;
                      if (value.isEmpty) {
                        return translatedText(
                          "food_error_food_value_empty",
                          context,
                        );
                      }
                      if (currentFoods.contains(value)) {
                        return translatedText(
                          "food_error_food_value_duplicate",
                          context,
                        );
                      }
                      return null;
                    },
                  ),
                  WidgetUtils.inputField(
                    keyboardType: TextInputType.number,
                    controller: _proteinAmountController,
                    labelText: translatedText(
                      "food_dialog_label_protein_amount",
                      context,
                    ),
                    onChanged: (value) {
                      setState(() {
                        proteinAmount = int.parse(value);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return translatedText(
                          "food_error_value_empty",
                          context,
                        );
                      }
                      if (value == "0") {
                        return translatedText(
                          "food_error_value_0",
                          context,
                        );
                      }
                      if (int.parse(value) > 500) {
                        return translatedText(
                          "food_error_value_too_high",
                          context,
                        );
                      }
                      return null;
                    },
                  ),
                  WidgetUtils.button(context,
                      text: translatedText(
                        "button_add",
                        context,
                      ),
                      color: DarkGreyColor, onPressed: () async {
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
        height: MediaQuery.of(context).size.height * .46,
        title: translatedText(
          "food_dialog_edit_title",
          context,
        ),
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
                    labelText: translatedText(
                      "food_dialog_label_food_name",
                      context,
                    ),
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
                    labelText: translatedText(
                      "food_dialog_label_protein_amount",
                      context,
                    ),
                    onChanged: (value) {
                      setState(() {
                        proteinAmount = int.parse(value);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return translatedText(
                          "food_error_value_empty",
                          context,
                        );
                      }
                      if (value == "0") {
                        return translatedText(
                          "food_error_value_0",
                          context,
                        );
                      }
                      if (int.parse(value) > 500) {
                        return translatedText(
                          "food_error_value_too_high",
                          context,
                        );
                      }
                      return null;
                    },
                  ),
                  WidgetUtils.button(context,
                      text: translatedText(
                        "button_edit",
                        context,
                      ),
                      color: DarkGreyColor, onPressed: () async {
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
