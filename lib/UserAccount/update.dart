import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/Google/GoogleMap.dart';

class UpdateAccountRecord extends StatefulWidget {

  const UpdateAccountRecord({Key? key}) : super(key: key);



  @override
  State<UpdateAccountRecord> createState() => _UpdateAccountRecordState();
}

class _UpdateAccountRecordState extends State<UpdateAccountRecord> {

  final  userNameController = TextEditingController();
  final  userEmailController= TextEditingController();
  final  userUserIdController =TextEditingController();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    dbRef = FirebaseDatabase.instance.ref().child('User').child(uid.toString());
    getStudentData();
  }

  void getStudentData() async {
    DataSnapshot snapshot = await dbRef.get();

    Map student = snapshot.value as Map;

    print(student['name']);
    userNameController.text = student['name'];
    userEmailController.text = student['email'];
    userUserIdController.text = student['userId'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Updating record'),
        automaticallyImplyLeading: true,
        centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement( context,
                  MaterialPageRoute(
                  builder: (BuildContext context) => MapSample())
              );
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
      ),
      body:  Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Updating data in Firebase Realtime Database',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: userNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter Your Name',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: userEmailController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter Your Email',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: userUserIdController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Salary',
                  hintText: 'Enter Your Salary',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {

                  Map<String, String> students = {
                    'name': userNameController.text,
                    'age': userEmailController.text,
                    'salary': userUserIdController.text
                  };

                  dbRef.update(students)
                      .then((value) => {
                    Navigator.pop(context)
                  });

                },
                child: const Text('Update Data'),
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}