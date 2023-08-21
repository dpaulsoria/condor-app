import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/constants/config.dart';
import 'package:material_kit_flutter/models/carRide/carRide.dart';
import 'package:material_kit_flutter/models/user/user.dart';
import 'package:material_kit_flutter/screens/homeDriver/homeDriver.dart';
import 'package:material_kit_flutter/screens/requestFlow/AcceptingFlowDriver.dart';
import 'package:material_kit_flutter/utils/utils.dart';

class WaitingFlowDriver extends StatefulWidget {
  final CarRide carRide;
  final User user;
  WaitingFlowDriver({Key? key,required this.carRide, required this.user}) : super(key: key);

  @override
  _WaitingFlowDriverState createState() => _WaitingFlowDriverState();
}

class _WaitingFlowDriverState extends State<WaitingFlowDriver> with WidgetsBindingObserver{
  Map<String, dynamic> passengerTmp = {};
  Timer? timerGlobal;

  @override
  void initState() {
    start();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  Future<void> start() async {
    await runTimer();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      timerGlobal?.cancel();
    }
  }

  dispose() {
    timerGlobal?.cancel();
    super.dispose();
  }

  Future<void> runTimer() async {
    try {
      timerGlobal = Timer.periodic(slotRequestToDriver, (Timer timer) async {
          var valueTmp = await CarRide.getCarRide(widget.carRide.id ?? '0');
          if(valueTmp.id == '0' || valueTmp.driver == '' || valueTmp.driver == null) {
            Get.off(()=>HomeDriver());
            timerGlobal?.cancel();
          }
          if(valueTmp.status == '3') {
            Map<String, dynamic> passengerTmp = await User.getProfileUser("${valueTmp.passenger}");
            Get.off(()=>AcceptingFlowDriver(carRide: valueTmp, passengerTmp: passengerTmp));
            timerGlobal?.cancel();
          }

      });
    } on Exception catch (e) {
      timerGlobal?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("[BUILD] _WaitingFlowDriverState");
    return SafeArea(
      child: WillPopScope(
        onWillPop: backFunctionDefault,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: MaterialColors.blueMain,
            automaticallyImplyLeading: false,
            leading: null,
            actions: [],
          ),
          backgroundColor: MaterialColors.bgColorScreen,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Text("Espere a que ${widget.user.fullName} acepte ...")),
              Divider(),
              Center(
                child: SpinKitCircle(
                  color: Colors.blue,
                  size: 140.0,
                ),
              )
            ],
          )),
      ));
  }
}
