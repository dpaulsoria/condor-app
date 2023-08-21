import 'package:json_annotation/json_annotation.dart';
import 'package:material_kit_flutter/services/dio_client.dart';
import 'package:material_kit_flutter/utils/utils.dart';

part 'user.g.dart';

@JsonSerializable(
    disallowUnrecognizedKeys: false, checked: false, includeIfNull: false)
class User {
  final String? id;
  final String idCard;
  final String username;
  final String fullName;
  final String? token;
  final String email;
  final Map<String, dynamic>? details;
  final String codeUrbanization;
  final String? pointsPassenger;
  final String? pointsDriver;
  final String? careers;

  User(
      {required this.id,
      required this.idCard,
      required this.username,
      required this.fullName,
      this.token,
      required this.email,
      required this.details,
      required this.codeUrbanization,
      this.pointsPassenger,
      this.careers,
      this.pointsDriver});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{id: $id, idCard: $idCard, username: $username, '
        'fullName: $fullName, email: $email, '
        'details: $details, codeUrbanization: $codeUrbanization, pointsDriver: $pointsDriver, '
        'pointsPassenger: $pointsPassenger, careers: $careers}';
  }

  static User defaultUser() {
    return User(
        id: "0",
        email: '',
        idCard: '',
        token: '',
        fullName: '',
        details: {},
        username: '',
        codeUrbanization: '');
  }

  static Future<User?> login(String name, String password) async {
    Map<String, dynamic> response = await DioClient().postJsonRequest(
        '/auth/signin',
        {'username': name, 'password': password, "mode": "app"});
    if (response.containsKey('results')) {
      var userData = response['results']['user'];
      saveDataSecure(response, userData);
      return User.fromJson(response['results']['user']);
    }
    return null;
  }

  static void saveDataSecure(Map<String, dynamic> response, userData) async {
    await saveSecureStorage('token', response['results']['token']);
    await saveSecureStorage('user', userData['username']);
    await saveSecureStorage('fullName', userData['fullName']);
    await saveSecureStorage('email', userData['email']);
    await saveSecureStorage(
        'codeUrbanization', userData['codeUrbanization'] ?? '');
    await saveSecureStorage(
        'nameUrbanization', userData['Urbanization']['name'] ?? '');
    await saveSecureStorage(
        'isDriver', userData['details']['driver'].toString());
    await saveSecureStorage('driverValue', 'false');
  }

  static Future<User> registerUser(
      String name, String email, String password) async {
    Map<String, dynamic> response = await DioClient().postJsonRequest(
        '/register', {'username': name, 'email': email, 'password': password});
    return User.fromJson(response);
  }

  static Future<Map<String, dynamic>> getProfile() async {
    var token = await getSecureStorage('token');
    Map<String, dynamic> response =
        await DioClient().getJsonRequest('/users/profile', tokenValue: token);
    if (!response['error']) {
      return {
        "user": User.fromJson(response['results']['user']),
        "images": response['results']['images']
      };
    } else {
      return {};
    }
  }

  static Future<Map<String, dynamic>> getProfileUser(String username) async {
    String urbanization = await getSecureStorage("codeUrbanization");
    Map<String, dynamic> response = await DioClient().getJsonRequest(
        '/users/$urbanization/$username',
        tokenValue: await getSecureStorage('token'));
    if (!response['error']) {
      return response['results'];
    } else {
      return {};
    }
  }
}
