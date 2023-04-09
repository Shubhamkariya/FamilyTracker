import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:background_sms/background_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:untitled2/MembersDetails/MemberFile.dart';


class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  List<String> recipent =["09834242046","8485017950"];
  Completer<GoogleMapController> _controller = Completer();
  String? _currentAddress;
  Position? _currentPosition;
  double? latitude;
  double? longitude;

  MapType _currentMapType = MapType.normal;
  bool isPlayed = true;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  late CameraPosition _kLake;



  // given camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(27.7089427, 85.3086209),
    zoom: 15,
  );

  LatLng initialLocation = const LatLng(27.7089427, 85.3086209);
  BitmapDescriptor markerIcon1 = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon2 = BitmapDescriptor.defaultMarkerWithHue(23);


  final Set<Marker> markers = new Set();
  final Set<LatLng> LatLag = new Set();
  final Set<String> UserFamily = new Set();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
    addCustomIcon();
    getValue();
    // _goToTheLake();
    assetsAudioPlayer.open(
        Audio("assets/audio/alert_alert.mp3"),
        autoStart: false,
        showNotification: true
    );


  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {

      //Import dart:core
      String uniqueFileName =
      DateTime.now().millisecondsSinceEpoch.toString();
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("User").child(uid.toString());
      Map<String, dynamic> students = {
        'Latitude': position.latitude,
        'Longitude':position.longitude,
        'Zoom':30.4746,
        'tilt': 10.440717697143555,
        'bearing': 192.8334901395799
      };
      await dbRef.update(students);
      setState((){
          _kLake = CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(position.latitude, position.longitude),
              zoom: 30.4746,
              tilt: 10.440717697143555,
              );
          });

    }).catchError((e) {
      debugPrint(e);
    });
  }
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/download.png")
        .then(
          (icon) {
        setState(() {
          markerIcon1 = icon;
        });
      },
    );
  }
  Query dbRef = FirebaseDatabase.instance.ref().child('User').child("shubhamkariya");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Map Tracker"),
      ),
      body:  Stack(
      children: <Widget>[
            GoogleMap(
              mapType: _currentMapType,
              initialCameraPosition:  CameraPosition(
                target: initialLocation,
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              zoomControlsEnabled: true,
            markers: getmarkers(),

        onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        },
      ),
       Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
      child: Align(
      alignment: Alignment.topRight,
      child: FloatingActionButton(
              onPressed: _onMapTypeButtonPressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.green,
              child: const Icon(Icons.map, size: 30.0),
            ),
          ),
        ),
       Padding(
        padding: const EdgeInsets.fromLTRB(0, 70, 10, 0),
        child: Align(
        alignment: Alignment.topRight,
        child:FloatingActionButton(
          elevation: 100,
          hoverColor: Colors.red,
          autofocus: true,
            onPressed:() async {
              FlutterPhoneDirectCaller.callNumber("+918485017950");
              _send();
            },
            child: Icon(Icons.call)
          ))
       ),
       Padding(
            padding: const EdgeInsets.fromLTRB(0, 140, 10, 0),
            child: Align(
                alignment: Alignment.topRight,
                child:FloatingActionButton(
                  elevation: 100,
                  backgroundColor: Colors.red,
                  hoverColor: Colors.red,
                  autofocus: true,
                  onPressed: _goToTheLake,
                  child: Icon(Icons.add_location),
                  tooltip: 'Go to Current Location',
                ))
        ),
       Padding(
            padding: const EdgeInsets.fromLTRB(0, 210, 10, 0),
            child: Align(
                alignment: Alignment.topRight,
                child:FloatingActionButton(
                  elevation: 100,
                  backgroundColor: Colors.deepPurple,
                  hoverColor: Colors.red,
                  autofocus: true,
                  onPressed:  sound ,
                  child: isPlayed? Icon(Icons.play_arrow): Icon(Icons.pause) ,
                  tooltip: 'Pick Image',
                ))
        )
      ]),
      drawer:  Drawer(
      child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("Abhishek Mishra"),
          accountEmail: Text("abhishekm977@gmail.com"),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Text(
              "A",
              style: TextStyle(fontSize: 40.0),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home), title: Text("Add Members"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MemberFile()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.settings), title: Text("Settings"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.contacts), title: Text("Contact Us"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
    ),
   );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future sound() async {
    if(isPlayed)
    {
      setState(() {
        assetsAudioPlayer.play();
        isPlayed =false;
        assetsAudioPlayer.setVolume(10.0);
      });
    }
    else{
      setState(() {
        assetsAudioPlayer.stop();
        isPlayed =true;
      });
    }
  }

  Future<void> _send() async {
    try {
      await BackgroundSms.sendMessage( phoneNumber:"08485017950", message: "Please find the location ");
    }catch(onError){
      print(onError);
    }
  }

  void getValue() {
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('FamilyNew').child("common");
    starCountRef.onValue.listen((DatabaseEvent event) {
      Map<String, dynamic> data = jsonDecode(
          jsonEncode(event.snapshot.value)) as Map<String, dynamic>;
      print("Howdy"+data['UserId1']);
      print("Howdy"+data['userId2']);
      // UserFamily.add(data['UserId1']);
      // UserFamily.add(data['userId2']);
    });
    DatabaseReference starCountRef2 =
    FirebaseDatabase.instance.ref('FamilyNew').child("common");
    starCountRef.onValue.listen((DatabaseEvent event) {
      Map<String, dynamic> data = jsonDecode(
          jsonEncode(event.snapshot.value)) as Map<String, dynamic>;
      print("Howdy"+data['UserId1']);
      print("Howdy"+data['userId2']);
      // UserFamily.add(data['UserId1']);
      // UserFamily.add(data['userId2']);
    });


  }

  Set<Marker> getmarkers() {
    for (final item in LatLag) {
      print("Howdy"+item.toString());
    }
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId(initialLocation.toString()),
        position: initialLocation, //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Marker Title First ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      // markers.add(Marker( //add second marker
      //   markerId: MarkerId("showLocation1"),
      //   position: LatLng(27.7099116, 85.3132343), //position of marker
      //   infoWindow: InfoWindow( //popup info
      //     title: 'Marker Title Second ',
      //     snippet: 'My Custom Subtitle',
      //   ),
      //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      // ));
      //
      // markers.add(Marker( //add third marker
      //   markerId: MarkerId("showLocation2"),
      //   position: LatLng(27.7137735, 85.315626), //position of marker
      //   infoWindow: InfoWindow( //popup info
      //     title: 'Marker Title Third ',
      //     snippet: 'My Custom Subtitle',
      //   ),
      //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      // ));

      //add more markers here
    });

    return markers;
  }

}