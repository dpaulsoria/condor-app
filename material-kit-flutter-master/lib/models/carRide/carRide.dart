import 'package:json_annotation/json_annotation.dart';
import 'package:material_kit_flutter/models/user/user.dart';
import 'package:material_kit_flutter/services/dio_client.dart';
import 'package:material_kit_flutter/utils/utils.dart';

part 'carRide.g.dart';

@JsonSerializable(
    disallowUnrecognizedKeys: false, checked: false, includeIfNull: false)
class CarRide {
  @JsonKey(defaultValue: '0')
  final String? id;
  final String? passenger;
  final String? driver;
  final Map<String, dynamic>? coordinates;
  final String availabilityDate;
  final String requestDate;
  final String status;
  final Map<String, dynamic>? observations;
  final Map<String, dynamic>? observationsDriver;
  final String pay;
  final Map<String, dynamic>? finalComments;
  final String urbanization;
  @JsonKey(name: 'User', required: false)
  final User? user;

  CarRide(
      {this.id,
      this.passenger,
      required this.coordinates,
      required this.availabilityDate,
      required this.requestDate,
      required this.status,
      required this.observations,
      required this.observationsDriver,
      required this.pay,
      this.driver,
      required this.finalComments,
      required this.urbanization,
      this.user});

  factory CarRide.fromJson(Map<String, dynamic> json) =>
      _$CarRideFromJson(json);
  Map<String, dynamic> toJson() => _$CarRideToJson(this);

  @override
  String toString() {
    return 'CarRide{id: $id, passenger: $passenger, driver: $driver, '
        'coordinates: $coordinates, availabilityDate: $availabilityDate, '
        'requestDate: $requestDate, status: $status, observations: $observations,'
        ' observationsDriver: $observationsDriver, pay: $pay, '
        'finalComments: $finalComments, urbanization: $urbanization, user: $user}';
  }

  static Future<CarRide> registerCarRide(Map<String, dynamic> mapData) async {
    Map<String, dynamic> response = await DioClient().postJsonRequest(
        '/carRides/create', mapData,
        tokenValue: await getSecureStorage('token'));
    if (response.containsKey("carRide"))
      return CarRide.fromJson(response["carRide"]);
    else
      return defaultCarRide();
  }

  static Future<CarRide> getCarRide(String id) async {
    Map<String, dynamic> response = await DioClient().getJsonRequest(
        '/carRides/$id',
        tokenValue: await getSecureStorage('token'));
    if (response.length > 0)
      return CarRide.fromJson(response);
    else
      return defaultCarRide();
  }

  static CarRide defaultCarRide() {
    return CarRide(
        id: "0",
        passenger: "",
        coordinates: {},
        availabilityDate: "",
        requestDate: "",
        status: "",
        observations: {},
        observationsDriver: {},
        pay: "0",
        driver: "",
        finalComments: {},
        urbanization: '');
  }

  static Future<bool> deleteRequest(String? id) async {
    Map<String, dynamic> response = await DioClient().deleteJsonRequest(
        '/carRides/$id', {},
        tokenValue: await getSecureStorage('token'));
    if (!response['error']) return true;
    return false;
  }

  static Future<bool> configDriver(String? id, String driver,
      Map<String, dynamic> observationsDriver, String status,
      {bool asDriver = false}) async {
    Map<String, dynamic> response = await DioClient().putJsonRequest(
        '/carRides/configDriver/$id',
        {
          "driver": driver == '' ? null : driver,
          "observationsDriver": observationsDriver,
          "status": status,
          "asDriver": asDriver
        },
        tokenValue: await getSecureStorage('token'));
    if (!response['error']) return true;
    return false;
  }

  static Future<bool> giveGrade(CarRide carRide, String autor, double rating,
      {String comment = ''}) async {
    Map<String, dynamic> response = await DioClient().putJsonRequest(
        '/carRides/giveGrade/${carRide.id}',
        {
          'autor': autor,
          'rating': rating,
          'comment': comment,
          'carRide': carRide.toJson()
        },
        tokenValue: await getSecureStorage('token'));
    if (!response['error']) return true;
    return false;
  }

  static Future<List<CarRide>> getCarRideAll(
      String username, String urbanization) async {
    List<dynamic> response = await DioClient().getJsonListRequest(
        '/carRides/all/$username/$urbanization',
        tokenValue: await getSecureStorage('token'));
    return response.map((entry) => CarRide.fromJson(entry)).toList();
  }

  static Future<List<CarRide>> getCarRideAllDriver(
      String urbanization, String status) async {
    List<dynamic> response = await DioClient().getJsonListRequest(
        '/carRides/availiable/$urbanization/$status',
        tokenValue: await getSecureStorage('token'));
    return response.map((entry) => CarRide.fromJson(entry)).toList();
  }
}
