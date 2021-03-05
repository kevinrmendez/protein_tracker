import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protein_tracker/application/ProteinService.dart';
import 'package:protein_tracker/application/StatisticsService.dart';
import 'package:protein_tracker/application/proteins/proteins.dart';
import 'package:protein_tracker/domain/proteins/protein.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

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
                  WidgetUtils.button(context,
                      width: MediaQuery.of(context).size.width,
                      text: translatedText(
                        "button_edit",
                        context,
                      ),
                      color: Theme.of(context).buttonColor,
                      onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      BlocProvider.of<ProteinsBloc>(context).add(ProteinUpdated(
                          widget.protein.copyWith(
                              name: foodName, amount: proteinAmount)));

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
