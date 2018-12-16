import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  
  double latitud;
  double longitud;
  Location _location = new Location();
  bool _permission = false;
  Map<String, double> _currentLocation;
  String error;
  StreamSubscription<Map<String, double>> _locationSubscription;
  var clients = [];
  GoogleMapController mapController;

  Future _warningPlaces() async {
    Firestore.instance.collection('incidencias').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          Firestore.instance
              .collection('incidencias')
              .document(docs.documents[i].documentID.toString())
              .collection('historial')
              .getDocuments()
              .then((hist) {
            if (hist.documents.isNotEmpty) {
              for (int j = 0; j < hist.documents.length; j++) {
                print(hist.documents[j].data);
                var localidad = hist.documents[j].data['localidad'];
                latitud = double.parse(localidad[0]);
                longitud = double.parse(localidad[1]);
                initMarker(latitud, longitud);
              }
            }
          });
        }
      } else {
        print('Esta vacio');
      }
    });
  }

  initMarker(double lati, double long) {
    if(Platform.isIOS){
      mapController.addMarker(MarkerOptions(
        position: LatLng(lati, long),
        draggable: false,
        icon: BitmapDescriptor.fromAsset('assets/Icons/05mapa.png')));
    }else{
      mapController.addMarker(MarkerOptions(
        position: LatLng(lati, long),
        draggable: false,
        icon: BitmapDescriptor.fromAsset('assets/Icons/03mapa.png')));
    }
    
  }

  void initState() {
    super.initState();
    _warningPlaces();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        _currentLocation = result;
      });
      
    });
  }

  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
      print(error);
    }
  }

  _getLocation() {
    latitud = _currentLocation["latitude"];
    longitud = _currentLocation["longitude"];
    _goToLocation(latitud, longitud);
  }

  void _goToLocation(double latitud, double longitud) {
        
    if(Platform.isIOS){
        mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitud+0.005, longitud-0.001),
          tilt: 30.0,
          zoom: 16.0,
        ),
      ));
          mapController.addMarker(MarkerOptions(
        position: LatLng(latitud, longitud),
        draggable: false,
        icon: BitmapDescriptor.fromAsset('assets/Icons/04mapa.png'),
      ));
    }else{
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitud, longitud),
          tilt: 30.0,
          zoom: 16.0,
        ),
      ));
          mapController.addMarker(MarkerOptions(
        position: LatLng(latitud, longitud),
        draggable: false,
        icon: BitmapDescriptor.fromAsset('assets/Icons/02mapa.png'),
      ));
    }

  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color:  Color.fromARGB(255, 238, 243, 243),
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          
          new Image.asset(
          'assets/Icons/01mapa.png',
          width: screenWidth ,
          ),
          Center(
            child: SizedBox(
              width: screenWidth*0.9,
              height: screenHeight*0.7,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                options: GoogleMapOptions(
                cameraPosition: CameraPosition(
                  target: LatLng(-16.4897, -68.1193),
                ),
              ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                color: Color.fromARGB(255, 217, 55, 79),
                onPressed: mapController == null
                ? null
                : () {
                    _getLocation();
                  },
                child: Text(
                  'Mi ubicación',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic),
                ),
              ),
              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                color: Color.fromARGB(255, 217, 55, 79),
                onPressed: mapController == null
                ? null
                : () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                child: Text(
                  'Volver',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          )
          
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
