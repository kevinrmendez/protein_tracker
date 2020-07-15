import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:protein_tracker/bloc/FoodService.dart';
import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/dao/protein_dao.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class TrackerScreen extends StatefulWidget {
  TrackerScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
      appBar: WidgetUtils.appBarBackArrow("Today's protein", context),
      body: StreamBuilder<List<Protein>>(
        stream: proteinListServices.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if (snapshot.data.length == 0) {
            return Center(
                child: WidgetUtils.imageText(context,
                    text: 'your protein list is empty',
                    asset: AppAssets.protein_icon_gray));
          } else {
            return ListView.builder(
                itemCount: proteinListServices.currentList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  Protein proteinItem = snapshot.data[index];
                  print("PROTEIN ITEM ID: ${proteinItem.id}");
                  return Card(
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
        height: MediaQuery.of(context).size.height * .6,
        title: 'Add protein',
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _foodNameController,
                    decoration: InputDecoration(
                      hintText: 'Food name',
                      border: OutlineInputBorder(),
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
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _proteinAmountController,
                    decoration: InputDecoration(
                      hintText: 'Protein amount in gr',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        proteinAmount = int.parse(value);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'protein amount is empty';
                      }
                      return null;
                    },
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text('From food list')),
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
                          .firstWhere((food) => food.name == newValue);
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
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  WidgetUtils.button(
                      text: "Add",
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          print('add food');
                          print(foodName);
                          print(proteinAmount);
                          DateTime now = DateTime.now();
                          final DateFormat formatter =
                              DateFormat('dd-MMMM-yyyy');
                          final String formattedDateNow = formatter.format(now);
                          Protein protein = Protein(
                              name: foodName,
                              amount: proteinAmount,
                              date: formattedDateNow);

                          proteinListServices.add(protein);
                          proteinService.updateConsumedProtein();

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
        height: MediaQuery.of(context).size.height * .6,
        title: 'Edit protein',
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _foodNameController,
                    decoration: InputDecoration(
                      hintText: 'Food name',
                      border: OutlineInputBorder(),
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
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _proteinAmountController,
                    decoration: InputDecoration(
                      hintText: 'Protein amount in gr',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        proteinAmount = int.parse(value);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'protein amount is empty';
                      }
                      return null;
                    },
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text('From food list')),
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
                          .firstWhere((food) => food.name == newValue);
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
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  WidgetUtils.button(
                      text: "Edit",
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          var proteinId = await proteinListServices
                              .getProteinId(widget.protein);
                          print("PROTEIN ID FROM DB: $proteinId ");
                          widget.protein.id = proteinId;
                          widget.protein.name = foodName;
                          widget.protein.amount = proteinAmount;
                          proteinListServices.update(widget.protein);

                          proteinService.updateConsumedProtein();

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