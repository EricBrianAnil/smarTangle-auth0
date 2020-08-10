import 'package:flutter/material.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/QR/QRPage.dart';
import 'package:ibm_hack_try/Utility/utilitypage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'material_fetch.dart';


class Availability extends StatefulWidget {
  final String item;
  Availability({Key key, @required this.item}) : super(key: key);

  @override
  _AvailabilityState createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  double screenHeight;
  Future<List<dynamic>> data;

  @override
  void initState() {
    super.initState();
    data = MaterialFetch.searchDjangoApi(widget.item);
  }
  
  info(int store, List data) {
    print(data);
    for (int i =0; i< data.length; i++){
      if(data[i]['storeId']=='S'+store.toString() && data[i]['unitsAvailable']>0){
        print(data[i]['unitsAvailable']);
        return('AVAILABLE       ' + data[i]['unitsAvailable'].toString());
      }
      else if(int.parse(data[i]['storeId'][1]) >= store) {    
        print("Unavailable");
        return('OUT OF STOCK       ' + data[i]['unitsAvailable'].toString());    
      }
      else if (int.parse(data[i]['storeId'][1])+1==4 && (i== data.length -1 || data[i+1]['storeId'] != 'S' + store.toString() ) ){
        print("Unavailable");
        return('OUT OF STOCK       ' + data[i]['unitsAvailable'].toString());    
      }
    } 
  }
  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            upperHalf(context),
            pageitem(),
            itemInfo(context),
            storeInfo(context),
            itemAvailability(context)
            
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
        SizedBox(width:100),
        IconButton(
          icon: Icon(Icons.card_travel), 
          onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => HomePage()));},
          color: Colors.blue),
        SizedBox(width:100),
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
          IconButton(
            icon: Icon(Icons.arrow_back), 
            color: Colors.white, 
            iconSize: 30.0, 
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePage()));
            }
          ),
          SizedBox(width: 60.0),
          Image.asset(
            'images/logo_title.png',
            height: 65,
            width: 130,
          ),
        ],
      )
    );
  }

  Widget pageitem() {
    return Container(
      margin: EdgeInsets.only(top: 110),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Material Availability",
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
          )
        ],
      ),
    );
  }

  Widget itemInfo(context){
    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, top: (screenHeight / 5) + 40),
      color: Colors.orange[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 10.0,
      child: Container(
        height: 130.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              'images/'+ widget.item +'.png',
              height: 120,
              width: 120,
            ),
            Text(
              widget.item, 
              style: TextStyle(fontSize: 24.0, color: Colors.white, fontFamily: 'Monsteratt'),
            )
       ],),
        

      ),
    );
  }

  Widget storeInfo(context) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 2 + 20 ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          "Store Id",    
          style: TextStyle(
            fontFamily: "Montserrat",fontWeight: FontWeight.w700,
            fontSize: 18,
            color:Color(0xff3a54e4),  
          ),
        ),
        Text(
          "Availability\nStatus",    
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Montserrat",fontWeight: FontWeight.w700,
            fontSize: 16,
            color:Color(0xff3a54e4),  
          ),
        ),
        Text(
          "Units\nAvailable",    
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Montserrat",fontWeight: FontWeight.w700,
            fontSize: 16,
            color:Color(0xff3a54e4),  
          ),
        )
     
    ],));
  }

  

  Widget itemAvailability(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 2 + 80 ),
      padding: EdgeInsets.only(left: 8),
      child: FutureBuilder(
      future: data,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          // Data fetched successfully, display your data here
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('S1\t', style: TextStyle(color: Colors.black, fontFamily: 'Monsteratt', fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(info(1, snapshot.data), style: TextStyle(color: Colors.black, fontFamily: 'Monsteratt', fontSize: 18, fontWeight: FontWeight.bold)),
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('S2\t', style: TextStyle(color: Colors.black, fontFamily: 'Monsteratt', fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(info(2, snapshot.data), style: TextStyle(color: Colors.black, fontFamily: 'Monsteratt', fontSize: 18, fontWeight: FontWeight.bold)),
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('S3\t', style: TextStyle(color: Colors.black, fontFamily: 'Monsteratt', fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(info(3, snapshot.data), style: TextStyle(color: Colors.black, fontFamily: 'Monsteratt', fontSize: 18, fontWeight: FontWeight.bold)),
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('S4\t', style: TextStyle(color: Colors.black, fontFamily: 'Monsteratt', fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(info(4, snapshot.data), style: TextStyle(color: Colors.black, fontFamily: 'Monsteratt', fontSize: 18, fontWeight: FontWeight.bold)),
              ],),
          ],
        );
        } else if (snapshot.hasError) {
          // If something went wrong
          return Text('Something went wrong...');
        }

        // While fetching, show a loading spinner.
        return CircularProgressIndicator();
      })
    );
  }
}