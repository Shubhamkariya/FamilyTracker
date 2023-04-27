import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:untitled2/Google/GoogleMap.dart';
import 'package:untitled2/UserAccount/AlreadyHaveanaccount.dart';
import 'package:untitled2/UserAccount/Login.dart';

import '../Utils/Constants.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  String email = '', pass = '', name = '';
  late FirebaseMessaging messaging;
  @override
  Widget build(BuildContext context) {



    FocusNode myFocusNode = new FocusNode();
    FocusNode myFocusNodeName = new FocusNode();

    return Scaffold(
      backgroundColor: AppbarColor,
      body: SingleChildScrollView(
          child:Column(
          children:<Widget>[
                SizedBox(
                height: 150,
                child:Container(
                child: Center(
                child:AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                    'Do Register',
                    textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                    ScaleAnimatedText(
                    'For Chatting',
                    textStyle: TextStyle(fontSize: 32.0, fontFamily: 'Canterbury',color: Colors.white),
                    ),
                ],
           )),
        )),
          SingleChildScrollView(
              child:Card(
                color: Colors.white,
                    child: SizedBox(
                    width: 300,
                    height: 450,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                         child:Container(
                           margin: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                            style: TextStyle(color: Colors.white), //<-- SEE HERE

                                            onChanged: (value) {
                                              email = value;
                                            },
                                            focusNode: myFocusNode,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelText: 'Email',
                                                hintText: "Enter the Email",
                                                labelStyle: TextStyle(
                                                    color: myFocusNode.hasFocus ? Colors.white : Colors.white
                                                ),
                                                hintStyle: TextStyle(
                                                    color: myFocusNode.hasFocus ? Colors.white : Colors.white
                                                )
                                            ))))),
                            Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                  decoration: BoxDecoration(
                                        color: AppbarColorLight,
                                        borderRadius: new BorderRadius.circular(30.0),
                                      ),
                                    child: Padding(
                                       padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                                        child:  TextField(
                                            style: TextStyle(color: Colors.white), //<-- SEE HERE
                                            onChanged: (value) {
                                              name = value;
                                        },
                                            focusNode: myFocusNodeName,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelText: 'Name',
                                                hintText: "Enter the Name",
                                                labelStyle: TextStyle(
                                                    color: myFocusNodeName.hasFocus ? Colors.white : Colors.white
                                                ),
                                                hintStyle: TextStyle(
                                                    color: myFocusNodeName.hasFocus ? Colors.white : Colors.white
                                                )
                                            ))))),
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
                                            style: TextStyle(color: Colors.white), //<-- SEE HERE
                                            onChanged: (value) {
                                              pass = value;
                                            },
                                            obscureText: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelText: 'Password',
                                                hintText: "Enter the password",
                                                labelStyle: TextStyle(
                                                    color: myFocusNode.hasFocus ? Colors.white : Colors.white
                                                ),
                                                hintStyle: TextStyle(
                                                    color: myFocusNode.hasFocus ? Colors.white : Colors.white
                                                )
                                            ))))),
                                      Hero(
                                          tag: "login_btn",
                                          child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                          backgroundColor: AppbarColor,
                                          elevation: 0,
                                          minimumSize: const Size(250,40),
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          )
                                        ),
                                    onPressed: () async {
                                        uploadData(name,email,pass);
                                },
                                child: Text('Register'))),
                            SizedBox(
                              height: 20, // <-- Your height
                              //  signInWithGoogle();
                            ),
                            AlreadyHaveAnAccountCheck(
                              login: false,
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Login();
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 40, // <-- Your height
                              //  signInWithGoogle();
                            ),

                          ],
                  ),
                ),
                       ),
                     ]
                    )
                  )
              ))
        ]
      )));

  }
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


  void uploadData(String name, String email, String pass) async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();
    print(fcmToken);
    try {
      UserCredential userCredential = await FirebaseAuth
          .instance
          .createUserWithEmailAndPassword(
          email: email, password: pass);
      final User? user = auth.currentUser;
      final uid = user?.uid;

      // if (_image == null) return;
      //Import dart:core
      String uniqueFileName =
      DateTime.now().millisecondsSinceEpoch.toString();


      // Reference referenceRoot = FirebaseStorage.instance.ref();
      // Reference referenceDirImages =
      // referenceRoot.child('images');
      //
      // //Create a reference for the image to be stored
      // Reference referenceImageToUpload =
      // referenceDirImages.child(uniqueFileName);
      // await referenceImageToUpload.putFile(File(_image!.path));
      // imageUrl = await referenceImageToUpload.getDownloadURL();
      double longitude= 0.00;
      double latitude= 0.00;
      int value =0;
      print(randomAlphaNumeric(10)); // random sequence of 10 alpha numeric i.e. aRztC1y32B
      String random = randomAlphaNumeric(10);
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("User").child(uid.toString());
      Map<String, dynamic> students = {
        'name': name,
        'email':email,
        'userId':uid,
        'token':fcmToken,
        'Longitude':longitude,
        'Latitude':latitude,
        'PersonalFamilyId':random,
        'EmergencyContact1':"",
        'EmergencyContact2':"",
        'EmergencyContact3':""

        // 'ImageUrl':imageUrl
      };
      await dbRef.set(students);

      DatabaseReference ref = FirebaseDatabase.instance.ref().child("Family").child(random);
      DatabaseEvent event = await ref.once();
      print(event.snapshot.children.length);
      value = event.snapshot.children.length;


      DatabaseReference dbRef2 = FirebaseDatabase.instance.ref().child("Family").child(random);
      Map<String, dynamic> students2 = {
        'userId_$value':uid.toString(),
      };
      await dbRef2.set(students2);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MapSample();
          },
        ),
      );
      showToast('User Account created');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        showToast('The account already exists for that email.');
      }
      else{
        showToast(e.code);
      }
    } catch (e) {
      print(e);
    }
  }

}
