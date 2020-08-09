import 'package:flutter/material.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/QR/QRPage.dart';
import 'package:ibm_hack_try/Utility/utilitypage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './Reqfeedback.dart';

class Requests extends StatefulWidget{
  @override
  _RequestsState createState() => _RequestsState();

}

final itemController = TextEditingController();
final locationController = TextEditingController();
var existingc = false;
var newc = false;


class _RequestsState extends State<Requests> {
  double screenHeight;

  @override

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold (
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            upperHalf(context),
            Align(
              alignment: Alignment.center,
              child: Column(children: <Widget>[
                pageTitle(context),
                Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0),
                  child: request(context),
                )
              ],),
            )
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
              color: Colors.black),
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
          color: Colors.blue),
      ],),

    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(icon: Icon(Icons.arrow_back), color: Colors.blue[800], iconSize: 30.0, onPressed: null),
          SizedBox(width: 60.0),
          Image.asset(
          'images/logo_blue.png', height: 65, width: 130,
          ),
          SizedBox(width: 60.0),
          IconButton(icon: Icon(Icons.exit_to_app), color: Colors.blue[800], iconSize: 30.0, onPressed: null)
        ],
      )
    );
  }

  Widget pageTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 5 ) ,
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Eric Brian Anil',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 28,
              color: const Color(0xff3a54e3),
              letterSpacing: 2.744,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height:10),
          Text(
            'Material Request',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              color: const Color(0xff3a54e3),
              letterSpacing: 1.843,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );    
  }

  Widget request(BuildContext context){
    return Container(
      height: screenHeight/2 + 30,
      decoration: BoxDecoration(color:Colors.pink, borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.only(left: 10 , right: 10),
      child: Expanded(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10),
          Text(
            'Item ID / Name',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              color: const Color(0xffffffff),
              letterSpacing: 2.0580000000000003,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left),
          SizedBox(height: 10),
          TextField(
            controller: itemController,
            style: TextStyle( color: Colors.white,fontFamily: 'Montserrat',
              fontSize: 15,fontWeight: FontWeight.w700, ),
            decoration: InputDecoration(
              fillColor: const Color(0xffe372a0),
              filled: true,
              contentPadding: EdgeInsets.all(10),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: const BorderSide(color: Colors.transparent ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Item Store / Location',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              color: const Color(0xffffffff),
              letterSpacing: 2.0580000000000003,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left),
          SizedBox(height: 10),
          TextField(
            controller: locationController,
            style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',
              fontSize: 15,fontWeight: FontWeight.w700, ),
            decoration: InputDecoration(
              fillColor: const Color(0xffe372a0),
              filled: true,
              contentPadding: EdgeInsets.all(10),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: const BorderSide(color: Colors.transparent ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
          SizedBox(height: 40),
          Container(
            //margin: EdgeInsets.only(left: 10,right:10),
            padding: EdgeInsets.only(left: 40 , right: 40),
            width: 259.0, height: 51.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(31.0),),
              color: Colors.white,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Reqfeedback()),);
              },
              child: Text("Request",style: TextStyle( fontFamily: 'Montserrat',
              fontSize: 15,
              color: Colors.pink,
              letterSpacing: 1.96,
              fontWeight: FontWeight.w700,),),
            ),
            decoration: BoxDecoration(boxShadow: [BoxShadow(color: const Color(0x52d53499),
              offset: Offset(0, 5),
              blurRadius: 20,)])
          ),
          SizedBox(height: 20)
        ],
      ),
    ));
  }
}
