import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/data/requestProvider.dart';
import 'package:material_kit_flutter/models/carRide/carRide.dart';
import 'package:material_kit_flutter/screens/requestFlow/waitingFlow.dart';
import 'package:material_kit_flutter/utils/utils.dart';
import 'package:provider/src/provider.dart';
import 'dart:async';

import 'package:material_kit_flutter/models/user/user.dart';
import 'package:material_kit_flutter/screens/requestFlow/WaitingFlowDriver.dart';

import 'mapWidget.dart';

class FormRequest extends StatefulWidget {
  const FormRequest() : super();

  @override
  _FormRequest createState() => _FormRequest();
}

class _FormRequest extends State<FormRequest> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isSend = false;
  Map<String, String> dataSecure = {};

  @override
  void initState() {
    cleanScreen();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    context.read<RequestProvider>().setFormKey(_formKey);
    print("[BUILD] _FormRequest");
    return Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(),
        child: FutureBuilder(
          future: getAllSecureStorage(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              Map<String, dynamic>? data = snapshot.data ?? {};
              return Column(
                children: [
                  FormBuilder(
                      key: _formKey,
                      child: Column(children: [
                        FormBuilderTextField(
                          autofocus: true,
                          readOnly: true,
                          name: 'origin',
                          decoration: InputDecoration(
                              labelText: 'Origen',
                              icon: Icon(Icons.location_on)),
                          onChanged: (value) {},
                          onTap: () {
                            context.read<RequestProvider>().typeSelection = 0;
                            showModalInfo();
                          },
                          keyboardType: TextInputType.text,
                          initialValue: "Seleccionar ...",
                        ),
                        FormBuilderTextField(
                          readOnly: true,
                          name: 'destination_',
                          decoration: InputDecoration(
                              labelText: 'Destino',
                              icon: Icon(Icons.location_on)),
                          onChanged: (value) {},
                          onTap: () {
                            //context.read<RequestProvider>().typeSelection = 1;
                            //showModalInfo();
                          },
                          keyboardType: TextInputType.text,
                          initialValue: data['nameUrbanization'] ?? '',
                        ),
                        FormBuilderTextField(
                          name: 'pay',
                          decoration: InputDecoration(
                              labelText: 'Monto a Pagar',
                              icon: Icon(Icons.money)),
                          keyboardType: TextInputType.number,
                          initialValue: "0",
                          maxLength: 5,
                        ),
                        FormBuilderTextField(
                          name: 'comments',
                          decoration: InputDecoration(
                              labelText: 'Comentarios',
                              icon: Icon(Icons.comment)),
                          keyboardType: TextInputType.text,
                          initialValue: "",
                          maxLength: 200,
                        )
                      ])),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: MaterialButton(
                          color: MaterialColors.blueMain,
                          child: Text("Solicitar", style: buttonYellowStyle),
                          onPressed: () async {
                            var currentState = _formKey.currentState;
                            currentState!.save();
                            var provider = context.read<RequestProvider>();
                            if (validateData(currentState.value, provider) &&
                                currentState.validate()) {
                              if (!isSend) {
                                var bodyRequest = await buildRequest(
                                    currentState.value, provider, data);
                                if (bodyRequest.id != "0") {
                                  isSend = true;
                                  Get.off(() => WaitingFlow(
                                      request: bodyRequest,
                                      providerRequest: provider));
                                } else {
                                  showCenterShortToast(
                                      "Error al solicitar, intente en un momento");
                                }
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      )
                    ],
                  )
                ],
              );
            }
            return Container();
          },
        ));
  }

  void showInfo(BuildContext context) {
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
                  textCustom('Estas dispuesto a llevar a .',
                      isBold: false, size: 16),
                  Divider(),
                  textCustom('El usuario comenta: ', isBold: false, size: 16),
                  Divider(),
                  textCustom('Comentarios', isBold: true, size: 16),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK', style: buttonYellowStyle),
                style: bottonBorderBlue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<CarRide> buildRequest(Map<String, dynamic> value,
      RequestProvider provider, Map<String, dynamic> data) async {
    String username = await getSecureStorage("user");
    var dateTime = DateTime.now();
    /*var distanceBetween = Geolocator.distanceBetween(provider.origin['latitude'], provider.origin['longitude'],
        provider.destination['latitude'], provider.destination['longitude']);*/
    var jsonData = {
      "passenger": "$username",
      "driver": "",
      "coordinates": {
        "originLatitude": provider.origin['latitude'],
        "originLongitude": provider.origin['longitude'],
        "destLatitude": provider.destination['latitude'],
        "destLongitude": provider.destination['longitude'],
        "origin": provider.addresses['origin'],
        //"destination": provider.addresses['destination'],
        "destination": data['nameUrbanization'] ?? '',
        //"distance": distanceBetween
      },
      "availabilityDate": "${dateTime.toString()}",
      "requestDate": "${dateTime.toString()}",
      "status": "1",
      "observations": {"message": "${value['comments'] ?? ''}"},
      "pay": (value['pay'] == '') ? '0' : value['pay'],
      "urbanization": await getSecureStorage('codeUrbanization')
    };
    return CarRide.registerCarRide(jsonData);
  }

  bool validateData(Map<String, dynamic> formData, RequestProvider provider) {
    bool isGood = provider.origin.isNotEmpty;
    if (!isGood) showCenterShortToast('Complete las direcciones');
    return isGood;
  }

  void cleanScreen() async {
    var provider = context.read<RequestProvider>();
    provider.clearData();
  }

  showModalInfo() {
    showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            scrollable: true,
            title: Text("Selecciona un dirección:"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [MapWidget()],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Regresar',
                    style: TextStyle(color: MaterialColors.yellowMain)),
                style: bottonBorderBlue,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
