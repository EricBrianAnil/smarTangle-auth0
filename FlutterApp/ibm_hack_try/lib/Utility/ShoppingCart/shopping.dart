import 'package:flutter/material.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/QR/QRPage.dart';
import 'package:ibm_hack_try/Utility/utilitypage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'models/items.dart';
import 'widgets/new_item.dart';
import 'widgets/ulist.dart';

class Shopping extends StatefulWidget {
 
  @override
  _ShoppingState createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  double screenHeight;
  final List<Item> _userItems = [
  ]; 
 
  void _addNewItem(String itTitle, String itQuantity){
    final newIt = Item(
      title: itTitle, 
      quantity: itQuantity, 
      id: DateTime.now().toString(),
      );

      setState(() {
        _userItems.add(newIt);

      });
  }

  void _startAddNewItem(BuildContext cit){
    showModalBottomSheet(context: cit, builder: (_) {
      return GestureDetector(
        onTap: () {},
        child: NewItem(_addNewItem),
        behavior: HitTestBehavior.opaque,

        );
    },);
  }

  @override
    Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            upperHalf(context),
            name(context),
            list(context),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: const Color(0xffdd377b),
          onPressed: () => _startAddNewItem(context),
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
            'Shopping Cart',
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

  Widget list (BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 4 + 50) ,
      padding: EdgeInsets.only(left: 10 , right: 10),  
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height:10),
          ItemList(_userItems),

        ],
      ),
    );
  }
}