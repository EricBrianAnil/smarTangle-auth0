import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/QR/QRPage.dart';
import 'package:ibm_hack_try/Utility/utilitypage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ScanResult extends StatefulWidget {
  final scanResult;
  ScanResult({Key key, @required this.scanResult}) : super(key: key);

  @override
  _ScanResultState createState() => _ScanResultState();
}


class _ScanResultState extends State<ScanResult> {
  
  double screenHeight;
  

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff3B5EE6),    
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            upperHalf(context),
            Padding(
                padding: const EdgeInsets.all(40.0),
                child: values(context),
              ),
            Padding(
                padding: const EdgeInsets.all(95.0),
                child: item(context),
              ),
            
          ],
        ),
      ),
      
      bottomNavigationBar: Container(
        color: Colors.white,
      child: Row(children: <Widget>[
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
    ));
  }

  Widget values(BuildContext context) {
    return Container(
      
      color: Colors.white,
      margin: EdgeInsets.only(top: screenHeight / 3 - 50),
      padding: EdgeInsets.all(15),
      child: Column(children: <Widget>[
        
        SizedBox(height: 10),
        StreamBuilder(
          stream: Firestore.instance.collection('RawMaterialBatch').document(widget.scanResult).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            var userDocument = snapshot.data;
            //return new Text("FAT\n"+ userDocument["fat"].toString());
            return Column(children: <Widget>[
              SizedBox(height: 30),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 2.0, color: Colors.black),
                      right: BorderSide(width: 2.0, color: Colors.black),
                      top: BorderSide(width: 2.0, color: Colors.black),
                      bottom: BorderSide(width: 2.0, color: Colors.black),
                    ),
                    borderRadius: BorderRadius.all( Radius.circular(10.0),),
                  ),
                  child: Text(
                    "   Quality Score - " + userDocument['quality_score'].toString() + "   ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color:Color(0xff000000), 
                    ),
                  ),
                ),
              ),
              SizedBox(height:20),
              Text(
                "Nutritional Information",    
                style: TextStyle(
                  fontFamily: "Product Sans", fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color:Color(0xff000000),  
                ),
              ),
              SizedBox(height: 10),
              Row(children: <Widget>[
                Column(children: <Widget>[
                  Text(
                    "Calories",  
                    style: TextStyle(
                      fontFamily: "Product Sans",
                      fontSize: 16,
                      color:Color(0xff616f8d),  
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    userDocument["calories"].toString(),
                    style: TextStyle(
                      fontFamily: "Product Sans", fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color:Color(0xff000000),  
                    ),
                  ), 
                ],),
                SizedBox(width: 60.0),
                Column(children: <Widget>[
                  Text(
                    "Fat",  
                    style: TextStyle(
                      fontFamily: "Product Sans",
                      fontSize: 16,
                      color:Color(0xff616f8d),  
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    userDocument["fat"].toString(),
                    style: TextStyle(
                      fontFamily: "Product Sans", fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color:Color(0xff000000),  
                    ),
                  ), 
                ],),
                SizedBox(width: 20.0),
              ],),
              
              SizedBox(height: 20),
              Row(children: <Widget>[
                Column(children: <Widget>[
                  Text(
                    "Proteins",  
                    style: TextStyle(
                      fontFamily: "Product Sans",
                      fontSize: 16,
                      color:Color(0xff616f8d),  
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    userDocument["proteins"].toString(),
                    style: TextStyle(
                      fontFamily: "Product Sans", fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color:Color(0xff000000),  
                    ),
                  ), 
                ],),
                SizedBox(width: 60.0),
                Column(children: <Widget>[
                  Text(
                    "Sodium",  
                    style: TextStyle(
                      fontFamily: "Product Sans",
                      fontSize: 16,
                      color:Color(0xff616f8d),  
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    userDocument["sodium"].toString(),
                    style: TextStyle(
                      fontFamily: "Product Sans", fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color:Color(0xff000000),  
                    ),
                  ), 
                ],),
                SizedBox(width: 20.0),
              ],),SizedBox(height: 40),
            ],);
            
          }
        )
      ])
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 5,
      color: Color(0xff3B5EE6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
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

  Widget item(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Color(0xffDD4040),
        borderRadius: BorderRadius.all( Radius.circular(10.0),),
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        )
      ),
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: screenHeight / 4 - 120),
      child: StreamBuilder(
      stream: Firestore.instance.collection('RawMaterialBatch').document(widget.scanResult).snapshots(),
      builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Text("Loading");
      }
      var userDocument = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              userDocument["raw_material_id"],    
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 18,
                color:Color(0xffffffff), 
                shadows:[
                  Shadow(
                    offset: Offset(0.00,3.00),
                    color: Color(0xff000000).withOpacity(0.16),
                    blurRadius: 6,
                  ),
                ], 
              ),
            ),
            SizedBox(height:3),
            Image.asset(
              'images/'+ userDocument["raw_material_id"]+'.png',
              height: 80,
              width: 80,
            ),       
        ],);
      }
            
    )
   );         
    
  }
  
}

