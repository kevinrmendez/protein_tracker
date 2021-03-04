import 'package:flutter/material.dart';
import 'package:protein_tracker/bloc/FoodService.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class FoodList extends StatefulWidget {
  FoodList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder<List<Food>>(
        stream: foodListServices.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            default:
              // print(snapshot.data);
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
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: SecondaryColor,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //     showDialog(context: context, builder: (_) => AddProteinDialog());
      //   },
      // ),
    );
  }
}
