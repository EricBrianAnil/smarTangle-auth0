import 'package:flutter/material.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/QR/QRScan.dart';
import 'package:ibm_hack_try/Utility/utilitypage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;


class QRPage extends StatefulWidget {
  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  double screenHeight;
  String scanResult = '';

  //function that launches the scanner
  Future scanQRCode() async {
    String cameraScanResult = await scanner.scan();
    setState(() {
      scanResult = cameraScanResult;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScanResult(scanResult: cameraScanResult)));
    
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            scan(context),
            upperHalf(context),
            pageTitle(),
          ],
        ),
      ),
      
      bottomNavigationBar: Row(children: <Widget>[
        IconButton(
          icon: Icon(MdiIcons.qrcodeScan),  
          onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => QRPage()));},
              color: Colors.blue),
        SizedBox(width:50),
        IconButton(
          icon: Icon(Icons.card_travel), 
          onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => HomePage()));},
              color: Colors.black),
        SizedBox(width:50),
        IconButton(icon: Icon(Icons.person), onPressed: null, color: Colors.black),
        SizedBox(width:50),
        IconButton(
          icon: Icon(Icons.settings), 
          onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => UtilityPage()));},
          color: Colors.black),
      ],),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 4,
      color: Color(0xff3B5EE6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
          'images/logo_title.png',
          height: 65,
          width: 130,
          ),
        ],
      )
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 110),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "QR READER",
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
          )
        ],
      ),
    );
  }

  Widget scan(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight/4 + 30),
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: screenHeight/2),
          Align(
            alignment: Alignment.topCenter,
            child:RaisedButton(
            onPressed: scanQRCode,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            color: Colors.black,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Scan smarTangle QR ", 
                    style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Montserrat'),),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Image.asset('images/qr.png', height: 20.0, width: 20.0)
                ),
              ]
            )
          ),
        ),
       ],
      )
    );
  }

  
}

