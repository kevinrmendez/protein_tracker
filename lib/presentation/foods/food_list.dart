import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/foods/foods.dart';
import '../../main.dart';
import '../../model/foods/food.dart';
import '../../utils/colors.dart';
import '../../utils/localization_utils.dart';
import '../../utils/widgetUtils.dart';

class FoodList extends StatefulWidget {
  FoodList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
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
                              onTap: () {
                                Navigator.pop(context, foodItem);
                              },
                              title: Text(foodItem.name),
                              subtitle: Text(
                                  "${foodItem.proteinAmount.toString()} gr"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[],
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
                  }));
    });
  }
}
