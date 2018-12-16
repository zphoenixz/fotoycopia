import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'blankPage.dart';


class ConcerningPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ConcerningPageState();
  }
}

class _ConcerningPageState extends State<ConcerningPage>
    with SingleTickerProviderStateMixin {
  String title = 'Ramiro V.';
  TabController _pageController;

  void initState() {
    super.initState();
    _pageController =
        new TabController(length: 3, initialIndex: 0, vsync: this);

 
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget _buildCustomAppbar() {
      return Container(
        margin: EdgeInsets.all(10.0),
        padding: new EdgeInsets.only(top: screenHeight * 0.027),
        // height: screenHeight * 0.07,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut().then((action) {
                  Navigator.of(context).pushReplacementNamed('/');
                }).catchError((e) {
                  print(e);
                });
              },
              child: CircleAvatar(
                child: Image.asset(
                  "assets/Icons/male_user.png",
                ),
                radius: screenHeight * 0.04,
                backgroundColor: Colors.blueAccent[100],
              ),
            ),
            Container(
              padding: new EdgeInsets.only(
                left: screenWidth * 0.05,
              ),
              child: Text(
                title,
                textAlign: TextAlign.justify,
                style: new TextStyle(
                  fontSize: screenHeight * 0.04,
                  color: Colors.amberAccent[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildNavIconButton() {
      return Container(
        child: Container(
          alignment: FractionalOffset.topRight,
          padding: new EdgeInsets.only(
            top: screenHeight * 0.10,
          ),
        ),
      );
    }

    Widget _buildTab_1() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: screenHeight * 0.14 * 0.9),
          Image.asset(
            'assets/Icons/just_sign_up/pantalla1_1.png',
            width: screenWidth * 0.75,
          ),
          SizedBox(height: 20.0),
          Image.asset(
            'assets/Icons/just_sign_up/pantalla1_2.png',
            height: screenHeight * 0.07 * 0.9,
          ),
          SizedBox(height: screenHeight * 0.17),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                color: Color.fromARGB(255, 217, 55, 79),
                onPressed: () {
                  setState(() {
                    _pageController.index = 1;
                  });
                },
                child: Text(
                  'SIGUIENTE',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(width: screenWidth * 0.07)
            ],
          ),
        ],
      );
    }

    Widget _buildTab_2() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: screenHeight * 0.1 * 0.9),
          Image.asset(
            'assets/Icons/just_sign_up/pantalla2_1.png',
            width: screenWidth * 0.75,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                'assets/Icons/just_sign_up/pantalla2_3.png',
                height: screenHeight * 0.4 * 0.9,
              ),
              Image.asset(
                'assets/Icons/just_sign_up/pantalla2_2.png',
                height: screenHeight * 0.09 * 0.9,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                color: Color.fromARGB(255, 217, 55, 79),
                onPressed: () {
                  setState(() {
                    _pageController.index = 2;
                  });
                },
                child: Text(
                  'SIGUIENTE',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(width: screenWidth * 0.07)
            ],
          ),
        ],
      );
    }

    Widget _buildTab_3() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: screenHeight * 0.3 * 0.9),
          Image.asset(
            'assets/Icons/just_sign_up/pantalla3_1.png',
            width: screenWidth * 0.75,
          ),
          
          SizedBox(height: screenHeight * 0.3 * 0.9),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                color: Color.fromARGB(255, 64, 77, 94),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: Text(
                  'COMENZAR',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(width: screenWidth * 0.07)
            ],
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 243, 243),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 238, 243, 243),
        title: TabBar(
          controller: _pageController,
          indicatorColor: Color.fromARGB(255, 217, 55, 79),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 20.0,
          tabs: [
            Tab(icon: Icon(null)),
            Tab(icon: Icon(null)),
            Tab(icon: Icon(null)),
          ],
        ),
      ),
      // floatingActionButton: _buildNavIconButton,
      body: TabBarView(
        controller: _pageController,
        children: [
          _buildTab_1(),
          _buildTab_2(),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut().then((action) {
                Navigator.of(context).pushReplacementNamed('/login');
              }).catchError((e) {
                print(e);
              });
            },
            child: _buildTab_3(),
          ),
        ],
      ),
      // Container(
      //   child: Stack(
      //     children: <Widget>[
      //       _buildCustomAppbar(),
      //       _buildNavIconButton(),
      //     ],
      //   ),
      // ),
    );
  }
}
