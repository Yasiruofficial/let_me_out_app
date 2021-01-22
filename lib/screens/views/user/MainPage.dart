import 'package:flutter/material.dart';
import 'package:let_me_out/screens/components/CustomDivider.dart';
import 'package:let_me_out/screens/views/user/Explore.dart';
import 'package:let_me_out/screens/views/user/Map.dart';
import 'package:let_me_out/screens/views/user/Home.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/HomeUpdateViewModel.dart';
import 'package:let_me_out/view_models/LandingPage_view_model.dart';
import 'package:let_me_out/view_models/MapUpdate_view_model.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;

  MainPage({this.baseAuthService, this.firestoreService});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _pageController;
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    Widget title;

    if (_page == 0) {
      title = Text("Event Map");
    } else if (_page == 1) {
      title = Text("Home");
    } else {
      title = Text("My Tickets");
    }

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
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            ChangeNotifierProvider<MapUpdateViewModel>(
              create: (context) => MapUpdateViewModel(),
              child: Map(
                baseAuthService: widget.baseAuthService,
                firestoreService: widget.firestoreService,
              ),
            ),
            ChangeNotifierProvider<HomeUpdateViewModel>(
              create:(context) => HomeUpdateViewModel() ,
              child: Home(
                baseAuthService: widget.baseAuthService,
                firestoreService: widget.firestoreService,
              ),
            ),
            Explore(
              baseAuthService: widget.baseAuthService,
              firestoreService: widget.firestoreService,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blueAccent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          elevation: 20,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                ),
                label: "Map"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.sticky_note_2_outlined,
                ),
                label: "Tickets"),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
