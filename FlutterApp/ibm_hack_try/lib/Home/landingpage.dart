import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ibm_hack_try/QR/QRPage.dart';
import 'package:ibm_hack_try/Utility/utilitypage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double screenHeight;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  CarouselSlider carouselSlider;
  int _current = 0;
  List imgList = [
    'images/offer_1.png',
    'images/offer_2.png',
    'images/offer_3.jpg',
    'images/offer_4.png',
  ];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,

      drawer: new Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: const Color(0xff3B5EE6),
            ),
            accountName: new Text(
              "USER",
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/user.jpg'),
            ),
            accountEmail: null,
          ),
          ListTile(
            title: Text('Welcome'),
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: Text('Change Password'),
          ),
          ListTile(
            leading: IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  
            }),
            title: Text('Log Out'),
          ),
        ],
      )),
    
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            upperHalf(context),
            search(context),
            offer(context),
            sales(context),
            Positioned(
              left: 10,
              top: 20,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => scaffoldKey.currentState.openDrawer(),
              ),
            ),
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
          color: Colors.blue),
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

  Widget search(BuildContext context) {
    return Column(
      children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: screenHeight / 5),
        padding: EdgeInsets.only(left: 5, right: 5),
        
        child: TextField(
          onChanged: (value) {},
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: "Search",
            hintText: "Search",
            suffixIcon: Icon(Icons.search, color: Colors.black,),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        ),
      ),
      ],
    ); 
  } 

  Widget offer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (screenHeight / 5) + 70),
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          carouselSlider = CarouselSlider(
            height: 130.0,
            initialPage: 0,
            enlargeCenterPage: true,
            autoPlay: true,
            reverse: false,
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(seconds: 2),
            autoPlayAnimationDuration: Duration(milliseconds: 2000),
            pauseAutoPlayOnTouch: Duration(seconds: 10),
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: imgList.map((img) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(color: Colors.green,),
                    child: Image.asset(
                      img,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(
            height: 1.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(imgList, (index, img) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? Colors.redAccent : Colors.green,
                  ),
                );
              }),
          ),
          SizedBox(
            height: 1.0,
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*OutlineButton(
                onPressed: goToPrevious,
                child: Text("<"),
                borderSide: BorderSide(width:1.0),
              ),
              OutlineButton(
                onPressed: goToNext,
                child: Text(">"),
              ),*/
              
            ]
          ),*/
        ],
      ),
    );
  }
 
 /* goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
 
  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }*/

  Widget sales(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: screenHeight / 2 + 80 ),
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
            child: Text(
        "Fruits", 
        style: TextStyle(
          fontSize: 24, 
          color: Color(0xff3B5EE6), 
          fontWeight: FontWeight.bold, fontFamily: 'Montserrat' )
      ),),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: <Widget>[
              Menu(title:"Apples", rate: 'Rs 60/kg'),
              Menu(title:"Oranges", rate: 'Rs 50/kg'),
              Menu(title:"Grapes", rate: 'Rs 70/kg'),
              Menu(title:"Bananas", rate: 'Rs 80/kg'),
          ]  
      ),
      
      ]
    ));
  }
}

class Menu extends StatelessWidget {
  Menu({this.title, this.rate});
  final String title;
  final String rate;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xff3B5EE6), style: BorderStyle.solid, width:1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height:50.0),
          Align(
            alignment: Alignment.center,
            child: Text(title, 
              style: TextStyle(
                fontSize: 20, 
                color: Colors.black, 
                fontWeight: FontWeight.bold, fontFamily: 'Montserrat' 
              )
            ), 
          ),
          SizedBox(height:40.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(rate, 
              style: TextStyle(
                fontSize: 14, 
                color: Color(0xff3B5EE6), 
                fontWeight: FontWeight.bold, fontFamily: 'Montserrat' 
              )
            ), 
          )
        ]
      )
    );
  }
}