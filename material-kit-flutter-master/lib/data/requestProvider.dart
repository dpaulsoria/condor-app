import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RequestProvider with ChangeNotifier {
  Map<String, dynamic> origin = {};
  Map<String, dynamic> destination = {};
  Map<String, dynamic> addresses = {};

  var _formKey = GlobalKey<FormBuilderState>();
  int typeSelection = 0;

  void setOrigin(String key, double value) {
    origin['$key'] = value;
  }

  void setDestination(String key, double value) {
    destination['$key'] = value;
  }

  void setAddress(String key, String value) {
    addresses['$key'] = value;
    notifyListeners();
  }

  void setFormKey(value) {
    _formKey = value;
  }

  void setFields(String key, dynamic value) {
    _formKey.currentState!.patchValue({'$key': value});
  }

  @override
  String toString() {
    return 'RequestProvider{origin: $origin, destination: $destination, addresses: $addresses}';
  }

  void clearData() {
    origin.clear();
    addresses.clear();
    typeSelection = 0;
  }
}
