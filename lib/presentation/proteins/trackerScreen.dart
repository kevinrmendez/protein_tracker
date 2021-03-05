import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/presentation/proteins/widgets/add_protein_dialog.dart';
import 'package:protein_tracker/presentation/proteins/widgets/edit_protein_dialog.dart';
import 'package:protein_tracker/bloc/proteins/proteins.dart';

import '../../bloc/ProteinService.dart';
import '../../bloc/StatisticsService.dart';
import '../../main.dart';
import '../../model/protein.dart';
import '../../utils/appAssets.dart';
import '../../utils/colors.dart';
import '../../utils/localization_utils.dart';
import '../../utils/widgetUtils.dart';

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
    return BlocBuilder<ProteinsBloc, ProteinsState>(
      builder: (context, state) {
        if (state is ProteinsLoadInProgress) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is ProteinsLoadFailure) {
          return Scaffold(body: Center(child: Text('error')));
        }
        var proteins = (state as ProteinsLoadSuccess).proteins;
        return Scaffold(
          appBar: WidgetUtils.appBarBackArrow(
              title: translatedText(
                "appbar_tracker",
                context,
              ),
              context: context,
              actions: [
                PopupMenuButton<Order>(
                  onSelected: (order) {
                    switch (order) {
                      case Order.ascending:
                        {
                          BlocProvider.of<ProteinsBloc>(context)
                              .add(ProteinOrderedAscending(proteins));
                        }
                        break;
                      case Order.descending:
                        {
                          BlocProvider.of<ProteinsBloc>(context)
                              .add(ProteinOrderedDescending(proteins));
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
          body: proteins.isEmpty
              ? Center(
                  child: WidgetUtils.imageText(context,
                      text: translatedText(
                        "tracker_list_empty",
                        context,
                      ),
                      asset: AppAssets.protein_icon_gray))
              : ListView.builder(
                  itemCount: (state as ProteinsLoadSuccess).proteins.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    Protein proteinItem = proteins[index];
                    print("PROTEIN ITEM ID: ${proteinItem.id}");
                    print(index);
                    return Column(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                              title: Text(proteinItem.name ?? ""),
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
                                    onPressed: () {
                                      print(
                                          'DELETED PROTEIN: ${proteins[index].id}');
                                      BlocProvider.of<ProteinsBloc>(context)
                                          .add(ProteinDeleted(proteins[index]));

                                      // proteinService.updateConsumedProtein();
                                      // statisticsService.updateStatisticsData();
                                    },
                                  ),
                                ],
                              )),
                        ),
                        //TODO: FIND ANOTHER WAY TO ADD FOOTER TO THE LIST
                        index == proteins?.length - 1
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
              print('add food');
              showDialog(context: context, builder: (_) => AddProteinDialog());
            },
          ),
        );
      },
    );
  }
}
