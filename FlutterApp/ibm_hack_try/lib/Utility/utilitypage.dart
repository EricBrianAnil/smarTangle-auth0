import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/QR/QRPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UtilityPage extends StatefulWidget {
  @override
  _UtilityPageState createState() => _UtilityPageState();
}

class _UtilityPageState extends State<UtilityPage> {
  double screenHeight;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  CarouselSlider carouselSlider;
  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            upperHalf(context),
            name(context),
            option(context),
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

  Widget name(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 5 ) ,
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column( 
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child:Text(
            'Eric Brian Anil',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 28,
              color: const Color(0xff3a54e3),
              letterSpacing: 2.744,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),),
          SizedBox(height:10),
          Align(
            alignment: Alignment.topCenter,
            child:Text(
            'UTILITY LIST',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              color: const Color(0xff3a54e3),
              letterSpacing: 1.843,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),),
        ],
      ),
    );    
  }  

  Widget option(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 4 + 50) ,
      padding: EdgeInsets.only(left: 10 , right: 10),  
      child: Column(
        children: <Widget>[
        Container(
          width: 322.0, height: 79.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
            color: const Color(0xffdd377b),
            onPressed: (){},
            child:Text(
                'Material Availability',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 21,
                  color: const Color(0xffffffff),
                  letterSpacing: 2.0580000000000003,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,),
        ),
         decoration: BoxDecoration(boxShadow: [BoxShadow(color: const Color(0x52d53499),
           offset: Offset(0, 5),
           blurRadius: 10,)]), ),
        SizedBox(height: 10),
        Container(
          width: 322.0, height: 121.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
            color: const Color(0xffdd377b),
            onPressed: (){},
            padding: EdgeInsets.only( right:140, top:45.0),
            child: Text("Find Nearby\nStores",style: TextStyle(fontFamily: 'Montserrat',
              fontSize: 24,
              color: const Color(0xffffffff),
              letterSpacing: 2.3520000000000003,
              fontWeight: FontWeight.w700,), textAlign: TextAlign.left,),
          ),
            decoration: BoxDecoration(boxShadow: [BoxShadow(color: const Color(0x52d53499),
              offset: Offset(0, 5),
              blurRadius: 10,)
        ])),
        SizedBox(height: 10,),
        Row( mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
              width: 151.0, height: 144.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                color: const Color(0xffdd377b),
                onPressed: (){},
                padding: EdgeInsets.only( right:30.0, top:70.0),
                child: Text("Shopping\nCart",style: TextStyle(fontFamily: 'Montserrat',
                  fontSize: 20,
                  color: const Color(0xffffffff),
                  letterSpacing: 1.96,
                  fontWeight: FontWeight.w700,),),
              ),
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: const Color(0x52d53499),
                    offset: Offset(0, 5),
                    blurRadius: 10,)])),
              SizedBox(width: 10,),
              Container(
                width: 154.0, height: 144.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                  color: const Color(0xffdd377b),
                  onPressed: (){},
                  padding: EdgeInsets.only( right:30.0, top:70.0),
                  child: Text("Request\nMaterials",style: TextStyle( fontFamily: 'Montserrat',
                    fontSize: 20,
                    color: const Color(0xffffffff),
                    letterSpacing: 1.96,
                    fontWeight: FontWeight.w700,),),
                ),
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: const Color(0x52d53499),
                    offset: Offset(0, 5),
                    blurRadius: 10,)])),

            ],
          )
       ],
      ),
    );
  }
}