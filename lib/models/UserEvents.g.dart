// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserEvents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEvents _$UserEventsFromJson(Map<String, dynamic> json) {
  return UserEvents(
    userId: json['userId'] as String,
    eventId: json['eventId'] as String,
    tickets: (json['tickets'] as List)
        ?.map((e) =>
            e == null ? null : Ticket.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserEventsToJson(UserEvents instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'eventId': instance.eventId,
      'tickets': instance.tickets?.map((e) => e?.toJson())?.toList(),
    };
