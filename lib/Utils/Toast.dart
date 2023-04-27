
import 'package:background_sms/background_sms.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../UserAccount/Login.dart';

showToast(String toastValue){
  Fluttertoast.showToast(
      msg: toastValue,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Future<void> signOut() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();
  runApp(
      new MaterialApp(
        home: new Login(),
      )
  );
}


Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showToast('Location services are disabled. Please enable the services');

    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showToast('Location permissions are denied');
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {

   showToast('Location permissions are permanently denied, we cannot request permissions.');
    return false;
  }
  return true;
}
Future<void> camera() async {
  var status = await Permission.camera.status;
  if (status.isDenied) {
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
    print("Permission is denined.");
  }else if(status.isGranted){
    //permission is already granted.
    print("Permission is already granted.");
  }else if(status.isPermanentlyDenied){
    //permission is permanently denied.
    print("Permission is permanently denied");
  }else if(status.isRestricted){
    //permission is OS restricted.
    print("Permission is OS restricted.");
  }
}

Future<void> smsPermission() async{
  var status_SMS = await Permission.sms.request();
  var status_LOC = await Permission.location.request();
  var status_Call = await Permission.phone.request();
  var status_Cam = await Permission.camera.request();

  if (status_SMS.isDenied || status_LOC.isDenied || status_Call.isDenied || status_Cam.isDenied) {
   showToast("Please give the permission");
  }

}

Future<void> SMS_send(String recipent,String MessageText) async {
  SmsStatus result = await BackgroundSms.sendMessage(
      phoneNumber: recipent, message: MessageText, simSlot: 1);
  if (result == SmsStatus.sent) {
    print("Sent1");
  } else {
    print("Failed1");
  }
}

checkIfUserExists() async {
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('User is currently signed out!');
    return false;
  } else {
    print('User is signed in!');
    return true;
  }
}
