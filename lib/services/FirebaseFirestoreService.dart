import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:let_me_out/models/AppUser.dart';
import 'package:let_me_out/models/Ticket.dart';
import 'package:let_me_out/models/UserEvents.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:let_me_out/models/MyEvent.dart';

class FirebaseFirestoreService {

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuthService = FirebaseAuth.instance;

  Future<void> addUser(AppUser user)async{
   try {
     await _firebaseFirestore.collection("users").doc(user.uid.toString()).set(user.toJson());

   }catch(e){

     }
  }

  Future<AppUser> getUserById(String id)async{
    try {

      DocumentSnapshot ds = await _firebaseFirestore.collection("users").doc(id).get();
      AppUser user = AppUser.fromJson(ds.data());
      return user;

    }catch(e){
      print(e);
    }
  }




  Future<bool> addEvent(MyEvent event, File file) async {
    try {
      User appUser = await _firebaseAuthService.currentUser;
      event.authId = appUser.uid;

      DocumentReference documentReference =
          await _firebaseFirestore.collection('events').add(event.toJson());

      String imageBasename = p.basename(file.path);
      String docId = documentReference.id;
      String imageUrl = "$docId$imageBasename";

      UploadTask task = firebaseStorage.ref("uploads/$imageUrl").putFile(file);

      await task.then((TaskSnapshot snapshot) async {
        await snapshot.ref.getDownloadURL().then((value) async {
          await _firebaseFirestore.collection('events').doc(docId).update({
            "url": value.toString(),
            "uploadedOn": DateTime.now().toIso8601String(),
            "id":docId
          });
        });
      });

      return true;
    } catch (e) {
      return false;
    }
  }
  //---------------------------------------------------------------------------------------

  Future<bool> addUserEvent(UserEvents event) async {
    try {
      User appUser = await _firebaseAuthService.currentUser;
      event.userId = appUser.uid;

      await _firebaseFirestore.collection('userevents').add(event.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }
  //---------------------------------------------------------------------------------------


  Future<List<UserEvents>> getUsereventsByID(String id) async {
    try {
      List<UserEvents> userevents= new List<UserEvents>();
      QuerySnapshot qs = await _firebaseFirestore.collection("userevents").where("eventId", isEqualTo: id).get();

      for(DocumentSnapshot ds in qs.docs){
        UserEvents userEvent = new UserEvents();
        userEvent = UserEvents.fromJson(ds.data());

        userevents.add(userEvent);
      }
      return userevents;

    }catch(e){
      print(e);
      return null;
    }
  }

  //---------------------------------------------------------------------------------

  Future<List<MyEvent>> getTicketsByID(String id) async {
    try {
      List<MyEvent> events= new List<MyEvent>();
      QuerySnapshot qs = await _firebaseFirestore.collection("userevents").where("userId", isEqualTo: id ).get();

      for(DocumentSnapshot ds in qs.docs){

        UserEvents userEvent = new UserEvents();
        userEvent = UserEvents.fromJson(ds.data());
        QuerySnapshot qs1 = await _firebaseFirestore.collection("events").where("id", isEqualTo: userEvent.eventId ).get();

        for(DocumentSnapshot ds1 in qs1.docs){

          MyEvent event = new MyEvent();
          event = MyEvent.fromJson(ds1.data());
          event.tickets =  userEvent.tickets;
          events.add(event);
        }

      }
      return events;

    }catch(e){
      print(e);
      return null;
    }
  }

  Future<double> getProfitByEventID(String id) async {
    try {
      double total = 0;
      QuerySnapshot qs = await _firebaseFirestore.collection("userevents").where("eventId", isEqualTo: id ).get();

      for(DocumentSnapshot ds in qs.docs){

        UserEvents userEvent = new UserEvents();
        userEvent = UserEvents.fromJson(ds.data());

        for(var i in userEvent.tickets){
          total += double.parse(i.availableQty) * double.parse(i.price);
        }

      }
      return total;

    }catch(e){
      print(e);
      return null;
    }
  }

  //-------------------------------------------------------------------------------------

  Future<List<Ticket>> getAQTY(MyEvent event) async {

    List<UserEvents> userEvents =
    await getUsereventsByID(event.id);

    List<Ticket> available_tickets = new List<Ticket>();
    Map<int, int> ticketsMap = new Map<int, int>();

    for (UserEvents userEvent in userEvents) {
      for (Ticket ticket in userEvent.tickets) {
        if (ticketsMap[int.parse(ticket.price)] != null) {
          ticketsMap[int.parse(ticket.price)] += int.parse(ticket.availableQty);
        } else {
          ticketsMap[int.parse(ticket.price)] = int.parse(ticket.availableQty);
        }
      }
    }
    print(ticketsMap);

    for (Ticket ticket in event.tickets) {
      if (ticketsMap[int.parse(ticket.price)] != null) {
        ticketsMap[int.parse(ticket.price)] = int.parse(ticket.availableQty) -
            ticketsMap[int.parse(ticket.price)];
        Ticket tempTicket = new Ticket();

        tempTicket.price = ticket.price.toString();
        tempTicket.availableQty =
            ticketsMap[int.parse(ticket.price)].toString();

        available_tickets.add(tempTicket);
      } else {
        available_tickets.add(ticket);
      }
    }
    return available_tickets;
  }


  //----------------------------------------------------------------------------------------


  Future<bool> updateEvent(MyEvent event, File file) async {
    try {
      String docId = event.id;
      await _firebaseFirestore.collection('events').doc(docId).update(event.toJson());

      if(file != null){

        String imageBasename = p.basename(file.path);
        String imageUrl = "$docId$imageBasename";

        UploadTask task = firebaseStorage.ref("uploads/$imageUrl").putFile(file);

        await task.then((TaskSnapshot snapshot) async {
          await snapshot.ref.getDownloadURL().then((value) async {
            await _firebaseFirestore.collection('events').doc(docId).update({
              "url": value.toString(),
            });
          });
        });

      }

      return true;

    } catch (e) {
      return false;
    }
  }

  //--------------------------------------------------------------------------------------



  Future<bool> deleteEvent(String id) async {
    try{
      await _firebaseFirestore.collection("events").doc(id).delete();
      return true;
    }catch(e){
      return false;
    }
  }

//-------------------------------------------------------------------------------------------------------------

  Future<List<MyEvent>> getAllAvailableEvents() async {
    try {
      List<MyEvent> events = new List<MyEvent>();

      QuerySnapshot documentReference =
      await _firebaseFirestore.collection('events').get();

      for(QueryDocumentSnapshot doc in documentReference.docs){
        MyEvent event = MyEvent.fromJson(doc.data());
        events.add(event);
      }

      return events;

    } catch (e) {
      print("Error issss ->>>>> $e");
    }
  }

  //--------------------------------------------------------------------------------------------

  Future<void> getAvailableEventsCat1() async {}

  Future<void> getAvailableEventsCat2() async {}

  Future<void> getAvailableEventsCat3() async {}

  Future<void> getAvailableEventsCat4() async {}

  Future<void> getAvailableEventsCat5() async {}


  //----------------------------------------------------------------------------------------------


  Future<List<MyEvent>> getAvailableRecent50Events() async {
    MyEvent myEvent;
    List<MyEvent> myevents = new List<MyEvent>();

    final QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('events')
        .orderBy("uploadedOn")
        .limit(50)
        .get();
    for(QueryDocumentSnapshot ds in querySnapshot.docs) {
      myEvent = MyEvent.fromJson(ds.data());
      myevents.add(myEvent);
    }
    return myevents;
  }

  //---------------------------------------------------------------------------------------------

  Future<List<MyEvent>> getAdminEventsById(String id) async {
    MyEvent myEvent;
    List<MyEvent> myevents = new List<MyEvent>();

    final QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('events')
        .orderBy("uploadedOn")
        .where("authId", isEqualTo: id)
        .get();
    for (QueryDocumentSnapshot ds in querySnapshot.docs) {
      myEvent = MyEvent.fromJson(ds.data());
      myevents.add(myEvent);
    }
    return myevents;
  }

  //------------------------------------------------------------------------------------


}
