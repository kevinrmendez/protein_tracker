import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/bloc/FoodService.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/bloc/StatisticsService.dart';
import 'package:protein_tracker/bloc/proteins/proteins.dart';
import 'package:protein_tracker/bloc/proteins/proteins_bloc.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

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
                      color: Theme.of(context).buttonColor,
                      onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      DateTime now = DateTime.now();
                      final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
                      final String formattedDateProteinAdded =
                          formatter.format(now);
                      BlocProvider.of<ProteinsBloc>(context).add(ProteinAdded(
                          Protein(
                              name: foodName,
                              amount: proteinAmount,
                              date: formattedDateProteinAdded)));

                      // proteinListServices.add(Protein(
                      //     name: foodName,
                      //     amount: proteinAmount,
                      //     date: formattedDateProteinAdded));

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
