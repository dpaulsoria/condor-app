// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carRide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarRide _$CarRideFromJson(Map<String, dynamic> json) {
  return CarRide(
    id: json['id'] as String? ?? '0',
    passenger: json['passenger'] as String?,
    coordinates: json['coordinates'] as Map<String, dynamic>?,
    availabilityDate: json['availabilityDate'] as String,
    requestDate: json['requestDate'] as String,
    status: json['status'] as String,
    observations: json['observations'] as Map<String, dynamic>?,
    observationsDriver: json['observationsDriver'] as Map<String, dynamic>?,
    pay: json['pay'] as String,
    driver: json['driver'] as String?,
    finalComments: json['finalComments'] as Map<String, dynamic>?,
    urbanization: json['urbanization'] as String,
    user: json['User'] == null
        ? null
        : User.fromJson(json['User'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CarRideToJson(CarRide instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('passenger', instance.passenger);
  writeNotNull('driver', instance.driver);
  writeNotNull('coordinates', instance.coordinates);
  val['availabilityDate'] = instance.availabilityDate;
  val['requestDate'] = instance.requestDate;
  val['status'] = instance.status;
  writeNotNull('observations', instance.observations);
  writeNotNull('observationsDriver', instance.observationsDriver);
  val['pay'] = instance.pay;
  writeNotNull('finalComments', instance.finalComments);
  val['urbanization'] = instance.urbanization;
  writeNotNull('User', instance.user);
  return val;
}
