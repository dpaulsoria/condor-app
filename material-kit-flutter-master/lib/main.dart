import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:material_kit_flutter/screens/historyApp/historyApp.dart';
import 'package:material_kit_flutter/screens/home/home.dart';
import 'package:material_kit_flutter/screens/homeDriver/homeDriver.dart';
import 'package:material_kit_flutter/screens/login/login.dart';
import 'package:material_kit_flutter/screens/profile/profile.dart';
import 'package:material_kit_flutter/services/firebase_notifications.dart';
import 'package:provider/provider.dart';

import 'constants/strings.dart';
import 'data/requestProvider.dart';

Future<void> main() async {
  await startServices();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => RequestProvider()),
  ], child: MaterialKitPROFlutter()));
}

Future<void> startServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await startServicesLibrary();
}

class MaterialKitPROFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: nameApp,
        debugShowCheckedModeBanner: false,
        initialRoute: "/signIn",
        routes: <String, WidgetBuilder>{
          "/home": (BuildContext context) => new Home(),
          "/homeDriver": (BuildContext context) => new HomeDriver(),
          "/profile": (BuildContext context) => new Profile(),
          "/signIn": (BuildContext context) => new Login(),
          "/historyApp": (BuildContext context) => HistoryApp(),
        });
  }
}
