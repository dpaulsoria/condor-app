import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/constants/config.dart';
import 'package:material_kit_flutter/data/requestProvider.dart';
import 'package:material_kit_flutter/models/carRide/carRide.dart';
import 'package:material_kit_flutter/models/user/user.dart';
import 'package:material_kit_flutter/screens/home/home.dart';
import 'package:material_kit_flutter/screens/requestFlow/acceptingFlow.dart';
import 'package:material_kit_flutter/utils/utils.dart';
import 'package:material_kit_flutter/widgets/ImagesView.dart';

class WaitingFlow extends StatefulWidget {
  final CarRide request;
  final RequestProvider providerRequest;
  const WaitingFlow(
      {Key? key, required this.request, required this.providerRequest})
      : super(key: key);

  @override
  _WaitingFlow createState() => _WaitingFlow();
}

class _WaitingFlow extends State<WaitingFlow> with WidgetsBindingObserver {
  int opportunities = 0;
  bool activeFlow = true;
  Map<String, dynamic> driverTmp = {};
  Timer? timerValue;
  Map<String, String> dataSecure = {};

  @override
  void initState() {
    start();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  Future<void> start() async {
    dataSecure = await getAllSecureStorage();
    await runTimer();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      validateMaxOpportunities();
    }
  }

  Future<void> runTimer() async {
    timerValue = Timer.periodic(slotRequestDrive, (Timer timer) async {
      try {
        validateMaxOpportunities();
        if (!activeFlow) {
          timer.cancel();
        } else {
          var valueTmp = await CarRide.getCarRide(widget.request.id ?? '0');
          if (activeFlow && valueTmp.driver != "" && valueTmp.driver != null) {
            activeFlow = false;
            driverTmp = await User.getProfileUser("${valueTmp.driver}");
            if (driverTmp.isNotEmpty) acceptionDialog(valueTmp);
          }
          opportunities++;
        }
      } on Exception catch (e) {
        timer.cancel();
        Get.off(() => Home());
      }
    });
  }

  @override
  void dispose() {
    cleanScreen();
    super.dispose();
  }

  void cleanScreen() {
    activeFlow = false;
    opportunities = 0;
  }

  @override
  Widget build(BuildContext context) {
    print("[BUILD] _WaitingFlow");
    return SafeArea(
        child: WillPopScope(
      onWillPop: backFunctionDefault,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: MaterialColors.blueMain,
            automaticallyImplyLeading: false,
            leading: null,
            actions: [
              TextButton(
                onPressed: () => cancelRequest(),
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: MaterialColors.bgColorScreen,
          body: FutureBuilder(
            future: getAllSecureStorage(),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic>? data = snapshot.data ?? {};
                return Column(
                  children: [
                    Divider(
                      color: Colors.transparent,
                      height: 16,
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Solicitando vehiculo",
                        style: TextStyle(fontSize: 24),
                      ),
                    )),
                    Divider(
                      color: Colors.transparent,
                      height: 24,
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          leading: Icon(Icons.location_pin),
                          title: Text(
                              widget.providerRequest.addresses['origin'] ??
                                  '')),
                    )),
                    Divider(
                      color: Colors.transparent,
                      height: 24,
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          leading: Icon(Icons.location_searching),
                          title: Text(data['nameUrbanization'] ?? '')),
                    )),
                    Divider(
                      color: Colors.transparent,
                      height: 24,
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          leading: Icon(Icons.attach_money),
                          title: Text("${widget.request.pay}")),
                    )),
                    Divider(
                      color: Colors.transparent,
                      height: 16,
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          leading: Icon(Icons.comment),
                          title: Text(
                              "${widget.request.observations!['message']}")),
                    )),
                    Divider(
                      color: Colors.transparent,
                      height: 48,
                    ),
                    Center(
                        child: Column(
                      children: [
                        textCustom("Buscando conductor ...", size: 16),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SpinKitCircle(
                            color: Colors.blue,
                            size: 50.0,
                          ),
                        ),
                      ],
                    ))
                  ],
                );
              }
              return Container();
            },
          )),
    ));
  }

  void acceptionDialog(CarRide carRide) {
    var rating = int.parse(driverTmp['user']['pointsPassenger'] ?? '0') /
        int.parse(driverTmp['user']['careers'] ?? '0');
    showDialog(
        context: context,
        builder: (_) {
          List<dynamic> listImages = driverTmp['images'];
          var imageView = ImageView(listImages);
          List<Widget> childrenModal = [
            textCustom("Nombre: ", size: 16, isBold: true),
            Text(
                "${driverTmp['user']['fullName']} (${rating.toStringAsFixed(1)})"),
            imageView.getPhoto('profile', withTitle: false),
            textCustom("Telefono: ", size: 16, isBold: true),
            Text("${driverTmp['user']['details']['phone']}"),
            textCustom("Email: ", size: 16, isBold: true),
            Text("${driverTmp['user']['email']}"),
            textCustom("Comentario: ", size: 16, isBold: true),
            Text("${carRide.observationsDriver?['comments'] ?? ''}"),
            textCustom("Fotos :", size: 16, isBold: true),
            imageView.getPhoto('car', withTitle: true),
            imageView.getPhoto('carPlate', withTitle: true),
          ];
          childrenModal.add(Text("Aceptas la carrera?"));
          return new AlertDialog(
            title: new Text("Conductor interesado"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: childrenModal,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Aceptar', style: buttonYellowStyle),
                style: bottonBorderBlue,
                onPressed: () async {
                  var boolValue = await acceptingDriver("${carRide.id}",
                      driverTmp['user']['username'], {"comments": ""}, "3");
                  if (boolValue)
                    Get.off(() => AcceptingFlow(driverTmp, carRide));
                },
              ),
              TextButton(
                child: Text('Rechazar', style: buttonYellowStyle),
                style: bottonBorderBlue,
                onPressed: () async {
                  var boolValue = await configDriver(
                      "${carRide.id}", "", {"comments": ""}, "1");
                  activeFlow = true;
                  validateMaxOpportunities();
                  if (boolValue) Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void cancelRequest({bool isExit = true}) async {
    var request = await CarRide.deleteRequest(widget.request.id);
    if (request) {
      showCenterShortToast("Solicitud cancelada");
      if (isExit) {
        cleanScreen();
        Get.offNamed("/home");
      }
    }
  }

  Future<bool> configDriver(String id, String driver,
      Map<String, dynamic> observationsDriver, String status) async {
    var request =
        await CarRide.configDriver(id, driver, observationsDriver, status);
    if (request) {
      activeFlow = true;
      driverTmp = {};
      showCenterShortToast("Buscando otro conductor");
      await runTimer();
      return true;
    }
    return false;
  }

  Future<bool> acceptingDriver(String id, String driver,
      Map<String, dynamic> observationsDriver, String status) async {
    var request =
        await CarRide.configDriver(id, driver, observationsDriver, status);
    if (request) {
      cleanScreen();
      return true;
    }
    return false;
  }

  Future<void> validateMaxOpportunities() async {
    if (opportunities >= maxIntentsRequest) {
      timerValue?.cancel();
      await CarRide.deleteRequest(widget.request.id);
      cleanScreen();
      showCenterShortToast("Ningun conductor disponible, intente nuevamente");
      Get.offAndToNamed("/home");
    }
  }
}
