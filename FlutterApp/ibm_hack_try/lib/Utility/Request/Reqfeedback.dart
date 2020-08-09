import 'package:flutter/material.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/QR/QRPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../utilitypage.dart';

class Reqfeedback extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: const Color(0xff3a54e3) ,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            upperHalf(context),
            SizedBox(height:40),
            Text(
              'Eric Brian Anil',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 26,
                color: Colors.white,
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
                fontSize: 19,
                color: Colors.white,
                letterSpacing: 1.843,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              height: MediaQuery.of(context).size.height/2,
              width: 317,
              decoration: BoxDecoration(color:Colors.white, borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.only(top:40,left:20,right: 20),
              margin: EdgeInsets.all(20),
              child: Column(
                children:<Widget>[ Text("Your Request has  been received. We will look into it as  soon as possible :) \n\n You will receive a copy of your request by mail. Have fun shopping",
                  style: TextStyle(color: Colors.pink,fontFamily: 'Montserrat',
                    fontSize: 15,
                    letterSpacing: 2.744,
                    fontWeight: FontWeight.w700,
                  ),textAlign: TextAlign.center, ),
                  SizedBox(height: 40,),
                  Image.asset('images/checkmark.png')
              ]),
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
      ],)),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(icon: Icon(Icons.arrow_back), color: Colors.blue[800], iconSize: 30.0, onPressed: null),
          SizedBox(width: 60.0),
          Image.asset(
          'images/logo_title.png', height: 65, width: 130,
          ),
          SizedBox(width: 60.0),
          IconButton(icon: Icon(Icons.exit_to_app), color: Colors.blue[800], iconSize: 30.0, onPressed: null)
        ],
      )
    );
  }
}
