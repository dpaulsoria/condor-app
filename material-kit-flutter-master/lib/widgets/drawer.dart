import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/utils/utils.dart';
import 'package:material_kit_flutter/widgets/drawer-tile.dart';

class MaterialDrawer extends StatelessWidget {
  final String currentPage;

  MaterialDrawer({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getVars(),
    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            var dataSnap = snapshot.data;
            var driverValue = dataSnap!['data']!['driverValue'] ?? 'false';
            return Drawer(
              child: Container(
                  child: Column(children: [
                    DrawerHeader(
                        decoration: BoxDecoration(color: MaterialColors.blueMain),
                        child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                                  child: Text("Usuario: ${dataSnap['data']['user'].toString()}",
                                      style:
                                      TextStyle(color: Colors.white, fontSize: 21)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                    ],
                                  ),
                                )
                              ],
                            ))),
                    Expanded(
                        child: ListView(
                          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                          children: [
                            DrawerTile(
                                icon: Icons.account_circle,
                                onTap: () {
                                  if (currentPage != "Profile") {
                                    Navigator.popAndPushNamed(context, '/profile');
                                  }
                                },
                                iconColor: Colors.black,
                                title: "Perfil",
                                isSelected: currentPage == "Profile" ? true : false),
                            driverValue == 'false' ? DrawerTile(
                                icon: Icons.home,
                                onTap: () {
                                  if (currentPage != "Home")
                                    Navigator.popAndPushNamed(context, '/home');
                                },
                                iconColor: Colors.black,
                                title: "Nueva Carrera",
                                isSelected: currentPage == "Home" ? true : false)
                                : DrawerTile(
                                  icon: Icons.car_rental,
                                  onTap: () {
                                    if (currentPage != "HomeDriver")
                                      Navigator.popAndPushNamed(context, '/homeDriver');
                                  },
                                  iconColor: Colors.black,
                                  title: "Solicitudes de Carreras",
                                  isSelected: currentPage == "HomeDriver" ? true : false),
                            DrawerTile(
                                icon: Icons.home,
                                onTap: () {
                                  if (currentPage != "historyApp")
                                    Navigator.popAndPushNamed(context, '/historyApp');
                                },
                                iconColor: Colors.black,
                                title: "Historial",
                                isSelected: currentPage == "historyApp" ? true : false),
                            DrawerTile(
                                icon: Icons.exit_to_app,
                                onTap: () {
                                  restartSecureStorage();
                                  if (currentPage != "Sign In")
                                    Navigator.popAndPushNamed(context, '/signIn');
                                },
                                iconColor: Colors.black,
                                title: "Cerrar sesión",
                                isSelected: currentPage == "Sign In" ? true : false),
                            Divider(height: getSizeScreen(context)[1]/3.5),
                            dataSnap['data']['isDriver'] == 'true' ? DrawerTile(
                                icon: Icons.cached_rounded,
                                onTap: () {
                                  redirectModeUser(driverValue, context);
                                },
                                iconColor: Colors.black,
                                title: "Modo ${driverValue == 'false' ? 'conductor' : 'pasajero'}",
                                isSelected: false) : Container()
                          ],
                        ))
                  ])),
            );
          }
          return Container();
        })
    );
  }

  void redirectModeUser(String driverValue, BuildContext context) async {
    if(driverValue == 'false'){
      await saveSecureStorage('driverValue', 'true');
      Navigator.popAndPushNamed(context, '/homeDriver');
    } else {
      await saveSecureStorage('driverValue', 'false');
      Navigator.popAndPushNamed(context, '/home');
    }
  }

  Future<Map<String, dynamic>> getVars() async {
    var data = await getAllSecureStorage();
    return {"data": data};
  }
}