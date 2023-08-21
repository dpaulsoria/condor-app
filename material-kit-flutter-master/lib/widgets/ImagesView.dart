
import 'package:flutter/material.dart';

class ImageView {
  List<dynamic> listImages;
  Map<String, String> keys = { "profile": "Perfil", "carPlate": "Placa", "car": "Carro" };

  ImageView(this.listImages);

  Widget getPhoto(String type, {bool withTitle = true}) {
    if(!keys.containsKey(type))
      return Container();
    var valueTmp = listImages.firstWhere((element) => element['type'] == type);
    return valueTmp != null ? Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(4),
        elevation: 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: <Widget>[
              withTitle ? Container(
                padding: EdgeInsets.all(4),
                child: Text('${keys[type]}'),
              ) : Container(),
              Image.network(valueTmp['url'], width: 180, height: 70),
            ],
          ),
        )) : Container();
  }

  dynamic getPhotoValue(String type) {
    var firstWhere = listImages.firstWhere((element) => element['type'] == type);
    return firstWhere;
  }
}