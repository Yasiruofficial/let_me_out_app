import 'package:flutter/material.dart';
import 'package:let_me_out/screens/components/CustomDivider.dart';
import 'package:let_me_out/screens/views/admin/Providers/EventUpdateProvider.dart';
import 'package:let_me_out/screens/views/admin/admin_add_event.dart';
import 'package:let_me_out/screens/views/admin/admin_home.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/EventUpdate_view_model.dart';
import 'package:let_me_out/view_models/LandingPage_view_model.dart';
import 'package:provider/provider.dart';

class AdminMainPage extends StatefulWidget {
  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;

  const AdminMainPage({this.baseAuthService, this.firestoreService});

  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  PageController _pageController;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget title;

    if (_page == 0) {
      title = Text("Add Event");
    } else if (_page == 1) {
      title = Text("Home");
    } else {
      title = Text("Your Events");
    }

    print("AdminMain page building....");

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: title,
          centerTitle: true,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        drawer: Container(
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width / 4 * 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            color: Colors.blueAccent,
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("images/person.jpg"),
                  ),
                ),
                CustomDivider(),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.attribution_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Profile',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Settings',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.power_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Upgrade Pro',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        onTap: () async {
                          await widget.baseAuthService.signOut();
                          Provider.of<LandingPageViewModel>(context,
                                  listen: false)
                              .updatedUser(await widget.baseAuthService
                                  .getCurrentUser());
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        body: PageView(
          children: <Widget>[
            AdminAddEvent(
              baseAuthService: widget.baseAuthService,
              firestoreService: widget.firestoreService,
            ),
            AdminHome(
              firestoreService: widget.firestoreService,
              baseAuthService: widget.baseAuthService,
            ),
            ChangeNotifierProvider(
              create: (context) => EventUpdateViewModel(),
              child: EventUpdateProvider(
                baseAuthService: widget.baseAuthService,
                firestoreService: widget.firestoreService,
              ),
            )
          ],
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: _onPageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _bottomNavigationBarOnTapped,
          currentIndex: _page,
          backgroundColor: Colors.blueAccent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          elevation: 20,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore")
          ],
        ),
      ),
    );
  }

  void _onPageChanged(int value) {
    setState(() {
      this._page = value;
    });
  }

  void _bottomNavigationBarOnTapped(int value) {
    _pageController.jumpToPage(value);
  }
}
