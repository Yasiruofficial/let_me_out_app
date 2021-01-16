import 'package:json_annotation/json_annotation.dart';
part 'AppUser.g.dart';

@JsonSerializable(explicitToJson: true)
class AppUser{

  String uid;
  String email;
  bool isAdmin;


  AppUser({this.uid,this.email,this.isAdmin});

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}