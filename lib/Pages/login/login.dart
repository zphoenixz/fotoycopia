import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../backend_links/firestoreFunctions.dart' as fireStore;
import 'package:flare_flutter/flare_actor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../globals.dart' as globals;

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

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      print('verified');
            setState(() {
        globals.userData['phone'] = "+591" + this.phoneNo;    
      });

      fireStore.checkNumber(globals.userData['phone']).then((exists) {
        
        if (exists) {
          print('existe!!!!-----------------------------------------');
          if (user != null) {
            Navigator.of(context).pushReplacementNamed('/home');
            print("Ya tengo cuenta 1");
          } else {
            print("Ya tengo cuenta 2");
            signIn('/home');
          }
        } else {
          print('no existe!!!!-----------------------------------------');
          if (user != null) {
            Navigator.of(context).pushReplacementNamed('/signup');
            print("No tengo cuenta 1");
          } else {
            print("No tengo cuenta 2");
            signIn('/signup');
          }

        }
      });

      // Navigator.of(context).pushReplacementNamed('/home');
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+591" + this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  _authCode() async {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        globals.userData['phone'] = "+591" + this.phoneNo;    
      });

      fireStore.checkNumber(globals.userData['phone']).then((exists) {
        
        if (exists) {
          print('existe!!!!-----------------------------------------');
          if (user != null) {
            Navigator.of(context).pushReplacementNamed('/home');
            print("Ya tengo cuenta 1");
          } else {
            print("Ya tengo cuenta 2");
            signIn('/home');
          }
        } else {
          print('no existe!!!!-----------------------------------------');
          if (user != null) {
            Navigator.of(context).pushReplacementNamed('/signup');
            print("No tengo cuenta 1");
          } else {
            print("No tengo cuenta 2");
            signIn('/signup');
          }

        }
      });
    });
  }

  Future<dynamic> signIn(String dir) {
    return FirebaseAuth.instance
        .signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode)
        .then((user) {
      Navigator.of(context).pushReplacementNamed(dir);
    }).catchError((e) {
      print(e);
      return false;
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        Navigator.of(context).pushNamed('/home');
      }
    }).catchError((e) {
      print(e);
    });
    verificar = false;
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) {
      print(token);
      setState(() {
        globals.token = token;    
      });
      
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget _buildPhoneTextField(bool verificar) {
      return Container(
        width: screenWidth * 0.9,
        child: TextField(
          focusNode: _phoneFocusNode,
          enabled: !verificar,
          decoration: InputDecoration(
            labelText: 'Celular',
            hintText: "Número de celular",
            border: OutlineInputBorder(),
            fillColor: Colors.white,
            filled: true,
          ),
          keyboardType: TextInputType.number,
          onChanged: (String value) {
            phoneNo = value;
          },
        ),
      );
    }

    Widget _buildCodeTextField() {
      return Container(
        width: screenWidth * 0.9,
        child: TextField(
          focusNode: _codeFocusNode,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Código SMS',
            hintText: "Ingrese su código",
            border: OutlineInputBorder(),
            fillColor: Colors.white,
            filled: true,
          ),
          onChanged: (String value) {
            smsCode = value;
          },
        ),
      );
    }

    return new Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 210, 185),
      body: Stack(children: <Widget>[new FlareActor(
        "assets/ani.flr",
        animation: "Untitled",
        fit: BoxFit.none,
      ),
            new Center(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/Icons/login/01login.png',
                width: screenWidth * 0.9,
              ),
              SizedBox(height: screenHeight * 0.07),
              _buildPhoneTextField(this.verificar),
              SizedBox(height: 10.0),
              verificar ? Container(child: _buildCodeTextField()) : Container(),
              SizedBox(height: 10.0),
              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                color: Color.fromARGB(255, 217, 55, 79),
                onPressed: () {
                  // FocusScope.of(context).requestFocus(_codeFocusNode);
                  verificar ? _authCode() : verifyPhone();
                  verificar = true;
                },
                child: verificar
                    ? Text(
                        'VERIFICAR',
                        style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      )
                    : Text(
                        'INGRESAR',
                        style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
              ),
              verificar
                  ? Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/');
                        },
                        child: Text(
                          'mejor otro número...',
                          style: TextStyle(
                              color: Color.fromARGB(255, 217, 55, 79),
                              // fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      
      ],) 
      
      

    );
  }
}
