import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/constants/config.dart';
import 'package:material_kit_flutter/models/carRide/carRide.dart';
import 'package:material_kit_flutter/models/user/user.dart';
import 'package:material_kit_flutter/screens/requestFlow/WaitingFlowDriver.dart';
import 'package:material_kit_flutter/services/geolocation.dart';
import 'package:material_kit_flutter/utils/utils.dart';
import 'package:material_kit_flutter/widgets/drawer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeDriver extends StatefulWidget {
  const HomeDriver({Key? key}) : super(key: key);

  @override
  _HomeDriverState createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> with WidgetsBindingObserver {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  Position? position;
  AppLifecycleState stateGlobal = AppLifecycleState.resumed;
  Timer? timerValue;
  List<CarRide> listItems = [];

  @override
  void initState() {
    start();
    startItems();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    stateGlobal = state;
    if (stateGlobal == AppLifecycleState.resumed) {
      start();
    } else {
      closeTimer();
    }
  }

  void start() async {
    position = await Geolocation().determinePosition();
    stateGlobal = AppLifecycleState.resumed;
    timerValue = Timer.periodic(durationRefreshCareers, (Timer timer) async {
      bool states = stateGlobal != AppLifecycleState.resumed;
      bool current = Get.currentRoute.toUpperCase() != "/HOMEDRIVER";
      if (states || current) {
        timerValue?.cancel();
      } else {
        refreshItems();
      }
    });
  }

  @override
  void dispose() {
    closeTimer();
    super.dispose();
  }

  @override
  void deactivate() {
    closeTimer();
    super.deactivate();
  }

  void closeTimer() {
    timerValue?.cancel();
    // stateGlobal = AppLifecycleState.inactive;
  }

  @override
  void didUpdateWidget(covariant HomeDriver oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    await refreshItems();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    print("[BUILD] HomeDriver ${DateTime.now()}");
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Solicitudes de Carreras"),
          backgroundColor: MaterialColors.blueMain,
          actions: [
            TextButton(
                onPressed: () => refreshItems(),
                child: Icon(Icons.refresh_sharp, color: Colors.white))
          ],
        ),
        backgroundColor: MaterialColors.bgColorScreen,
        drawer: MaterialDrawer(currentPage: "HomeDriver"),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          enableTwoLevel: true,
          header: WaterDropHeader(),
          controller: refreshController,
          onRefresh: onRefresh,
          onLoading: onLoading,
          child: Container(
              padding: EdgeInsets.only(top: 16),
              child: listItems.length > 0
                  ? ListView.builder(
                      itemCount: listItems.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        CarRide element = listItems[index];
                        return buildCardItem(element, context);
                      },
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        textCustom("Buscando carreras", size: 16, isBold: true),
                        SpinKitCircle(
                          color: Colors.blue,
                          size: 100.0,
                          duration: Duration(seconds: 10),
                        )
                      ],
                    ))),
        ),
      ),
    );
  }

  Card buildCardItem(CarRide element, BuildContext context) {
    double distanceBetween = Geolocator.distanceBetween(
            element.coordinates!['originLatitude'],
            element.coordinates!['originLongitude'],
            position?.latitude ?? element.coordinates!['originLatitude'],
            position?.longitude ?? element.coordinates!['originLongitude']) /
        1000;
    var user = element.user;
    var rating = int.parse(user!.pointsPassenger ?? '0') /
        int.parse(user.careers ?? '0');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: textCustom(
                '${element.user!.fullName} (${rating.toStringAsFixed(1)})',
                isBold: true,
                size: 18,
                colorV: Colors.blue),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textCustom('Desde: ${element.coordinates!['origin']}',
                    size: 16),
                textCustom('Hasta: ${element.coordinates!['destination']}',
                    size: 16),
              ],
            ),
            leading: Text(
                '${double.parse(distanceBetween.toString().replaceAll(RegExp(r'\.[0-9]+'), ''))} Km'),
            trailing: Text('\$${element.pay}'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  onPressed: () => showInfo(context, element, user),
                  child: Text('Enviar solicitud')),
              //TextButton(onPressed: () => {}, child: Text('Revisar'))
            ],
          )
        ],
      ),
    );
  }

  void showInfo(BuildContext context, CarRide element, User user) {
    showDialog(
        context: context,
        builder: (_) {
          String commentTmp = "";
          return AlertDialog(
            title: Text("Solicitud a aprobar"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  textCustom('Estas dispuesto a llevar a ${user.fullName}?.',
                      isBold: false, size: 16),
                  Divider(),
                  textCustom(
                      'El usuario comenta: "${element.observations?['message'] ?? ''}"',
                      isBold: false,
                      size: 16),
                  Divider(),
                  textCustom('Comentarios', isBold: true, size: 16),
                  TextField(
                    onChanged: (value) => commentTmp = value,
                    maxLength: 200,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Enviar', style: buttonYellowStyle),
                style: bottonBorderBlue,
                onPressed: () async {
                  Map<String, String> stringSecure =
                      await getAllSecureStorage();
                  if (stringSecure.containsKey('user')) {
                    bool isSend = await configDriver(
                        "${element.id}",
                        stringSecure['user'] ?? '',
                        {"comments": commentTmp},
                        "2");
                    if (isSend) {
                      closeTimer();
                      Get.off(() =>
                          WaitingFlowDriver(carRide: element, user: user));
                    }
                  }
                },
              ),
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

  Future<void> refreshItems() async {
    if (Get.currentRoute.toUpperCase() == "/HOMEDRIVER") {
      listItems = await getTravels();
      setState(() {
        listItems = listItems;
      });
    }
  }

  Future<List<CarRide>> getTravels() async {
    var allSecureStorage = await getAllSecureStorage();
    return CarRide.getCarRideAllDriver(
        allSecureStorage['codeUrbanization'] ?? '0', '1');
  }

  Future<bool> configDriver(String id, String driver,
      Map<String, dynamic> observationsDriver, String status) async {
    var request = await CarRide.configDriver(
        id, driver, observationsDriver, status,
        asDriver: true);
    if (request) {
      return true;
    }
    return false;
  }

  Future<void> startItems() async {
    await refreshItems();
  }
}
