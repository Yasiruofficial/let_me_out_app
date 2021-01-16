// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyEvent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyEvent _$MyEventFromJson(Map<String, dynamic> json) {
  return MyEvent(
    id: json['id'] as String,
    title: json['title'] as String,
    subTitle: json['subTitle'] as String,
    tickets: (json['tickets'] as List)
        ?.map((e) =>
            e == null ? null : Ticket.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    venue: (json['venue'] as List)
        ?.map(
            (e) => e == null ? null : Venue.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    url: json['url'] as String,
    authId: json['authId'] as String,
    uploadedOn: json['uploadedOn'] as String,
    category: json['category'] as String,
    expiredOn: json['expiredOn'] as String,
  );
}

Map<String, dynamic> _$MyEventToJson(MyEvent instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'category': instance.category,
      'tickets': instance.tickets?.map((e) => e?.toJson())?.toList(),
      'venue': instance.venue?.map((e) => e?.toJson())?.toList(),
      'url': instance.url,
      'authId': instance.authId,
      'uploadedOn': instance.uploadedOn,
      'expiredOn': instance.expiredOn,
    };
