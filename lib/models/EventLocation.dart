import 'package:json_annotation/json_annotation.dart';
part 'EventLocation.g.dart';


@JsonSerializable(explicitToJson: true)
class EventLocation{

  String lat;
  String lng;
  String description;


  EventLocation({this.lat, this.lng, this.description});

  factory EventLocation.fromJson(Map<String, dynamic> json) => _$EventLocationFromJson(json);
  Map<String, dynamic> toJson() => _$EventLocationToJson(this);

}