import 'package:flutter/material.dart';
import 'package:let_me_out/enums/Common.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/EventUpdate_view_model.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:toast/toast.dart';

class HorizontalCardAdmin extends StatelessWidget {
  final MyEvent myEvent;
  final bool isPast;
  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;

  HorizontalCardAdmin(
      {this.myEvent,
      this.isPast = false,
      this.firestoreService,
      this.baseAuthService});

  @override
  Widget build(BuildContext context) {
    print("Card building....");
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        color: Colors.white,
        borderOnForeground: false,
        shadowColor: Colors.grey,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 125,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 125,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    child: Image.network(
                      myEvent.url,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: LoadingWidget(
                              animationSize: 50,
                              color: Colors.blue,
                              isImage: true),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: ListTile(
                          dense: true,
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              ReCase(myEvent.title).sentenceCase,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            ReCase(myEvent.subTitle).sentenceCase,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: ListTile(
                          dense: true,
                          title: Row(
                            children: [
                              Expanded(child: Container()),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.brown,
                                ),
                                onPressed: () {
                                  Provider.of<EventUpdateViewModel>(context,
                                          listen: false)
                                      .setEvent(myEvent);
                                  Provider.of<EventUpdateViewModel>(context,
                                          listen: false)
                                      .setExploreOrUpdate(
                                          ExploreOrUpdate.Update);
                                },
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () async {
                                  bool answer;
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Do you Really wand to delete this event?"),
                                        actions: <Widget>[
                                          new FloatingActionButton.extended(
                                            icon: Icon(Icons.close),
                                            label: Text("No"),
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            onPressed: () {
                                              answer = false;
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          new FloatingActionButton.extended(
                                            icon: Icon(Icons.delete),
                                            label: Text("Yes"),
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            onPressed: () async {
                                              bool status =
                                                  await firestoreService
                                                      .deleteEvent(myEvent.id);
                                              if (status) {
                                                Toast.show(
                                                    "Successfully deleted",
                                                    context,
                                                    duration: Toast.LENGTH_LONG,
                                                    gravity: Toast.CENTER);
                                              } else {
                                                Toast.show(
                                                    "Error on delete", context,
                                                    duration: Toast.LENGTH_LONG,
                                                    gravity: Toast.CENTER);
                                              }
                                              answer = true;
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (answer == true) {
                                    Provider.of<EventUpdateViewModel>(context,
                                            listen: false)
                                        .setExploreOrUpdate(
                                            ExploreOrUpdate.Explore);
                                  }
                                },
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
