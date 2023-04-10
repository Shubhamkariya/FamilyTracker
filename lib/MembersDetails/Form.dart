import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/MembersDetails/CodeScanner.dart';
import 'package:untitled2/UserAccount/AlreadyHaveanaccount.dart';

import '../Utils/Constants.dart';



class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController EmergencyContact1 = TextEditingController();
  TextEditingController EmergencyContact2 = TextEditingController();
  TextEditingController EmergencyContact3 = TextEditingController();

  String istapped = '';
  String emergencyContactValue1 = '', emergencyContactValue2 = '', emergencyContactValue3='';

  @override
  Widget build(BuildContext context) {
    String emergencyContactValue1 = '', emergencyContactValue2 = '', emergencyContactValue3='';
    double heightFlutter = MediaQuery.of(context).size.height;
    double widthFlutter = MediaQuery.of(context).size.width;


    FocusNode myFocusNode = new FocusNode();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:Colors.blue,
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Add Members"),

        ),
        body: SingleChildScrollView(
                child:Center(
                    child: Card(
                        color: Colors.blue,
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
                                                    color: Colors.indigo,
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
                                                                  color: myFocusNode.hasFocus ? Colors.white : Colors.white60
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
                                                    color: Colors.indigo,
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
                                                                  color: myFocusNode.hasFocus ? Colors.white : Colors.white60
                                                              ),
                                                              hintStyle: TextStyle(
                                                                  color: myFocusNode.hasFocus ? Colors.blue :  Colors.white
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
                                                    color: Colors.indigo,
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
                                                                  color: myFocusNode.hasFocus ? Colors.white : Colors.white60
                                                              ),
                                                              hintStyle: TextStyle(
                                                                  color: myFocusNode.hasFocus ? Colors.blue :  Colors.white
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
                                                    backgroundColor: Colors.indigo,
                                                    elevation: 0,
                                                    minimumSize: const Size(250,40),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                    )
                                                ),
                                                onPressed: () async {
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

  Future<void> DataAdd(String emergencyContactValue1, String emergencyContactValue2,String emergencyContactValue3) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid =user!.uid;
    print(emergencyContactValue1);
    print(emergencyContactValue2);
    print(emergencyContactValue3);
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("User").child(uid.toString());
    Map<String, dynamic> students = {
      'EmergencyContact1': emergencyContactValue1,
      'EmergencyContact2':emergencyContactValue2,
      'EmergencyContact3':emergencyContactValue3,

    };
    await dbRef.update(students);

  }

}
