import 'package:json_annotation/json_annotation.dart';

import 'Ticket.dart';
import 'Venue.dart';
part 'MyEvent.g.dart';

@JsonSerializable(explicitToJson: true)
class MyEvent {
  String id;
  String title;
  String subTitle;
  String category;
  List<Ticket> tickets;
  List<Venue> venue;
  String url;
  String authId;
  String uploadedOn;
  String expiredOn;

  MyEvent(
      {this.id,
      this.title,
      this.subTitle,
      this.tickets,
      this.venue,
      this.url,
      this.authId,
      this.uploadedOn,
      this.category,
      this.expiredOn});

  factory MyEvent.fromJson(Map<String, dynamic> json) => _$MyEventFromJson(json);
  Map<String, dynamic> toJson() => _$MyEventToJson(this);

}
