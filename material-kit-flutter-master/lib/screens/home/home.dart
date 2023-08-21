import 'package:flutter/material.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/utils/utils.dart';
import 'package:material_kit_flutter/widgets/drawer.dart';

import 'formRequest.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: backFunctionDefault,
        child: Scaffold(
            //resizeToAvoidBottomInset : false,
            appBar: AppBar(title: Text("Nueva Carrera"), backgroundColor: MaterialColors.blueMain),
            backgroundColor: MaterialColors.bgColorScreen,
            drawer: MaterialDrawer(currentPage: "Home"),
            body: FutureBuilder(
              future: getVars(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
                // Map<String, String> data = snapshot.data ?? {};
                if (snapshot.hasData) {
                  return Container(
                    padding: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: getSizeScreen(context)[1] / 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          textCustom('Solicitar un viaje', size: 24),
                          SizedBox(
                              height: getSizeScreen(context)[1] / 2,
                              child: FormRequest())
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              }
            )
        ),
      )
    );
  }

  Future<Map<String, String>> getVars() => getAllSecureStorage();

}
