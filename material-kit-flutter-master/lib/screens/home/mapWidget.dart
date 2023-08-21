import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/data/requestProvider.dart';
import 'package:material_kit_flutter/services/geolocation.dart';
import 'package:provider/src/provider.dart';

import '../../constants/config.dart';

class MapWidget extends StatefulWidget {
  @override
  State<MapWidget> createState() => _MapWidget();
}

class _MapWidget extends State<MapWidget> {
  //Completer<GoogleMapController> _controller = Completer();
  Position? actualPosition;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("[BUILD] _MapWidget");
    return switchBuild(context);
  }

  Widget switchBuild(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getSizeScreen(context)[0],
          height: getSizeScreen(context)[1] / 1.5,
          child: PlacePicker(
                  region: 'EC',
                  apiKey: apiKeyMaps,
                  onPlacePicked: (result) => pickupLocation(result, context),
                  initialPosition: LatLng(actualPosition?.latitude ?? 0, actualPosition?.longitude ?? 0),
                  useCurrentLocation: true,
                  enableMapTypeButton: false,
                  autoCompleteDebounceInMilliseconds: 5,
                  cameraMoveDebounceInMilliseconds: 5,
                  automaticallyImplyAppBarLeading: false,
                  hintText: 'Buscar...'),
        )
      ],
    );
  }

  void pickupLocation(PickResult result, BuildContext context) {
    if (readRequestProv(context).typeSelection == 0) {
      readRequestProv(context).setFields('origin', result.formattedAddress);
      readRequestProv(context)
          .setOrigin('latitude', result.geometry!.location.lat);
      readRequestProv(context)
          .setOrigin('longitude', result.geometry!.location.lng);
      readRequestProv(context)
          .setAddress('origin', result.formattedAddress.toString());
    } else {
      readRequestProv(context)
          .setFields('destination', result.formattedAddress);
      readRequestProv(context)
          .setDestination('latitude', result.geometry!.location.lat);
      readRequestProv(context)
          .setDestination('longitude', result.geometry!.location.lng);
      readRequestProv(context)
          .setAddress('destination', result.formattedAddress.toString());
    }
    Navigator.of(context).pop();
  }

  RequestProvider readRequestProv(BuildContext context) {
    return context.read<RequestProvider>();
  }

  Future<void> start() async {
    actualPosition = await Geolocation().determinePosition();
  }
}
