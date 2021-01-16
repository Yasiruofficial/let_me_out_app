import 'package:clippy_flutter/ticket.dart';
import 'package:flutter/material.dart';
import 'package:let_me_out/models/AppUser.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:recase/recase.dart';

class Explore extends StatefulWidget {
  final FirebaseAuthService baseAuthService;
  final FirebaseFirestoreService firestoreService;

  const Explore({Key key, this.baseAuthService, this.firestoreService})
      : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<MyEvent> Events;

  Future<void> getTickets() async {
    AppUser user = await widget.baseAuthService.getCurrentUser();
    Events = await widget.firestoreService.getTicketsByID(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getTickets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return LoadingWidget(
                color: Colors.blue,
              );
            } else {
              return Center(
                child: Container(
                  child: Column(
                    children: [
                      Container(),
                      for (var i in Events)
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Ticket(
                              radius: 10.0,
                              child: GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/ticket_demo'),
                                child: Container(
                                  color: Colors.indigo,
                                  width: MediaQuery.of(context).size.width - 50,
                                  height: 200.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Ticket(
                                      radius: 10.0,
                                      child: GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                            context, '/ticket_demo'),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.asset("images/GoldenBack.png",
                                                fit: BoxFit.cover),
                                            Opacity(
                                              opacity: 0.2,
                                              child: Image.network(
                                                i.url,
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
                                            Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      ReCase(i.title).sentenceCase,
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.indigo,
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: ListTile(
                                                        title: Text(
                                                          "Date : ${i.venue.first.date.toString().split(":")[0].split("T00")[0]} @ ${i.venue.first.time}",
                                                          //date.toString().split(" ")[0] and time.format(context)
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: false,
                                                          maxLines: 2,
                                                        ),
                                                        subtitle: Row(
                                                          children: [
                                                            Icon(Icons.location_pin),
                                                            Expanded(
                                                              child: Text(
                                                                i.venue.first.location.description,
                                                                overflow: TextOverflow.ellipsis,
                                                                softWrap: false,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
