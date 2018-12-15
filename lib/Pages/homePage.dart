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
  String title = 'Ramiro V.';

  void initState() {
    super.initState();

    final QuickActions quickActions = const QuickActions();
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'action_main') {
        Navigator.pushNamed(context, '/PageTwo');
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
              onTap: () {
                FirebaseAuth.instance.signOut().then((action) {
                  Navigator.of(context).pushReplacementNamed('/');
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
                title,
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

    Widget _buildNavIconButton() {
      return Container(
        child: Container(
          alignment: FractionalOffset.topRight,
          padding: new EdgeInsets.only(
            top: screenHeight * 0.10,
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
          ],
        ),
      ),
    );
  }
}
