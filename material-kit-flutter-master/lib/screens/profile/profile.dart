import 'package:flutter/material.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/models/user/user.dart';
import 'package:material_kit_flutter/widgets/ImagesView.dart';
import 'package:material_kit_flutter/widgets/drawer.dart';

import 'formProfile.dart';

class Profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Perfil"), backgroundColor: MaterialColors.blueMain),
        backgroundColor: MaterialColors.bgColorScreen,
        drawer: MaterialDrawer(currentPage: "Profile"),
        body: FutureBuilder(
            future: User.getProfile(),
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data = snapshot.data ?? {};
                var imageView = ImageView(data['images']);
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                alignment: Alignment.topCenter,
                                image: NetworkImage(
                                    "${imageView.getPhotoValue('profile')['url']}", scale: 0.3),
                                fit: BoxFit.fitWidth)),
                      ),
                      Divider(height: 32),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormProfile(user: data['user'])
                        ],
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }));
  }
}

