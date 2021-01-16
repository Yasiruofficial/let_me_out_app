// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return AppUser(
    uid: json['uid'] as String,
    email: json['email'] as String,
    isAdmin: json['isAdmin'] as bool,
  );
}

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'isAdmin': instance.isAdmin,
    };
