import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_actions/quick_actions.dart';
import './backend_links/firestoreFunctions.dart' as fireStore;
import '../globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    final QuickActions quickActions = const QuickActions();
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'testigo') {
        Navigator.pushNamed(context, '/PageTwo');
      }else if (shortcutType == 'panico') {
        Navigator.pushNamed(context, '/home');
        fireStore.panicAttack(globals.userData['phone']);
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'testigo',
        localizedTitle: 'Soy Testigo!',
        icon: 'AppIcon',
      ),
      const ShortcutItem(
        type: 'panico',
        localizedTitle: 'Auxilio!',
        icon: 'AppIcon',
      ),
    ]);
  }

  bool _isPushed = false;
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
                  "assets/Icons/home/02inicio.png",
                ),
                radius: screenHeight * 0.04,
                backgroundColor: Color.fromARGB(0, 0, 0, 0),
              ),
            ),
            Container(
              padding: new EdgeInsets.only(
                left: screenWidth * 0.05,
              ),
              child: CircleAvatar(
                child: Image.asset(
                  "assets/Icons/home/03inicio.png",
                ),
                radius: screenHeight * 0.04,
                backgroundColor: Color.fromARGB(0, 0, 0, 0),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildCustomAppbar(),
            SizedBox(height: screenHeight * 0.05),
            GestureDetector(
              onTapDown: (value) {
                setState(() {
                  _isPushed = true;
                });
              },
              onTapUp: (value) {
                setState(() {
                  _isPushed = false;
                });
                fireStore.panicAttack(globals.userData['phone']);
              },
              child: Image.asset(
                !_isPushed
                    ? 'assets/Icons/home/botonApretado.png'
                    : "assets/Icons/home/01inicio.png",
                width: screenWidth * 0.6,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: Color.fromARGB(255, 117, 224, 203),
                  onPressed: () {},
                  child: Text(
                    'CONTACTOS',
                    style: TextStyle(
                      color: Color.fromARGB(255, 34, 68, 61),
                      fontWeight: FontWeight.w900,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: Color.fromARGB(255, 117, 224, 203),
                  onPressed: () {},
                  child: Text(
                    '        MAPA         ',
                    style: TextStyle(
                      color: Color.fromARGB(255, 34, 68, 61),
                      fontWeight: FontWeight.w900,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: Color.fromARGB(255, 117, 224, 203),
                  onPressed: () {},
                  child: Text(
                    'TOMA NOTA',
                    style: TextStyle(
                      color: Color.fromARGB(255, 34, 68, 61),
                      fontWeight: FontWeight.w900,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: Color.fromARGB(255, 117, 224, 203),
                  onPressed: () {},
                  child: Text(
                    'INFORMATE',
                    style: TextStyle(
                      color: Color.fromARGB(255, 34, 68, 61),
                      fontWeight: FontWeight.w900,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Color.fromARGB(255, 217, 55, 79),
              onPressed: () {},
              child: Text(
                'FUI TESTIGO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
          ],
        ),
      ),
    );
  }
}
