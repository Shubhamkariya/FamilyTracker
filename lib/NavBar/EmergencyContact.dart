import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/Google/GoogleMap.dart';
import 'package:untitled2/NavBar/CodeScanner.dart';
import 'package:untitled2/UserAccount/AlreadyHaveanaccount.dart';
import 'package:untitled2/Utils/Toast.dart';

import '../Utils/Constants.dart';



class EmergencyContact extends StatefulWidget {
  @override
  _EmergencyContactState createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  TextEditingController EmergencyContact1 = TextEditingController();
  TextEditingController EmergencyContact2 = TextEditingController();
  TextEditingController EmergencyContact3 = TextEditingController();

  String istapped = '';
  String emergencyContactValue1 = '', emergencyContactValue2 = '', emergencyContactValue3='';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SetData();
  }
  @override
  Widget build(BuildContext context) {
    double heightFlutter = MediaQuery.of(context).size.height;
    double widthFlutter = MediaQuery.of(context).size.width;


    FocusNode myFocusNode = new FocusNode();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:AppbarColor,
        appBar: AppBar(
            backgroundColor: AppbarColor,
            title: Text("Add Members"),

        ),
        body: SingleChildScrollView(
                child:Center(
                    child: Card(
                        color: AppbarColor,
                        child: SizedBox(
                            height: heightFlutter*0.9,
                            width: widthFlutter*0.9,
                            child: Column(
                                children: [
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5, right: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 30, // <-- Your height
                                            //  signInWithGoogle();
                                          ),
                                          Text("Add Emergency Contact so you can contact and send location via SMS",
                                          style:TextStyle(color:Colors.white,
                                          fontSize: 20)),
                                          SizedBox(
                                            height: 30, // <-- Your height
                                            //  signInWithGoogle();
                                          ),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppbarColorLight,
                                                    borderRadius: new BorderRadius.circular(30.0),
                                                  ),
                                                  child: Padding(
                                                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                                                      child: TextFormField(
                                                          onChanged: (value1) {
                                                            emergencyContactValue1 = value1;
                                                          },
                                                          controller: EmergencyContact1,
                                                          keyboardType:TextInputType.phone,
                                                          style: TextStyle(color: Colors.white),
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              labelText: 'Emergency Contact',
                                                              hintText: "First Emergency Contact",
                                                              labelStyle: TextStyle(
                                                                  color: myFocusNode.hasFocus ? Colors.white : Colors.white
                                                              ),
                                                              hintStyle: TextStyle(
                                                                  color: myFocusNode.hasFocus ? Colors.white :  Colors.white
                                                              ),

                                                          ))))),
                                          SizedBox(
                                            height: 10, // <-- Your height
                                            //  signInWithGoogle();
                                          ),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppbarColorLight,
                                                    borderRadius: new BorderRadius.circular(30.0),
                                                  ),

                                                  child: Padding(
                                                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                                                      child: TextField(
                                                          onChanged: (value2) {
                                                            emergencyContactValue2 = value2;
                                                          },
                                                          controller: EmergencyContact2,

                                                          keyboardType:TextInputType.phone,
                                                          style: TextStyle(color: Colors.white),
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              labelText: 'Emergency Contact',
                                                              hintText: "Second Emergency Contact",
                                                              labelStyle: TextStyle(
                                                                  color: myFocusNode.hasFocus ? Colors.white : Colors.white
                                                              ),
                                                              hintStyle: TextStyle(
                                                                  color: myFocusNode.hasFocus ? Colors.white :  Colors.white
                                                              )
                                                          ))))),
                                          SizedBox(
                                            height: 10, // <-- Your height
                                            //  signInWithGoogle();
                                          ),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppbarColorLight,
                                                    borderRadius: new BorderRadius.circular(30.0),
                                                  ),
                                                  child: Padding(
                                                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                                                      child: TextField(
                                                          onChanged: (value3) {
                                                            emergencyContactValue3 = value3;
                                                          },
                                                          controller: EmergencyContact3,
                                                          style: TextStyle(color: Colors.white),
                                                          keyboardType:TextInputType.phone,
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              labelText: 'Emergency Contact',
                                                              hintText: "Third Emergency contact",
                                                              labelStyle: TextStyle(
                                                                  color: myFocusNode.hasFocus ? Colors.white : Colors.white
                                                              ),
                                                              hintStyle: TextStyle(
                                                                  color: myFocusNode.hasFocus ? Colors.white :  Colors.white
                                                              )
                                                          ))))),
                                          SizedBox(
                                            height: 10, // <-- Your height
                                            //  signInWithGoogle();
                                          ),
                                          Hero(
                                            tag: "login_btn",
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppbarColorLight,
                                                    elevation: 0,
                                                    minimumSize: const Size(250,40),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                    )
                                                ),
                                                onPressed: () async {
                                                 // print("Value"+emergencyContactValue1);
                                                  DataAdd(emergencyContactValue1,emergencyContactValue2,emergencyContactValue3);
                                                },
                                                child: Text('Add Emergency Contact')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 20, // <-- Your height
                                  //   //  signInWithGoogle();
                                  // ),
                                  // SizedBox(
                                  //   height: 40, // <-- Your height
                                  //   //  signInWithGoogle();
                                  // ),
                                ]
                            ))),
                  )));
  }

  Future<void> DataAdd(String emergencyContactValue1,String emergencyContactValue2, String emergencyContactValue3) async {
    // print(emergencyContactValue1);
    // print(emergencyContactValue2);
    // print(emergencyContactValue3);
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid =user!.uid;
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("User").child(uid.toString());
    Map<String, dynamic> students = {
      'EmergencyContact1':"+91"+emergencyContactValue1.toString(),
      'EmergencyContact2':"+91"+emergencyContactValue2.toString(),
      'EmergencyContact3':"+91"+emergencyContactValue3.toString(),
    };
    await dbRef.update(students).whenComplete(() {
     showToast("Emergency Contact Added");
     Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => const MapSample()),
     );
    });

  }
  Future<void> SetData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid =user!.uid;
    late DatabaseReference dbRef;
    dbRef = FirebaseDatabase.instance.ref().child('User').child(uid.toString());
    DataSnapshot snapshot = await dbRef.get();
    Map student = snapshot.value as Map;
    print(student['name']);
    if(student['EmergencyContact1'] != null) {
      EmergencyContact1.text = student['EmergencyContact1'];
    }
    if(student['EmergencyContact2'] != null ) {
      EmergencyContact2.text = student['EmergencyContact2'];
    }
    if(student['EmergencyContact3'] != null ) {
      EmergencyContact3.text = student['EmergencyContact3'];
    }
    }
  }
