import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_kit_flutter/constants/Theme.dart';

Future<bool> saveSecureStorage(String key, String value) async {
  try {
    final storage = new FlutterSecureStorage();
    await storage.write(key: key, value: value);
    return true;
  } on Exception catch (ex) {
    print("saveSecureStorage " + ex.toString());
  }
  return false;
}

Future<String> getSecureStorage(String key) async {
  try {
    final storage = new FlutterSecureStorage();
    var value = await storage.read(key: key);
    return value ?? '';
  } on Exception catch (ex) {
    print("getSecureStorage " + ex.toString());
  }
  return "null";
}

Future<Map<String, String>> getAllSecureStorage() async {
  try {
    final storage = new FlutterSecureStorage();
    return await storage.readAll();
  } on Exception catch (ex) {
    print("getSecureStorage " + ex.toString());
  }
  return Map();
}

Future<bool> restartSecureStorage() async {
  try {
    final storage = new FlutterSecureStorage();
    storage.deleteAll();
    return true;
  } on Exception catch (ex) {
    print("restartSecureStorage " + ex.toString());
  }
  return false;
}

void showCenterShortToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    backgroundColor: MaterialColors.blueMain,
    textColor: MaterialColors.yellowMain,
    msg: message,
    fontSize: 18,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
  );
}

bool haveContent(String element) {
  if (![null, ''].contains(element)) {
    return true;
  }
  return false;
}

String formatTimeReduced(String spMedium) {
  DateTime dt = DateTime.now().toLocal();
  return '${dt.year}${dt.month}${dt.day}$spMedium${dt.hour}${dt.minute}${dt.second}';
}

DateTime nowUntil({String mode = 'ALL'}) {
  final now = DateTime.now();
  switch (mode) {
    case 'ALL':
      return DateTime.utc(now.year, now.month, now.day, now.hour);

    case 'YEAR':
      return DateTime.utc(now.year, 1, 0, 0);
    case 'MONTH':
      return DateTime.utc(now.year, now.month, 0, 0);

    case 'DAY':
      return DateTime.utc(now.year, now.month, now.day, 0);

    case 'HOUR':
      return DateTime.utc(now.year, now.month, now.day, now.hour);

    default:
      return now;
  }
}

List<DateTime> limitDay(DateTime date) {
  DateTime tmpStart = DateTime.utc(date.year, date.month, date.day, 0, 0);
  DateTime tmpFinal = DateTime.utc(date.year, date.month, date.day, 23, 59);
  return [tmpStart, tmpFinal];
}

Duration? getDurationFromString(String datetime, {bool isLocal: false, bool isNow: false}) {
  try {
    DateTime tmp = DateTime.now();
    if(isNow) {
      tmp = isLocal ? DateTime.now().toLocal() : DateTime.now();
    } else {
      tmp = isLocal ? DateTime.parse(datetime).toLocal() : DateTime.parse(datetime);
    }
    return Duration(days: tmp.day, hours: tmp.hour, minutes: tmp.minute, seconds: tmp.second);
  } catch (e) {
    print('getDurationFromString $e');
  }
  return null;
}

DateTime getTimeFromString(String datetime, {bool isLocal: false, bool isNow: false}) {
  try {
    DateTime parse = DateTime.now();
    if(!isNow)
      parse = DateTime.parse(datetime);
    if(isLocal)
      return parse.toLocal();
  } catch (e) {
    print('getTimeFromString $e');
  }
  return DateTime.now();
}

Future<bool> backFunctionDefault() async {
  return false;
}