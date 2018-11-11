import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../globals.dart' as globals;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String phoneNo;
  String smsCode;
  String verificationId;
  Future<void> _verifyPhone() async {
  }
  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: new Center(
        child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Ingrese su número de teléfono'),
                  onChanged: (value) {
                    this.phoneNo = value;
                  },
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                    onPressed: _verifyPhone,
                    child: Text('Verificar')
                )
              ],
            )),
      ),
    );
  }
}
