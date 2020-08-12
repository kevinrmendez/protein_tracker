import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:protein_tracker/bloc/FoodService.dart';
import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/bloc/StatisticsService.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';

import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';

class TrackerScreen extends StatefulWidget {
  TrackerScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TrackerScreenState createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow(
          translatedText(
            "appbar_tracker",
            context,
          ),
          context,
          actions: [
            PopupMenuButton<Order>(
              onSelected: (order) {
                switch (order) {
                  case Order.ascending:
                    {
                      proteinListServices.orderFoodsAscending();
                    }
                    break;
                  case Order.descending:
                    {
                      proteinListServices.orderFoodsDescending();
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
                  PopupMenuItem<Order>(
                    child: Text(translatedText(
                      "popup_menu_item_ascending",
                      context,
                    )),
                    value: Order.ascending,
                  ),
                  PopupMenuItem<Order>(
                    child: Text(translatedText(
                      "popup_menu_item_descending",
                      context,
                    )),
                    value: Order.descending,
                  ),
                ];
              },
            )
          ]),
      body: StreamBuilder<List<Protein>>(
        stream: proteinListServices.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if (snapshot.data.length == 0) {
            return Center(
                child: WidgetUtils.imageText(context,
                    text: translatedText(
                      "tracker_list_empty",
                      context,
                    ),
                    asset: AppAssets.protein_icon_gray));
          } else {
            return ListView.builder(
                itemCount: proteinListServices.currentList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  Protein proteinItem = snapshot.data[index];
                  print("PROTEIN ITEM ID: ${proteinItem.id}");
                  return Column(
                    children: <Widget>[
                      Card(
                        child: ListTile(
                            title: Text(proteinItem.name),
                            subtitle: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("${proteinItem.amount.toString()} gr"),
                                  Text(proteinItem.date)
                                ],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            EditProteinDialog(proteinItem));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    var proteinId = await proteinListServices
                                        .getProteinId(proteinItem);
                                    proteinListServices.remove(proteinId);
                                    proteinService.updateConsumedProtein();
                                    statisticsService.updateStatisticsData();
                                  },
                                ),
                              ],
                            )),
                      ),
                      //TODO: FIND ANOTHER WAY TO ADD FOOTER TO THE LIST
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

  String dropdownValueGoal;
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
        height: MediaQuery.of(context).size.height * .52,
        title: translatedText(
          "tracker_dialog_title_add_protein",
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
                        "tracker_dialog_label_food_name",
                        context,
                      ),
                      onChanged: (value) {
                        setState(() {
                          foodName = value;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return translatedText(
                            "tracker_error_value_empty",
                            context,
                          );
                        }
                        return null;
                      }),
                  WidgetUtils.inputField(
                    keyboardType: TextInputType.number,
                    controller: _proteinAmountController,
                    labelText: translatedText(
                      "tracker_dialog_label_protein_amount",
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
                          "tracker_error_protein_value_empty",
                          context,
                        );
                      }
                      if (value == "0") {
                        return translatedText(
                          "tracker_error_protein_value_0",
                          context,
                        );
                      }
                      if (int.parse(value) > 1000) {
                        return translatedText(
                          "tracker_error_value_too_high",
                          context,
                        );
                      }
                      return null;
                    },
                  ),
                  foodListServices.currentListFoodName.length > 0
                      ? Column(
                          children: <Widget>[
                            Container(
                                child: Text(translatedText(
                              "tracker_dialog_label_food_list",
                              context,
                            ))),
                            DropdownButton<String>(
                              value: dropdownValueGoal,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: PrimaryColor),
                              underline: Container(
                                height: 2,
                                color: Colors.grey,
                              ),
                              onChanged: (String newValue) {
                                Food food = foodListServices.currentList
                                    .firstWhere(
                                        (food) => food.name == newValue);
                                setState(() {
                                  dropdownValueGoal = newValue;
                                  _foodNameController.text = food.name;
                                  _proteinAmountController.text =
                                      food.proteinAmount.toString();
                                  foodName = _foodNameController.text;
                                  proteinAmount =
                                      int.parse(_proteinAmountController.text);
                                });
                              },
                              items: foodListServices.currentListFoodName
                                  // items: <String>['', 'banana', 'pear', 'nuts']
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 15,
                        ),
                  WidgetUtils.button(context,
                      width: MediaQuery.of(context).size.width,
                      text: translatedText(
                        "button_add",
                        context,
                      ),
                      color: DarkGreyColor, onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      print('add food');
                      print(foodName);
                      print(proteinAmount);
                      DateTime now = DateTime.now();
                      final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
                      final String formattedDateProteinAdded =
                          formatter.format(now);
                      Protein protein = Protein(
                          name: foodName,
                          amount: proteinAmount,
                          date: formattedDateProteinAdded);

                      proteinListServices.add(protein);

                      proteinService.updateConsumedProtein();
                      statisticsService.updateStatisticsData();

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

class EditProteinDialog extends StatefulWidget {
  final Protein protein;
  EditProteinDialog(this.protein);

  @override
  _EditProteinDialogState createState() => _EditProteinDialogState();
}

class _EditProteinDialogState extends State<EditProteinDialog> {
  final _formKey = GlobalKey<FormState>();

  String dropdownValueGoal;
  String foodName;
  int proteinAmount;
  final _foodNameController = TextEditingController();
  final _proteinAmountController = TextEditingController();
  @override
  void initState() {
    _foodNameController.text = widget.protein.name;
    _proteinAmountController.text = widget.protein.amount.toString();
    foodName = widget.protein.name;
    proteinAmount = widget.protein.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .52,
        title: translatedText(
          "tracker_dialog_title_edit_protein",
          context,
        ),
        showAd: false,
        child: Container(
          // height: 300,
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
                        "tracker_dialog_label_food_name",
                        context,
                      ),
                      onChanged: (value) {
                        setState(() {
                          foodName = value;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return translatedText(
                            "tracker_error_value_empty",
                            context,
                          );
                        }
                        return null;
                      }),
                  WidgetUtils.inputField(
                    keyboardType: TextInputType.number,
                    controller: _proteinAmountController,
                    labelText: translatedText(
                      "tracker_dialog_label_protein_amount",
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
                          "tracker_error_protein_value_empty",
                          context,
                        );
                      }
                      if (value == "0") {
                        return translatedText(
                          "tracker_error_protein_value_0",
                          context,
                        );
                      }
                      if (int.parse(value) > 500) {
                        return translatedText(
                          "tracker_error_value_too_high",
                          context,
                        );
                      }
                      return null;
                    },
                  ),
                  StreamBuilder<List<String>>(
                      stream: foodListServices.streamFoodName,
                      builder: (context, snapshot) {
                        if (snapshot.data == null ||
                            snapshot.data.length == 0) {
                          return SizedBox(
                            height: 15,
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              Container(
                                  child: Text(
                                translatedText(
                                  "tracker_dialog_label_food_list",
                                  context,
                                ),
                              )),
                              DropdownButton<String>(
                                value: dropdownValueGoal,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: PrimaryColor),
                                underline: Container(
                                  height: 2,
                                  color: Colors.grey,
                                ),
                                onChanged: (String newValue) {
                                  Food food = foodListServices.currentList
                                      .firstWhere(
                                          (food) => food.name == newValue);
                                  setState(() {
                                    dropdownValueGoal = newValue;
                                    _foodNameController.text = food.name;
                                    _proteinAmountController.text =
                                        food.proteinAmount.toString();
                                    foodName = _foodNameController.text;
                                    proteinAmount = int.parse(
                                        _proteinAmountController.text);
                                  });
                                },
                                items: snapshot.data
                                    // items: <String>['', 'banana', 'pear', 'nuts']
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        }
                      }),
                  WidgetUtils.button(context,
                      width: MediaQuery.of(context).size.width,
                      text: translatedText(
                        "button_edit",
                        context,
                      ),
                      color: DarkGreyColor, onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      var proteinId = await proteinListServices
                          .getProteinId(widget.protein);
                      print("PROTEIN ID FROM DB: $proteinId ");
                      widget.protein.id = proteinId;
                      widget.protein.name = foodName;
                      widget.protein.amount = proteinAmount;

                      proteinListServices.update(widget.protein);
                      statisticsService.updateStatisticsData();

                      proteinService.updateConsumedProtein();
                      statisticsService.updateStatisticsData();

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
