import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'blankPage.dart';
import 'copies/dashboard.dart';
import 'package:quick_actions/quick_actions.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _activePage = 1;

  ScrollController _pageController;

  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: 1,keepPage: true,);
    final QuickActions quickActions = const QuickActions();
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'action_main') {
        print('The user tapped on the "Main view" action.');
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'action_main', localizedTitle: 'Main view', icon: 'AppIcon'),
]);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget _buildCustomAppbar() {
      return Container(
        margin: EdgeInsets.all(10.0),
        padding: new EdgeInsets.only(top: screenHeight * 0.027),
        // height: screenHeight * 0.07,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut().then((action) {
                      Navigator
                          .of(context)
                          .pushReplacementNamed('/');
                    }).catchError((e) {
                      print(e);
                    });
              },
              child: CircleAvatar(
                child: Image.asset(
                  "assets/Icons/male_user.png",
                ),
                radius: screenHeight * 0.04,
                backgroundColor: Colors.blueAccent[100],
              ),
            ),
            Container(
              padding: new EdgeInsets.only(
                left: screenWidth * 0.05,
              ),
              child: Text(
                'Ramiro V.',
                textAlign: TextAlign.justify,
                style: new TextStyle(
                  fontSize: screenHeight * 0.04,
                  color: Colors.amberAccent[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    void displacePage(int displacement) {
      _pageController.animateTo(
        screenWidth * displacement,
        duration: new Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn,
      );
    }

    Widget _buildNavIconButton() {
      return Container(
        child: Container(
          alignment: FractionalOffset.topRight,
          padding: new EdgeInsets.only(
            top: screenHeight * 0.10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                elevation: _activePage == 0 ? 30.0 : 0.0,
                mini: _activePage == 0 ? false : true,
                onPressed: () {
                  // setState(() {
                  //   // _activePage = 0;
                  // });
                  displacePage(0);
                },
                backgroundColor: _activePage == 0 ? Colors.red[600] : Colors.lightBlue[50],
                child: Image.asset("assets/Icons/libro_nube.png"),
              ),
              SizedBox(width: 20.0,),
              FloatingActionButton(
                heroTag: 'submenu_center',
                elevation: _activePage == 1 ? 30.0 : 0.0,
                mini: _activePage == 1 ? false : true,
                onPressed: () {
                  displacePage(1);
                  // setState(() {
                  //   // _activePage = 1;
                  // });
                },
                backgroundColor: _activePage == 1
                    ? Colors.yellow[600]
                    : Colors.lightBlue[50],
                child: Image.asset("assets/Icons/plane.png"),
              ),
              SizedBox(width: 20.0,),
              FloatingActionButton(
                heroTag: 'submenu_right',
                elevation: _activePage == 2 ? 30.0 : 0.0,
                mini: _activePage == 2 ? false : true,
                onPressed: () {
                  displacePage(2);
                  // setState(() {
                  //   // _activePage = 2;
                  // });
                },
                backgroundColor:
                    _activePage == 2 ? Colors.green : Colors.lightBlue[50],
                child: Image.asset("assets/Icons/comidas.png"),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildBlankPage(Color color) {
      return BlankPage(color);
    }

    Widget _buildDashboardPage() {
      return DashboardPage();
    }

    Widget _buildPageView() {
      return Container(
        padding: new EdgeInsets.only(
          top: screenHeight * 0.17,
        ),
        child: PageView(
          onPageChanged: (int value) {
            print('cambie: ' + value.toString());
            setState(() {
              _activePage = value;
            });
          },
          controller: _pageController,
          children: [
            _buildBlankPage(Colors.amber[50]),
            _buildDashboardPage(),
            _buildBlankPage(Colors.yellow[50]),
          ],
        ),
        
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      // floatingActionButton: _buildNavIconButton,
      body: Container(
        child: Stack(
          children: <Widget>[
            _buildCustomAppbar(),
            _buildNavIconButton(),
            _buildPageView(),
          ],
        ),
      ),
    );
  }
}
