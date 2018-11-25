import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math' as math;
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //Json convert
import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';

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
    var res = await http
        .get(Uri.encodeFull(finalUrl), headers: {"Accept": "application/json"});
    print("==================");
    print(res);
    print("==================");
    setState(() {
      notTrahedData = json.decode(res.body);
      notTrahedData
          .sort((b, a) => a['createdTime'].compareTo(b['createdTime']));
      print(notTrahedData);
      print(notTrahedData[1]);
    });

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

    Widget _item(int index, int number, Map fileData) {
      String mimeType = fileData['mimeType'];
      String fileExtension = (mimeType.contains('word')
          ? 'word'
          : mimeType.contains('pdf')
              ? 'pdf'
              : mimeType.contains('powerpoint')
                  ? 'powerpoint'
                  : mimeType.contains('image')
                      ? 'img'
                      : (mimeType.contains('sheet') ||
                              mimeType.contains('excel'))
                          ? 'excel'
                          : 'unknow');

      String fileImage = "assets/Icons/file_icons/" + fileExtension + '.png';
      int itemsPerRow = 4;
      double radio = screenWidth * (0.9 / 2) / itemsPerRow;
      String itemTitle = fileData['name'].split('.')[0].toLowerCase();

      return GestureDetector(
        onTap: () {
          String toLaunch = fileData['webViewLink'];
          print("tapped number: " + number.toString());
          setState(() {
            _launchInWebViewWithJavaScript(toLaunch);
          });
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                child: Container(
                  // padding: new EdgeInsets.only(top: radio * 1.6),
                  child: DecoratedBox(
                    // position: DecorationPosition.background,
                    child: Text(
                      itemTitle,
                      textAlign: TextAlign.end,
                      style: new TextStyle(
                        fontSize: radio * 2 * 0.25 * 0.5, //50%
                        color: Colors.black87,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow[50],
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                ),
                radius: radio,
                backgroundColor: Colors.brown[300],
              ),
              Container(
                padding: new EdgeInsets.only(top: radio, left: radio),
                child: Image.asset(
                  fileImage,
                  height: radio * 2 * 0.5, //Diametro = 2 * radio, 1.5 = 75 %
                ),
              )
            ],
          ),
        ),
      );
    }

    void _cloudItems() {
      for (int i = 0; i < notTrahedData.length; i++) {
        changeIndex();
        print(
            notTrahedData[i]['name'] + " - " + notTrahedData[i]['webViewLink']);
        setState(() {
          items.add(_item(index, i, notTrahedData[i]));
        });
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
        padding: new EdgeInsets.only(
            top: screenWidth * 0.02, left: screenWidth * 0.02),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 15.0,
            spacing: screenWidth * 0.01,
            // runAlignment: WrapAlignment.spaceBetween,
            // crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            children: items,
          ),
        ),
      );
    }

    double scale = 1.0;
    return GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
          print('---------------');
          print(scaleDetails.scale);
          scale = scaleDetails.scale;
          print('---------------');
          setState(() {});
        },
        child: Container(
            margin: EdgeInsets.all(screenWidth * 0.02),
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: _buildDecoratedAnimation(),
                  child: _buildCloudItems(),
                ),
              ],
            )));
  }
}
