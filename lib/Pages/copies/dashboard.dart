import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';//Json convert
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  // final Color color;
  // DashboardPage(this.color);

  @override
  State<StatefulWidget> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<DashboardPage> {
  Animation<double> animation;
  AnimationController controller;

  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = new Random();
  int index = 0;
  String backend = "https://fotoycopia-backend.herokuapp.com";
  List notTrahedData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._getAllNotTrashed();
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

  Future<String> _getAllNotTrashed() async {
    String finalUrl = backend + "/get_all_not_trashed";
    var res = await http.get(Uri.encodeFull(finalUrl), headers: {"Accept": "application/json"});
    print("==================");
    print(res);
    print("==================");
    setState(() {
      notTrahedData = json.decode(res.body);
      print(notTrahedData);
      print(notTrahedData[1]);
    });
    print("==================");

    return "Success!";
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

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

    Widget _item(int index, int number, String webViewLink) {
      return GestureDetector(
        onTap: () {
          String toLaunch = webViewLink;
          print("tapped number: " + number.toString());
          setState(() {
            _launchInWebViewWithJavaScript(toLaunch);
          });
        },
        child: CircleAvatar(
          // child: Image.asset(
          //   "assets/Icons/male_user.png",
          // ),
          radius: screenHeight * 0.06,
          backgroundColor: colors[index],
        ),
      );
    }

    void _cloudItems() {
      
      for (int i = 0; i < notTrahedData.length; i++) {
        changeIndex();
        print(notTrahedData[i]['name'] + " - " + notTrahedData[i]['webViewLink']);
        setState(() {
          items.add(_item(index, i, notTrahedData[i]['webViewLink']));
        });

        // items.add(SizedBox(width:screenWidth * 0.05));
      }
    }
    // Este widget luego escuchara a la bd en FIRESTORE y no la de python
    // Widget _buildArrayData(){

    //   return StreamBuilder(
    //     stream: ,
    //     builder: (){

    //       return widget;
    //     },
    //   )
    // }

    Widget _buildCloudItems() {
      _cloudItems();
      return Container(
        padding: new EdgeInsets.only(top: 10.0, left: 10.0),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 20.0,
            spacing: 10.0,
            crossAxisAlignment: WrapCrossAlignment.end,
            direction: Axis.horizontal,
            children: items,
          ),
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