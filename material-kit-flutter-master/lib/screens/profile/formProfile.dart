import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/data/requestProvider.dart';
import 'package:material_kit_flutter/models/user/user.dart';
import 'package:material_kit_flutter/utils/utils.dart';
import 'package:provider/src/provider.dart';

class FormProfile extends StatefulWidget {
  final User user;
  const FormProfile({Key? key, required this.user}) : super(key: key);

  @override
  _FormProfile createState() => _FormProfile();
}

class _FormProfile extends State<FormProfile> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, String> dataSecure = {};

  @override
  void initState() {
    loadInitial();
    super.initState();
  }

  Future<void> loadInitial() async {
    dataSecure = await getAllSecureStorage();
    _formKey.currentState!
        .patchValue({'fullName': dataSecure['fullName'] ?? ''});
  }

  void refresh() {
    /*setState(() {});*/
  }

  @override
  Widget build(BuildContext context) {
    print("[BUILD] _FormProfile");
    context.read<RequestProvider>().setFormKey(_formKey);
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(),
        child: Column(
          children: [
            textCustom('DATOS DE USUARIO', isBold: true, size: 18),
            FormBuilder(
                key: _formKey,
                child: Column(children: [
                  FormBuilderTextField(
                    readOnly: true,
                    name: 'username',
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                    ),
                    onChanged: (value) {},
                    onTap: () {},
                    keyboardType: TextInputType.text,
                    initialValue: widget.user.username,
                  ),
                  FormBuilderTextField(
                    readOnly: true,
                    name: 'fullName',
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                    ),
                    onChanged: (value) {},
                    onTap: () {},
                    keyboardType: TextInputType.text,
                    initialValue: widget.user.fullName,
                  ),
                  FormBuilderTextField(
                    readOnly: true,
                    name: 'idCard',
                    decoration: InputDecoration(
                      labelText: 'C.I',
                    ),
                    onChanged: (value) {},
                    onTap: () {},
                    keyboardType: TextInputType.text,
                    initialValue: widget.user.idCard,
                  ),
                  FormBuilderTextField(
                    readOnly: true,
                    name: 'phone',
                    decoration: InputDecoration(
                      labelText: 'Telefono',
                    ),
                    onChanged: (value) {},
                    onTap: () {},
                    keyboardType: TextInputType.text,
                    initialValue: widget.user.details!['phone'],
                  ),
                ])),
          ],
        ));
  }
}
