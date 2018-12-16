import 'package:flutter/material.dart';
import '../../globals.dart' as globals;
import '../backend_links/firestoreFunctions.dart' as fireStore;

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nomeFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _directionFocusNode = FocusNode();

  final Map<String, dynamic> _formData = {
    'name': null,
    'age': null,
    'direction': null,
  };

  @override
  void initState() {
    super.initState();
    print("init blank");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose blank");
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Future <dynamic> _showCreatedAccountDialog(BuildContext context) async{
      var resp = showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Tu cuenta ha sido creada!',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 20.0,
              ),
            ),
            content: Text(
              'Gracias por unirte ' +  _formData['name'].toString()+'.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'GRACIAS',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  return false;
                },
              ),
            ],
          );
        },
      );
      return resp;
    }

    Widget _buildNameTextField() {
      return TextFormField(
        style: TextStyle(
          height: 0.4,
          color: Colors.black87,
        ),
        focusNode: _nomeFocusNode,
        decoration: InputDecoration(
          // labelText: 'Nombre(s)',
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(18.0),
            ),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (String value) {
          if (value.isEmpty) return 'Llenar';
        },
        onSaved: (String value) {
          _formData['name'] = value;
          setState(() {
            globals.userData['name'] = value;
          });
        },
      );
    }

    Widget _buildAgeTextField() {
      return TextFormField(
        style: TextStyle(
          height: 0.4,
          color: Colors.black87,
        ),
        focusNode: _ageFocusNode,
        decoration: InputDecoration(
          // labelText: 'Nombre(s)',
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(18.0),
            ),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (String value) {
          if (value.isEmpty) return 'Llenar';
        },
        onSaved: (String value) {
          _formData['age'] = value;
          setState(() {
            globals.userData['age'] = value;
          });
        },
      );
    }

    Widget _buildDirectionTextField() {
      return TextFormField(
        style: TextStyle(
          height: 0.4,
          color: Colors.black87,
        ),
        focusNode: _directionFocusNode,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(18.0),
            ),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (String value) {
          if (value.isEmpty) return 'Llenar';
        },
        onSaved: (String value) {
          _formData['direction'] = value;
          setState(() {
            globals.userData['direction'] = value;
          });
        },
      );
    }

    void _submitForm() {
      if (!_formKey.currentState.validate()) {
        return;
      }
      _formKey.currentState.save();
      fireStore.createUser(globals.userData, globals.token).then((value){
        _showCreatedAccountDialog(context).then((value){
          print(value);
          Navigator.of(context).pushReplacementNamed('/concern');
        });
        
      });
    }

    return new Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 210, 185),
      body: new Center(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/Icons/login/01registro.png',
                    width: screenWidth * 0.9,
                  ),
                  Container(
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.45,
                    decoration: new BoxDecoration(
                      color: Color.fromARGB(255, 229, 229, 229),
                    ),
                    child: Container(
                      padding: new EdgeInsets.only(
                        right: screenWidth * 0.85 * 0.15,
                        left: screenWidth * 0.85 * 0.15,
                      ),
                      child: ListView(
                        children: <Widget>[
                          Text(
                            'NOMBRE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 20.0,
                            ),
                          ),
                          _buildNameTextField(),
                          Text(
                            'EDAD',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 20.0,
                            ),
                          ),
                          _buildAgeTextField(),
                          Text(
                            'DIRECCION',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 20.0,
                            ),
                          ),
                          _buildDirectionTextField(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    color: Color.fromARGB(255, 217, 55, 79),
                    onPressed: _submitForm,
                    child: Text(
                      'INGRESAR',
                      style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
