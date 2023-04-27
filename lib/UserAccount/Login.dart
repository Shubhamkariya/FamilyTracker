
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/Google/GoogleMap.dart';
import 'package:untitled2/UserAccount/AlreadyHaveanaccount.dart';
import 'package:untitled2/UserAccount/register.dart';
import 'package:untitled2/Utils/Toast.dart';

import 'dart:convert';

import '../Utils/Constants.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserCheck();
    handleLocationPermission();
    camera();
    smsPermission();
  }
  @override
  Widget build(BuildContext context) {
    String email = '', pass = '';
    FocusNode myFocusNode = new FocusNode();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:AppbarColor,
        body: SingleChildScrollView(
            child:Column(
            children:<Widget>[
            SizedBox(
            height: 200,
             child:Container(
             child: Center(
                 child:AnimatedTextKit(
               animatedTexts: [
                 FadeAnimatedText(
                   'Do Talking',
                   textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold,color: Colors.white),
                 ),
                 ScaleAnimatedText(
                   'Then Scale',
                   textStyle: TextStyle(fontSize: 32.0, fontFamily: 'Canterbury',color: Colors.white),
                 ),
               ],
             )),
            )),
            Center(
            child: Card(
              color: Colors.white,
              child: SizedBox(
                  width: 300,
                  height: 350,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                                    ),
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
                                SizedBox(
                                  height: 10, // <-- Your height
                                  //  signInWithGoogle();
                                ),
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

                                      try {
                                         await FirebaseAuth
                                            .instance
                                            .signInWithEmailAndPassword(
                                            email: email, password: pass);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const MapSample()),
                                          );
                                         // final FirebaseAuth auth = FirebaseAuth.instance;
                                         // await Firebase.initializeApp();
                                         // messaging = FirebaseMessaging.instance;
                                         // final fcmToken = await messaging.getToken();
                                         // print(fcmToken);
                                         // final FirebaseAuth auth1 = FirebaseAuth.instance;
                                         // final User? user = auth1.currentUser;
                                         // final uid = user?.uid;
                                         // DatabaseReference dbReference = FirebaseDatabase.instance.ref()
                                         //     .child('User')
                                         //     .child(uid.toString());
                                         // dbReference.update({
                                         //   "token": fcmToken
                                         // });
                                         showToast('Login Successfull');
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'user-not-found') {
                                          print('No user found for that email.');
                                          showToast('No user found for that email.');

                                        } else if (e.code == 'wrong-password') {
                                          print('Wrong password provided for that user.');
                                          showToast('Wrong password provided for that user.');
                                        }
                                        else{
                                          print("error"+e.code);
                                          showToast('No User found');
                                        }

                                      }
                                    },
                                    child: Text('Login')),
                                )
                              ],
                            ),
                          ),
                        ),
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
                                  return MyRegister();
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(
                            height: 40, // <-- Your height
                          //  signInWithGoogle();
                           ),

            ]
           ))),
        )])));
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
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void UserCheck() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapSample()),
        );
      }
    });

    // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => MapSample()),
      // );

  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

}
