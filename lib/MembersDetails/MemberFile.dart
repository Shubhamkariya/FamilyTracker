import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:untitled2/MembersDetails/Camera.dart';

class MemberFile extends StatefulWidget {
  const MemberFile({Key? key}) : super(key: key);

  @override
  _MemberFileState createState() => _MemberFileState();
}

class _MemberFileState extends State<MemberFile> {
  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    String textValue="Code";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Add Members"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add), onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraPage(cameras: cameras)),
              );
            }),
          ]
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: deviceHeight(context) * 0.005,
          left: deviceWidth(context) * 0.005,
          bottom: deviceHeight(context) * 0.03,
        ),
        color: Colors.blue,
        child:Center(
        child:Column(

          children: <Widget>[
            SizedBox(height: 30),
             QrImage(
              data: "Shubham",
              size: 150,
              backgroundColor: Colors.white,
              // You can include embeddedImageStyle Property if you
              //wanna embed an image from your Asset folder
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(
                  90,
                  90,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text("To add new member for tracking.",
              style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),),
            SizedBox(height: 10),
            Text("please scan the QR Family code",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),),
            SizedBox(height: 10),
            Text("Write the code in the below text box",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),),

            SizedBox(height: 30),
            Text(textValue,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),),

          ])),
      ));
    }
}