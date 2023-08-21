// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String?,
    idCard: json['idCard'] as String,
    username: json['username'] as String,
    fullName: json['fullName'] as String,
    token: json['token'] as String?,
    email: json['email'] as String,
    details: json['details'] as Map<String, dynamic>?,
    codeUrbanization: json['codeUrbanization'] as String,
    pointsPassenger: json['pointsPassenger'] as String?,
    careers: json['careers'] as String?,
    pointsDriver: json['pointsDriver'] as String?,
  );
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['idCard'] = instance.idCard;
  val['username'] = instance.username;
  val['fullName'] = instance.fullName;
  writeNotNull('token', instance.token);
  val['email'] = instance.email;
  writeNotNull('details', instance.details);
  val['codeUrbanization'] = instance.codeUrbanization;
  writeNotNull('pointsPassenger', instance.pointsPassenger);
  writeNotNull('pointsDriver', instance.pointsDriver);
  writeNotNull('careers', instance.careers);
  return val;
}
