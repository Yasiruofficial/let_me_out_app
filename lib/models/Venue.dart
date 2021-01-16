import 'package:json_annotation/json_annotation.dart';
import 'EventLocation.dart';
part 'Venue.g.dart';

@JsonSerializable(explicitToJson: true)
class Venue{

  String date;
  String time;
  EventLocation location;


  Venue({this.date, this.time, this.location});

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
  Map<String, dynamic> toJson() => _$VenueToJson(this);

}