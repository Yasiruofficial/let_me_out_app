import 'package:flutter/cupertino.dart';

import '../models/MyEvent.dart';
import '../services/FirebaseFirestoreService.dart';

class HomeUpdateViewModel extends ChangeNotifier{

  List<MyEvent> myEvents;
  bool loading = true;
  int selected = 0;

  Future<void> get50Events(FirebaseFirestoreService firestoreService) async {
    myEvents = await firestoreService.getAvailableRecent50Events();
    loading = false;
    notifyListeners();
  }

  Future<void> get50EventsNew(FirebaseFirestoreService firestoreService) async {
    loading = true;
    selected = 0;
    notifyListeners();
    myEvents = await firestoreService.getAvailableRecent50Events();
    loading = false;
    notifyListeners();
  }

  Future<void> getCustomEvents(FirebaseFirestoreService firestoreService,String category,int selected) async {
    this.selected = selected;
    loading = true;
    notifyListeners();
    myEvents = await firestoreService.getCustomEvents(category);
    loading = false;
    notifyListeners();
  }





}