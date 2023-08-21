import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/models/carRide/carRide.dart';
import 'package:material_kit_flutter/utils/utils.dart';
import 'package:material_kit_flutter/widgets/ImagesView.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class AcceptingFlowDriver extends StatefulWidget {
  final CarRide carRide;
  final Map<String, dynamic> passengerTmp;
  const AcceptingFlowDriver({Key? key, required this.carRide, required this.passengerTmp}) : super(key: key);

  @override
  _AcceptingFlowDriverState createState() => _AcceptingFlowDriverState();
}

class _AcceptingFlowDriverState extends State<AcceptingFlowDriver> {
  @override
  Widget build(BuildContext context) {
    print("[BUILD] _AcceptingFlowDriverState");
    return SafeArea(
      child: WillPopScope(
        onWillPop: backFunctionDefault,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: MaterialColors.blueMain,
            automaticallyImplyLeading: false,
            leading: null,
            actions: [
            ],
          ),
          backgroundColor: MaterialColors.bgColorScreen,
          body: Column(
            children: [
              Divider(
                color: Colors.transparent,
                height: getSizeScreen(context)[1] / 6,
              ),
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Carrera aceptada",
                      style: TextStyle(fontSize: 24),
                    ),
                  )),
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('${widget.passengerTmp['user']['username'] ?? ''}\n${widget.passengerTmp['user']['fullName'] ?? ''}'),
                      trailing: TextButton(
                        onPressed: () => showModalInfo(),
                        child: Text('Ver mas'),
                      ),
                    ),
                  )),
              Divider(
                color: Colors.transparent,
                height: 8,
              ),
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                        leading: Icon(Icons.location_on_rounded),
                        title: Text('${widget.carRide.coordinates!['origin'] ?? ''}')),
                  )),
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                        leading: Icon(Icons.location_searching),
                        title: Text('${widget.carRide.coordinates!['destination'] ?? ''}')),
                  )),
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                        leading: Icon(Icons.comment),
                        title: Text('${widget.carRide.observations!['message'] ?? ''}')),
                  )),
              Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: getSizeScreen(context)[0] / 5),
                      Expanded(
                        child: ElevatedButton(
                          style: bottonBorderBlue,
                          onPressed: () => giveGrade(),
                          child: Text("Calificar carrera", style: buttonYellowStyle),
                        ),
                      ),
                      SizedBox(width: getSizeScreen(context)[0] / 5),
                    ],
                  )),
            ],
          )),
      ));
  }

  showModalInfo() {
    showDialog(
        context: context,
        builder: (_) {
          var driver = widget.passengerTmp;
          List<dynamic> listImages = driver['images'];
          var imageView = ImageView(listImages);
          List<Widget> childrenModal = [
            textCustom("Nombre: ", size: 16, isBold: true),
            Text("${driver['user']['fullName']}"),
            imageView.getPhoto('profile', withTitle: false),
            textCustom("Telefono: ", size: 16, isBold: true),
            driver['user']['details']['phone'] != null ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${driver['user']['details']['phone']}"),
                IconButton(onPressed: () async {
                  final link = WhatsAppUnilink(
                    phoneNumber: '+${driver['user']['details']['phone'] ?? ''}',
                    text: "Hola estimado ...",
                  );
                  await launch('$link');
                }, icon: FaIcon(FontAwesomeIcons.whatsapp)),
              ],
            ) : Container(),
            textCustom("Email: ", size: 16, isBold: true),
            Text("${driver['user']['email']}"),
          ];
          return new AlertDialog(
            title: Text("Información del usuario"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: childrenModal,
              ),
            ),
            actions: [
              TextButton(
                child: Text('Regresar', style: TextStyle(color: MaterialColors.yellowMain)),
                style: bottonBorderBlue,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }


  giveGrade() {
    showDialog(
        context: context,
        builder: (_) {
          var ratingTmp = 5.0;
          var commentTmp = '';
          return AlertDialog(
            title: Text("Resultado de carrera"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Calificación"),
                  RatingBar.builder(
                    initialRating: ratingTmp,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      ratingTmp = rating;
                    },
                  ),
                  Text('Comentarios'),
                  TextField(
                    onChanged: (value) => commentTmp=value,
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
                  if(await giveGradeSend(widget.passengerTmp, widget.carRide, ratingTmp, comment: commentTmp)) {
                    showCenterShortToast('Muchas gracias por su colaboración');
                    Get.toNamed("/homeDriver");
                  }
                },
              ),
            ],
          );
        });
  }

  Future<bool> giveGradeSend(Map<String, dynamic> driverTmp, CarRide carRide, double rating, {String comment = ''}) async {
    return await CarRide.giveGrade(carRide, 'Driver', rating, comment: comment);
  }
}
