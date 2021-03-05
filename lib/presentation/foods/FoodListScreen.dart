import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protein_tracker/presentation/foods/widgets/edit_food_dialog.dart';
import 'package:protein_tracker/presentation/foods/widgets/add_food_dialog.dart';

import '../../bloc/foods/foods.dart';
import '../../main.dart';
import '../../model/foods/food.dart';
import '../../utils/colors.dart';
import '../../utils/localization_utils.dart';
import '../../utils/widgetUtils.dart';

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
    return BlocBuilder<FoodsBloc, FoodsState>(
        builder: (BuildContext context, state) {
      if (state is FoodsLoadInProgress) {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (state is FoodsLoadFailure) {
        return Scaffold(body: Center(child: Text('error')));
      }
      var foods = (state as FoodsLoadSuccess).foods;

      return Scaffold(
          appBar: WidgetUtils.appBarBackArrow(
              title: translatedText(
                "appbar_food_list",
                context,
              ),
              context: context,
              actions: [
                PopupMenuButton<Order>(
                  onSelected: (order) {
                    switch (order) {
                      case Order.ascending:
                        {
                          BlocProvider.of<FoodsBloc>(context)
                              .add(FoodOrderedAscending(foods));
                        }
                        break;
                      case Order.descending:
                        {
                          BlocProvider.of<FoodsBloc>(context)
                              .add(FoodOrderedDescending(foods));
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
          body: foods.isEmpty
              ? Center(
                  child: WidgetUtils.iconText(
                  context,
                  icon: Icons.room_service,
                  text: translatedText(
                    "food_list_text_empty",
                    context,
                  ),
                ))
              : ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    Food foodItem = foods[index];
                    return Column(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                              title: Text(foodItem.name),
                              subtitle: Text(
                                  "${foodItem.proteinAmount.toString()} gr"),
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
                                      BlocProvider.of<FoodsBloc>(context)
                                          .add(FoodDeleted(foods[index]));
                                    },
                                  ),
                                ],
                              )),
                        ),
                        index == foods.length - 1
                            ? Container(
                                margin: EdgeInsets.only(top: 30),
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                              )
                            : SizedBox()
                      ],
                    );
                  }),
          floatingActionButton: FloatingActionButton(
            backgroundColor: SecondaryColor,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(context: context, builder: (_) => AddFoodDialog());
            },
          ));
    });
  }
}
