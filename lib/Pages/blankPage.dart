import 'package:flutter/material.dart';

class BlankPage extends StatefulWidget {
  final Color color;
  BlankPage(this.color);

  @override
  State<StatefulWidget> createState() {
    return _BlankPageState(color);
  }
}

class _BlankPageState extends State<BlankPage> {
  final Color color;

  _BlankPageState(this.color);

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
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: color,
      // child: pageContent,
    );
  }
}
