import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/login.dart';
void main() {
  runApp(FotoyCopia());
}

class FotoyCopia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FotoyCopiaState();
  }
}

class _FotoyCopiaState extends State<FotoyCopia> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      theme: ThemeData(
        // brightness: Brightness.light,
        // canvasColor: Colors.amberAccent[100],
        // primarySwatch: Colors.green,
        // accentColor: Colors.blue[50],
        // buttonColor: Colors.redAccent[100],
        fontFamily: 'Cereal',
      ),
      //home: AuthPage(),// "/" esta reservada para la home page
      routes: {
        '/': (BuildContext context) => new LoginPage(), //LOGIN
        // '/logged': (BuildContext context) => new StartPage(), //HOME PAGE (Logged)
      },
      onUnknownRoute: (RouteSettings settings) {
        //como el 404 no encontrado
        // return MaterialPageRoute(
        //  builder: (BuildContext context) => ProductsPage(_products),
        // );
      },
    );
  }
}
