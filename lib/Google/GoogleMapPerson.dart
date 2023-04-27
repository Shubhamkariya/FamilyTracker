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
import 'package:untitled2/NavBar/MemberFile.dart';
import 'package:untitled2/NavBar/Dashboard.dart';
import 'package:untitled2/Utils/Constants.dart';
import 'package:untitled2/Utils/Toast.dart';


class GoogleMapPerson extends StatefulWidget {
  const GoogleMapPerson({Key? key,required this.Latitude, required this.Longitude, required this.ClickName}) : super(key: key);
  final String Latitude;
  final String Longitude;
  final String ClickName;


  @override
  _GoogleMapPersonState createState() => _GoogleMapPersonState();
}

class _GoogleMapPersonState extends State<GoogleMapPerson> {
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
  LatLng initialLocation = const LatLng(27.7089427, 85.3086209);
  BitmapDescriptor markerIcon1 = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon2 = BitmapDescriptor.defaultMarkerWithHue(23);
  late GoogleMapController mapController;
  final Set<Marker> markers = new Set();
  final Set<LatLng> LatLag = new Set();
  final Set<String> UserFamily = new Set();
  final Set<String> UserID = new Set();
  final Set<String> Name = new Set();
  String name ="";
  String email ="";
  String FirstLetter ="";
  late String FamilyId;
  Timer? timer,timer2;
  Query dbRef = FirebaseDatabase.instance.ref().child('User').child("shubhamkariya");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
    addCustomIcon();
    getValue();
    assetOpenValue();
    gettingValue();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => gettingValue());
  }
  Future<void> gettingValue() async {
    LatLag.clear();
    markers.clear();
    Query ListNodeValue = FirebaseDatabase.instance.ref().child('Family').child(FamilyId.toString());
    int value =0;
    print("running function ");
    DatabaseEvent event = await ListNodeValue.once();
    print(event.snapshot.children.length);
    value = event.snapshot.children.length;
    ListNodeValue.once().then((DatabaseEvent snapshot){
      print("Length"+event.snapshot.children.length.toString());
      for (var val in event.snapshot.children){
        print(val.value);
        UserID.add(val.value.toString());
        GetLongitude(val.value.toString());
      }
    });
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
          target: LatLng(double.parse(widget.Latitude), double.parse(widget.Longitude)),
          zoom: 30.4746,
          tilt: 10.440717697143555,
        );
      });
      mapController.animateCamera(CameraUpdate.newCameraPosition(_kLake));

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

  @override
  Widget build(BuildContext context) {
    double LatitudePosition = double.parse(widget.Latitude);
    double LongitudePosition = double.parse(widget.Longitude);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppbarColor,
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
                mapController =  controller;
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
              decoration: BoxDecoration(
                color: AppbarColor,
              ),
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  FirstLetter,
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard), title: Text("Dashboard"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard(familyId: FamilyId)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home), title: Text("Add Members"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemberFile(familyId: FamilyId)),
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
              leading: Icon(Icons.logout), title: Text("Logout"),
              onTap: () {
                signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _goToTheLake() async {
    mapController.animateCamera(CameraUpdate.newCameraPosition(_kLake));

  }
  Future sound() async {
    if(isPlayed)
    {
      setState(() {
        assetsAudioPlayer.play();
        isPlayed =false;
        assetsAudioPlayer.setVolume(10.0);
        assetsAudioPlayer.showNotification=false;
      });
    }
    else{
      setState(() {
        assetsAudioPlayer.stop();
        isPlayed =true;
        assetsAudioPlayer.showNotification=false;

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
  Future<void> getValue() async {
    final FirebaseAuth auth1 = FirebaseAuth.instance;
    final User? user = auth1.currentUser;
    final uid = user?.uid;

    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('User').child(uid.toString());
    starCountRef.onValue.listen((DatabaseEvent event) {
      Map<String, dynamic> data = jsonDecode(
          jsonEncode(event.snapshot.value)) as Map<String, dynamic>;

      setState(() {
        name = data['name'];
        email = data['email'];
        FirstLetter =data['name'].toString()[0];
        FamilyId =data['PersonalFamilyId'];
      });


    });

  }
  Set<Marker> getmarkers() {

    for (final item in LatLag) {
      setState(() {
        markers.add(Marker( //add first marker
          markerId: MarkerId(item.toString()),
          position: item,
          infoWindow: InfoWindow( //popup info
            title: widget.ClickName.toString(),
          ),
          onTap: () {
            if (null != _controller) {
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(new CameraPosition(
                    bearing: 10.8334901395799,
                    target: item,
                    tilt: 0,
                    zoom: 28.00),
                ),);
            }
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(20),//Icon for Marker
        ));

      });
      print("Howdy"+item.toString());
    }
    return markers;
  }
  assetOpenValue() {
    assetsAudioPlayer.open(
        Audio("assets/audio/alert_alert.mp3"),
        autoStart: false,
        showNotification: false
    );
  }
  GetLongitude(String FamilyUid) {
    final FirebaseAuth auth1 = FirebaseAuth.instance;
    final User? user = auth1.currentUser;
    final uid = user?.uid;

    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('User').child(FamilyUid);
    starCountRef.onValue.listen((DatabaseEvent event) {
      Map<String, dynamic> data = jsonDecode(
          jsonEncode(event.snapshot.value)) as Map<String, dynamic>;
      if(data['userId']!=uid.toString()) {
        print("Latitude" + data['name']);
        print(data['Latitude']);
        print(data['Longitude']);
        double lat = data['Latitude'];
        double long = data['Longitude'];
        LatLng newlocation = LatLng(lat, long);
        LatLag.add(newlocation);
        Name.add(data['name']);
        getmarkers();
      }
    });
  }

}