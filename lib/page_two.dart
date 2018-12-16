import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => new _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/');
        },
        child: new FlareActor(
          "assets/ani.flr",
          alignment: Alignment.center,
          animation: "Untitled",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
