
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CodeScanner extends StatefulWidget {
  const CodeScanner({Key? key}) : super(key: key);

  @override
  _CodeScannerState createState() => _CodeScannerState();
}

class _CodeScannerState extends State<CodeScanner> {
  late String scanresult; //varaible for scan result text

  @override
  void initState() {
    scanresult = "none"; //innical value of scan result is "none"
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("QR or Bar code Scanner"),
          backgroundColor: Colors.redAccent
      ),
      body:Container(
          alignment: Alignment.topCenter, //inner widget alignment to center
          padding: EdgeInsets.all(20),
          child:Column(
            children:[
              Container(
                  child: Text("Scan Result: " + scanresult)
              ),
              Container(
                  margin: EdgeInsets.only(top:30),
                  // child: FlatButton( //button to start scanning
                  //     color: Colors.redAccent,
                  //     colorBrightness: Brightness.dark,
                  //     onPressed: () async {
                  //       scanresult = await scanner.scan();
                  //       //code to open camera and start scanning,
                  //       //the scan result is stored to "scanresult" varaible.
                  //       setState(() { //refresh UI to show the result on app
                  //       });
                  //     },
                      child: Text("Scan QR or Bar Code")
                  )
              // )
            ],
          )
      ),
    );
  }
}
