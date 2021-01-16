import 'package:flutter/foundation.dart';
import 'package:let_me_out/enums/Common.dart';
import 'package:let_me_out/models/MyEvent.dart';

class EventUpdateViewModel extends ChangeNotifier{

  MyEvent event;
  ExploreOrUpdate option;

  EventUpdateViewModel(){
     option = ExploreOrUpdate.Explore;
  }


  void setEvent(MyEvent e){
    event = e;
  }

  void setExploreOrUpdate(ExploreOrUpdate eO){
    option = eO;
    notifyListeners();
  }

  MyEvent getEvent(){
    return event;
  }

}