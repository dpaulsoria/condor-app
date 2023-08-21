import 'package:flutter/material.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/constants/enums.dart';
import 'package:material_kit_flutter/models/carRide/carRide.dart';
import 'package:material_kit_flutter/utils/utils.dart';
import 'package:material_kit_flutter/widgets/drawer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HistoryApp extends StatefulWidget {
  const HistoryApp({Key? key}) : super(key: key);

  @override
  _HistoryAppState createState() => _HistoryAppState();
}

class _HistoryAppState extends State<HistoryApp> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  var allSecureStorage = {};

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Ultimas carreras"),
            backgroundColor: MaterialColors.blueMain),
        backgroundColor: MaterialColors.bgColorScreen,
        drawer: MaterialDrawer(currentPage: "historyApp"),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          enableTwoLevel: true,
          header: WaterDropHeader(),
          controller: refreshController,
          onRefresh: onRefresh,
          onLoading: onLoading,
          child: FutureBuilder(
              future: getVars(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CarRide>> snapshot) {
                if (snapshot.hasData) {
                  List<CarRide> data = snapshot.data ?? [];
                  return Container(
                    padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 10),
                    child: ListView.builder(
                      itemCount: data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        CarRide element = data[index];
                        String date = getTimeFromString(element.requestDate,
                                isLocal: true)
                            .toString()
                            .substring(0, 16);
                        return Card(
                          child: ListTile(
                              dense: true,
                              tileColor: Colors.white30,
                              leading: Text('#${element.id}'),
                              title: Text(
                                  "${element.driver} => ${element.passenger}",
                                  style: boldStyle(size: 14)),
                              trailing: PopupMenuButton<popupButtonDecisition>(
                                onSelected: (popupButtonDecisition result) {
                                  showInfo(context, element, date);
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<popupButtonDecisition>>[
                                  const PopupMenuItem<popupButtonDecisition>(
                                    value: popupButtonDecisition.view,
                                    child: Text('Ver'),
                                  ),
                                ],
                              )),
                        );
                      },
                    ),
                  );
                }
                return Container();
              }),
        ));
  }

  Future<List<CarRide>> getVars() async {
    try {
      allSecureStorage = await getAllSecureStorage();
      var carRideAll = await CarRide.getCarRideAll(
          allSecureStorage['codeUrbanization'] ?? '',
          allSecureStorage['user'] ?? '');
      carRideAll.removeWhere(
          (element) => (element.driver == null || element.passenger == null));
      return carRideAll;
    } on Exception catch (e) {
      print("getVars ${e.toString()}");
    }
    return [];
  }

  void showInfo(BuildContext context, CarRide carRide, String date) {
    String userName = allSecureStorage['user'];
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Resultado de carrera"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  textCustom('Fecha solicitud', isBold: true, size: 16),
                  Text('$date'),
                  Divider(),
                  userName != carRide.passenger
                      ? Column(
                          children: [
                            textCustom('Usuario pasajero',
                                isBold: true, size: 16),
                            Text('${carRide.passenger}'),
                            textCustom("Calificación otorgada",
                                isBold: true, size: 16),
                            carRide.finalComments != null
                                ? Text(
                                    '${carRide.finalComments!['ratingPassenger'] ?? 'Sin calificar'}')
                                : Container(),
                            textCustom("Comentarios", isBold: true, size: 16),
                            carRide.finalComments != null
                                ? Text(
                                    '${carRide.finalComments!['commentPassenger'] ?? ''}')
                                : Container(),
                          ],
                        )
                      : Container(),
                  Divider(),
                  userName != carRide.driver
                      ? Column(
                          children: [
                            textCustom('Usuario conductor',
                                isBold: true, size: 16),
                            Text('${carRide.driver}'),
                            textCustom("Calificación otorgada",
                                isBold: true, size: 16),
                            carRide.finalComments != null
                                ? Text(
                                    '${carRide.finalComments!['ratingDriver'] ?? 'Sin calificar'}')
                                : Container(),
                            textCustom("Comentarios", isBold: true, size: 16),
                            carRide.finalComments != null
                                ? Text(
                                    '${carRide.finalComments!['commentDriver'] ?? ''}')
                                : Container(),
                          ],
                        )
                      : Container(),
                  Divider(),
                  textCustom("Valor de la Carrera", isBold: true, size: 16),
                  Text('\$ ${carRide.pay}')
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Regresar', style: buttonYellowStyle),
                style: bottonBorderBlue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
