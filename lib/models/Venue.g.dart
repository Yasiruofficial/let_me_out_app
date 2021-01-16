// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Venue _$VenueFromJson(Map<String, dynamic> json) {
  return Venue(
    date: json['date'] as String,
    time: json['time'] as String,
    location: json['location'] == null
        ? null
        : EventLocation.fromJson(json['location'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VenueToJson(Venue instance) => <String, dynamic>{
      'date': instance.date,
      'time': instance.time,
      'location': instance.location?.toJson(),
    };
