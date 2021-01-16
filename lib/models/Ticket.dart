import 'package:json_annotation/json_annotation.dart';
part 'Ticket.g.dart';

@JsonSerializable(explicitToJson: true)
class Ticket{
  String price;
  String availableQty;

  Ticket({this.price, this.availableQty});


  @override
  String toString() {
    return 'Ticket{price: $price, availableQty: $availableQty}';
  }

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
  Map<String, dynamic> toJson() => _$TicketToJson(this);

}