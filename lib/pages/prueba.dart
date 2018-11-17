 
import 'package:flutter/material.dart';
 
import 'package:firebase_auth/firebase_auth.dart';
 
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}
 
class _DashboardPageState extends State<DashboardPage> {
  String uid = '';
  String name= '';
 
  getUid() {}
 
  @override
  void initState() {
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
        this.name= val.phoneNumber;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
          child: Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('You are now logged in as ${uid}, your phoneNumber is ${name}'),
                SizedBox(
                  height: 15.0,
                ),
                new OutlineButton(
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 3.0),
                  child: Text('Logout'),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((action) {
                      Navigator
                          .of(context)
                          .pushReplacementNamed('/');
                    }).catchError((e) {
                      print(e);
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}