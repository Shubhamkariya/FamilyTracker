import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/GoogleMap.dart';
import 'package:untitled2/LocationPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled2/UserAccount/Login.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Location Demo',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}