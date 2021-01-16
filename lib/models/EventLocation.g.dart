// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventLocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventLocation _$EventLocationFromJson(Map<String, dynamic> json) {
  return EventLocation(
    lat: json['lat'] as String,
    lng: json['lng'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$EventLocationToJson(EventLocation instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'description': instance.description,
    };
