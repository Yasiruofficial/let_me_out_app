import 'package:json_annotation/json_annotation.dart';
import 'Ticket.dart';
part 'UserEvents.g.dart';

@JsonSerializable(explicitToJson: true)
class UserEvents{

  String userId;
  String eventId;
  List<Ticket> tickets;

  UserEvents({this.userId, this.eventId, this.tickets});

  factory UserEvents.fromJson(Map<String, dynamic> json) => _$UserEventsFromJson(json);
  Map<String, dynamic> toJson() => _$UserEventsToJson(this);

}