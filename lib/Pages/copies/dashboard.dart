import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math';

class DashboardPage extends StatefulWidget {
  // final Color color;
  // DashboardPage(this.color);

  @override
  State<StatefulWidget> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<DashboardPage> {
  Animation<double> animation;
  AnimationController controller;

  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = new Random();
  int index = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: new Duration(milliseconds: 600), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.elasticInOut)
          ..addListener(() => this.setState(() {}))
          ..addStatusListener((AnimationStatus status) {});

    controller.forward().whenComplete(() {
      controller.reverse();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    List<Widget> items = new List();

    void changeIndex() {
      setState(() => index = random.nextInt(3));
    }

    BoxDecoration _buildDecoratedAnimation() {
      return BoxDecoration(
        color: Colors.amber[200],
        borderRadius: BorderRadius.all(
          Radius.lerp(
            Radius.circular(25.0),
            Radius.circular(70.0),
            animation.value,
          ),
        ),
      );
    }

    Widget _item(int index) {
      return CircleAvatar(
        // child: Image.asset(
        //   "assets/Icons/male_user.png",
        // ),
        radius: screenHeight * 0.06,
        backgroundColor: colors[index],
      );
    }

    void _cloudItems() {
      for (int i = 0; i < 10; i++) {
        changeIndex();
        setState(() {
          items.add(_item(index));   
        });
        
        // items.add(SizedBox(width:screenWidth * 0.05));
      }
    }

    Widget _buildCloudItems() {
      _cloudItems();
      return Container(
        padding: new EdgeInsets.only(top: 10.0, left: 10.0),
        child: Wrap(
          runSpacing: 20.0,
          spacing: 10.0,
          crossAxisAlignment: WrapCrossAlignment.end,
          direction: Axis.horizontal,
          children: items,
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(10.0),
      color: Colors.transparent,
      child: Container(
        decoration: _buildDecoratedAnimation(),
        child: _buildCloudItems(),
      ),
    );
  }
}
