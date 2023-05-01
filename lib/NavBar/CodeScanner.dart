
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:untitled2/Utils/Constants.dart';


class CodeScanner extends StatefulWidget {
  const CodeScanner({Key? key}) : super(key: key);

  @override
  _CodeScannerState createState() => _CodeScannerState();
}

class _CodeScannerState extends State<CodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppbarColor,
        title: Text("Scan the Code",
        style: TextStyle(color: Colors.white),),
      ),
      body:Container(
      color: Colors.blue,
      child:Column(
        children: <Widget>[

          SizedBox(height: 10),
          Text("Scan the Family Code",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),),
          SizedBox(height: 30),
          Center(
            child:Container(
              height: deviceHeight(context) * 0.5,
              width: deviceWidth(context) * 0.8,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            )),
        Center(
        child:Container(
          child:Column(
            children:<Widget>[
            SizedBox(height: 30),
           (result != null)
                  ?Container(
             width: deviceWidth(context) * 0.8,
             child:Text(
                 '${result!.code}',
                 style: TextStyle(
                 color: Colors.white,
                 fontSize: 10,
              ),))
                  : Text('',
             style: TextStyle(
             color: Colors.white,
             fontSize: 20,
           ),),

            ]
          ))
        ),
         SizedBox(height: 30),
         Center(
           child: FloatingActionButton.extended(
             onPressed: (){
               addMe(result!.code);
             },
             backgroundColor: Color(0xFF01579B),
             splashColor: Colors.black26,
             icon: Icon(Icons.add),
             label: Text('Add Me'),
           ),
         )
        ],
      ),
    ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> addMe(String? code) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    int value=0;
    final String CurrentCode ;

      Query ListNodeValue = FirebaseDatabase.instance.ref().child('Family').child(code.toString());
      print("running function ");
      DatabaseEvent event = await ListNodeValue.once();
      print(event.snapshot.children.length);
      value = event.snapshot.children.length;
      ListNodeValue.once().then((DatabaseEvent snapshot){
        print("Length"+event.snapshot.children.length.toString());
      });

      showToast("CODE WHICH IS BEEN ADDED+$code");

      DatabaseReference dbRef2 = FirebaseDatabase.instance.ref()
          .child("Family")
          .child(code.toString());
      Map<String, String> students2 = {
        'userId_$value': uid.toString(),
      };
      await dbRef2.update(students2)
      .then((_) {
        showToast("Added successfully");
      })
      .catchError((onError) {
        showToast(onError.toString());
      });

    //Code Change
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("User").child(uid.toString());
    Map<String, dynamic> UpdateData = {
      'PersonalFamilyId':code.toString(),
    };
    await dbRef.update(UpdateData);


  }
  showToast(String toastValue){
    Fluttertoast.showToast(
        msg:toastValue,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

