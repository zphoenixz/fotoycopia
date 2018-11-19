import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
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
  bool verificar;
  final _phoneFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();
  var _phoneController = new TextEditingController();
  var _codeController = new TextEditingController();

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      print('verified');
      Navigator.of(context).pushReplacementNamed('/prueba');
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+591"+this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  _authCode() {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/prueba');
        print("Ya estoy adentro");
      } else {
        signIn();
      }
    });
  }

  

  Future<dynamic> signIn() {
    return FirebaseAuth.instance
        .signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode)
        .then((user) {
      Navigator.of(context).pushReplacementNamed('/prueba');
    }).catchError((e) {
      print(e);
      return false;
    });
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        Navigator.of(context).pushNamed('/prueba');
      }
    }).catchError((e) {
      print(e);
    });
    verificar = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0),
                _buildPhoneTextField(this.verificar),
                SizedBox(height: 10.0),
                verificar ? Container(child: _buildCodeTextField()) : Container(),
                SizedBox(height: 10.0),
                RaisedButton(
                  onPressed: () {
                  FocusScope.of(context).requestFocus(_codeFocusNode);
                  verificar ? _authCode() : verifyPhone();
                  verificar = true;
                },
                child: verificar ? Text('Verificar') : Text('Enviar codigo')),
                verificar ? Container(
                  child: RaisedButton(
                  onPressed: () {Navigator.of(context).pushNamed('/');},
                  child: Text('Cambiar número'))) : Container(),
              ]
            ),
          ),
        ),
    );
  }
  Widget _buildPhoneTextField(bool verificar) {
    return TextField(
      focusNode: _phoneFocusNode,
      enabled: !verificar,
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Celular',
        hintText: "Número de celular",
        border: OutlineInputBorder(),
        fillColor: Colors.white54,
        filled: true,
      ),
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        phoneNo = value;
      },
    );
  }

  Widget _buildCodeTextField() {
    return TextField(
      focusNode: _codeFocusNode,
      controller: _codeController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Código SMS',
        hintText: "Ingrese su código",
        border: OutlineInputBorder(),
        fillColor: Colors.white54,
        filled: true,
      ),
      onChanged: (String value) {
        smsCode = value;
      },
    );
  }
}
