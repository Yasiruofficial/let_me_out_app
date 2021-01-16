import 'package:flutter/foundation.dart';


class SingleEventViewModel extends ChangeNotifier{

  Map<int, int> bought_tickets = new Map<int, int>();
  double total = 0;

  INCBoughtTickets(int price){
    bought_tickets[price] = bought_tickets[price] + 1;
    total += price;
    notifyListeners();
  }
  DECBoughtTickets(int price){
    bought_tickets[price] = bought_tickets[price] - 1;
    total -= price;
    notifyListeners();
  }

  INCBoughtTicketsOnNull(int price){
    bought_tickets[price] = bought_tickets[price] = 1;
    total += price;
    notifyListeners();
  }

}