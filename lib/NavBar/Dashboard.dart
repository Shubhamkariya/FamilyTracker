import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:random_string/random_string.dart';
import 'package:untitled2/Google/GoogleMapPerson.dart';
import 'package:untitled2/Utils/Constants.dart';

import '../Utils/Toast.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.familyId}) : super(key: key);
  final String familyId;


  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DatabaseReference dbReference;
  final Set<String> UserID = new Set();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //tokenUpdate();
  }

  @override
  Query dbRef = FirebaseDatabase.instance.ref().child('User');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('User');
  Future<void> gettingValue(String FamilyId) async {

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
      }
    });
  }
  listItem({required Map student}) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    if (student.isNotEmpty) {
      String FamilyCode = widget.familyId;
      if (student['userId'] != uid){
        if (FamilyCode == student['PersonalFamilyId']) {
          return
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: AppbarColor,
                  child: ListTile(
                    title: Text(student['name'],
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                        trailing: IconButton(
                      icon: Icon(Icons.delete,color: Colors.white), onPressed: () async {
                            DeleteButton(student['userId'].toString(),FamilyCode,uid.toString());
                        }), // for Left
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => GoogleMapPerson(
                              Latitude:student['Latitude'].toString(),
                              Longitude:student['Longitude'].toString(),
                              ClickName:student['name'].toString())
                              )
                          );
                       }),
                )
              ],
            );
        }
        else {
         // showToast("No User present");
          return SizedBox(
            height: 0.0,
          );

        }
      }
      else {
        showToast("No User present");
        return SizedBox(
          height: 0.0,
        );
      }
    }
    else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    String familyId= widget.familyId;
    final List<String> items =
    new List<String>.generate(10, (i) => "item  ${i + 1}");
    return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: BackButton(),
              backgroundColor: AppbarColor,
              title: const Text('User data list'),
              automaticallyImplyLeading: false,
              centerTitle: true,
              // actions: [
              //   PopupMenuButton(
              //     // add icon, by default "3 dot" icon
              //     // icon: Icon(Icons.book)
              //       itemBuilder: (context){
              //         return [
              //           PopupMenuItem<int>(
              //             value: 0,
              //             child: Row(
              //               children: [
              //                 Icon(Icons.account_circle,color: Colors.black),
              //                 Text('Account'),
              //               ],
              //             ),
              //           ),
              //
              //           PopupMenuItem<int>(
              //               value: 1,
              //               child: Row(
              //                 children: [
              //                   Icon(Icons.settings,color: Colors.black),
              //                   Text('Setting'),
              //                 ],
              //               )
              //           ),
              //
              //           PopupMenuItem<int>(
              //               value: 2,
              //               child: Row(
              //                 children: [
              //                   Icon(Icons.logout,color: Colors.black),
              //                   Text('Logout'),
              //                 ],
              //               )
              //
              //           ),
              //         ];
              //       },
              //       onSelected:(value) async {
              //         if(value == 0){
              //           print("My account menu is selected.");
              //           final FirebaseAuth auth = FirebaseAuth.instance;
              //           final User? user = auth.currentUser;
              //           final uid = user?.uid;
              //           // Navigator.pushReplacement(
              //           //     context,
              //           //     MaterialPageRoute(
              //           //         builder: (BuildContext context) => UpdateAccountRecord())
              //           // );
              //         }else if(value == 1){
              //           print("Settings menu is selected.");
              //         }else if(value == 2){
              //           await FirebaseAuth.instance.signOut();
              //
              //           // Navigator.pushReplacement(
              //           //     context,
              //           //     MaterialPageRoute(
              //           //         builder: (BuildContext context) => CheckAuth())
              //           // );
              //         }
              //       }
              //   ),
              // ],

            ),
            body:Stack(
                children: [
                  SingleChildScrollView(
                      child:Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height,
                              child: FirebaseAnimatedList(
                                query: dbRef,
                                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                                  Map student = snapshot.value as Map;
                                  student['key'] = snapshot.key;
                                  return listItem(student: student);
                                },
                              ),

                            ),]
                      )),
                ]
            )

    );

  }

  Future<void> DeleteButton(String UserId,String FamilyCode, String uid) async {
    print(UserId);
    Query ListNodeValue = FirebaseDatabase.instance.ref()
        .child('Family')
        .child(FamilyCode);
    int value = 0;
    DatabaseEvent event = await ListNodeValue.once();
    value = event.snapshot.children.length;
    ListNodeValue.once().then((DatabaseEvent snapshot) async {
      print("Length" + event.snapshot.children.length
          .toString());
      for (var val in event.snapshot.children) {
        if (val.value.toString() == UserId) {

          FirebaseDatabase.instance.ref()
              .child('Family')
              .child(FamilyCode)
              .child(val.key.toString())
              .remove().then((value) {
            showToast("User has been removed from family");
          });
          String random = randomAlphaNumeric(10);
          DatabaseReference dbRef2 = FirebaseDatabase.instance
              .ref().child("User").child(
              val.value.toString());
          Map<String, dynamic> students2 = {
            'PersonalFamilyId': random
          };
          await dbRef2.update(students2);
          int valueInt;
          DatabaseReference ref = FirebaseDatabase.instance
              .ref().child("Family").child(random);
          DatabaseEvent event = await ref.once();
          print(event.snapshot.children.length);
          valueInt = event.snapshot.children.length;
          DatabaseReference dbRef1 = FirebaseDatabase.instance
              .ref().child("Family").child(random);
          Map<String, dynamic> students1 = {
            'userId_$valueInt': uid.toString(),
          };
          await dbRef1.update(students1);
        }
      }
    });
  }
}


