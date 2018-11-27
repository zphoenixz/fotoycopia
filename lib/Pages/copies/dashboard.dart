import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
// import 'dart:math' as math;
// import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //Json convert
import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  // Random random = new Random();
  // int index = 0;
  String backend = "https://fotoycopia-backend.herokuapp.com";
  List notTrahedData;

  @override
  bool get wantKeepAlive => true;
  double itemsPerRow;
  @override
  void initState() {
    setState(() {
      itemsPerRow = 4.0;
    });

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
    setState(() {
      notTrahedData = json.decode(res.body);
      notTrahedData
          .sort((b, a) => a['createdTime'].compareTo(b['createdTime']));
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
    double radio = screenWidth * (0.87 / 2) / itemsPerRow;
    double margenExterno = screenWidth * 0.04;
    double spacing = (screenWidth - margenExterno - (radio * 2 * itemsPerRow)) /
        (itemsPerRow);
    double margenInterno = spacing / 2;

    List<Widget> items = new List();

    BoxDecoration _buildDecoratedAnimation() {
      return BoxDecoration(
        color: Colors.amber[200],
        borderRadius: BorderRadius.all(
          Radius.lerp(
            Radius.circular(38.0),
            Radius.circular(70.0),
            animation.value,
          ),
        ),
      );
    }

    Widget _item(int number, Map fileData) {
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

      String itemTitle = fileData['fileName'].split('.')[0].toLowerCase();

      return GestureDetector(
        onTap: () {
          String toLaunch =
              'https://drive.google.com/file/d/' + fileData['fileId'] + '/view?usp=drivesdk';
          setState(() {
            _launchInWebViewWithJavaScript(toLaunch);
          });
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                child: Container(
                  child: DecoratedBox(
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

    Widget _buildCloudItems() {
      return Container(
        width: screenWidth,
        height: screenHeight * 0.82,
        padding:
            new EdgeInsets.only(top: screenWidth * 0.02, left: margenInterno),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 15.0,
            spacing: spacing,
            direction: Axis.horizontal,
            children: items,
          ),
        ),
      );
    }

    Widget _buildDocsListView() {
      return StreamBuilder(
        stream: Firestore.instance
            .collection('documents-ucb')
            .orderBy('createdTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            );
          if (snapshot.hasError)
            print("el error es::::: " + snapshot.error.toString());
          items.clear();
          for (int i = 0; i < snapshot.data.documents.length; i++) {
            var data = snapshot.data.documents;
            Map<dynamic, dynamic> item = {
              'mimeType': data[i]['mimeType'],
              'fileName': data[i]['fileName'],
              'isVisible': data[i]['isVisible'],
              'createdTime': data[i]['createdTime'],
              'fileId': data[i].documentID.trim(),
            };
            items.add(_item(i, item));
            // print('->'+data[i].documentID.trim()+'<-');
          }
          return _buildCloudItems();
        },
      );
    }

    Widget _buildZoomInOutButtons(int inOrOut) {
      return Container(
        margin: EdgeInsets.only(
            top: screenHeight * 0.0,
            left: inOrOut == 1 ? 0.0 : screenWidth * 0.08),
        child: GestureDetector(
          child: Image.asset(
            inOrOut == 1
                ? "assets/Icons/app_bar_icons/zoom_in.png"
                : "assets/Icons/app_bar_icons/zoom_out.png",
            height: screenHeight * 0.03,
            color: itemsPerRow == 2 && inOrOut == -1
                ? Colors.red
                : itemsPerRow == 10 && inOrOut == 1 ? Colors.red : null,
          ),
          onTap: () {
            setState(() {
              if (itemsPerRow > 2 && inOrOut == -1) {
                itemsPerRow = itemsPerRow + inOrOut;
              } else if (itemsPerRow < 10 && inOrOut == 1) {
                itemsPerRow = itemsPerRow + inOrOut;
              }
            });
          },
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(margenExterno / 2),
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _buildZoomInOutButtons(1),
          _buildZoomInOutButtons(-1),
          Container(
            margin: EdgeInsets.only(top: screenHeight * 0.04),
            decoration: _buildDecoratedAnimation(),
            child: _buildDocsListView(),
          ),
        ],
      ),
    );
  }
}
