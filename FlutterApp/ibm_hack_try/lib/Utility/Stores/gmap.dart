import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  final Set<Marker> _markers = Set();
  
  bool _showMapStyle = false;

  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;

  final List<LatLng> _markerLocations = [
    LatLng(9.5283894, 76.8222612),
    LatLng(12.840641, 80.1512396),
    LatLng(8.5490531, 76.9363335),
    LatLng(8.5484899, 76.9385599),
  ];

  final List<List> _markerTitle = [
    ['smarTangle Kottayam','SmarTangle Subsidiary store in Kottayam, Kerala'],
    ['smarTangle Chennai','SmarTangle Subsidiary store in Chennai, Tamil Nadu'],
    ['smarTangle Trivandrum','SmarTangle Subsidiary store in Trivandrum, Kerala'],
    ['smarTangle Trivandrum','SmarTangle Subsidiary store in Trivandrum, Kerala'],
  ];

  @override
  void initState() {
    super.initState();
     _getLocationPermission();
    _setMarkerIcon();
   
  }
  
  void _getLocationPermission() async {
    var location = Location();
    try {
      location.requestPermission();
    } on Exception catch (_) {
      print('There was a problem allowing location access');
    }
  }

  void _setMarkerIcon() async {
    _markerIcon =
        await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'images/logobl.png');
  }

  void _toggleMapStyle() async {
    String style = await DefaultAssetBundle.of(context).loadString('images/map_style.json');

    if (_showMapStyle) {
      _mapController.setMapStyle(style);
    } else {
      _mapController.setMapStyle(null);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    setState(() {
      _initMarkers();
    });
  }
  void _initMarkers() async {
    //final List<Marker> markers = [];
    int x=0;
    for (LatLng markerLocation in _markerLocations) {
      _markers.add(
        Marker(
          markerId: MarkerId(x.toString()),
          position: markerLocation,
          icon: _markerIcon,
          infoWindow: InfoWindow(
            title: _markerTitle[x][0], 
            snippet: _markerTitle[x][1]            
          )
        )
      );
      x++;
    } 
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NEAREST STORE'), backgroundColor: Color(0xff3B5EE6) ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(9.0158521, 76.9097683),
              zoom: 12,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff3B5EE6),
        tooltip: 'Increment',
        child: Icon(Icons.map),
        onPressed: () {
          setState(() {
            _showMapStyle = !_showMapStyle;
          });

          _toggleMapStyle();
        },
      ),
    );
  }
} 

