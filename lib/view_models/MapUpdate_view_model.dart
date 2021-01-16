
import 'package:flutter/foundation.dart';
import 'package:let_me_out/models/MyEvent.dart';

class MapUpdateViewModel extends ChangeNotifier{

  bool isMarkerSelected = false;
  MyEvent event;
  bool mapFullyLoarded = false;

  void updateClick(bool status,MyEvent event){
    this.isMarkerSelected = status;
    updateBottomEvent(event);
    notifyListeners();
  }
  void updateMapFullyLoarded(){
    this.mapFullyLoarded = true;
    notifyListeners();
  }

  void updateBottomEvent(MyEvent event){
    this.event = event;
  }

}