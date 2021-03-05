import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protein_tracker/model/foods/food.dart';
import 'package:protein_tracker/application/foods/foods.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

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
        height: MediaQuery.of(context).size.height * .52,
        title: translatedText(
          "food_dialog_edit_title",
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
                      width: MediaQuery.of(context).size.width,
                      text: translatedText(
                        "button_edit",
                        context,
                      ),
                      color: Theme.of(context).buttonColor,
                      onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      BlocProvider.of<FoodsBloc>(context).add(FoodUpdated(
                          widget.food.copyWith(
                              name: foodName, proteinAmount: proteinAmount)));

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
