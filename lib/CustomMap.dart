import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kksa/colors.dart';

class CustomMap extends StatefulWidget {

  const CustomMap({
    Key key,
  }) : super(key: key);

  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {

  LatLng SelectedLocation;
  LatLng CurrentUserLocation;
  bool ErrorSelectedLocation = false;

  void initState() {
    // TODO: implement initState
    super.initState();

    getLocation();

  }

  // Variable for userlocation
  Position _UserLocation;

  // Location permission
  void getLocation() async {

    Position UserLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    _UserLocation = UserLocation;

    setState(() {
      CurrentUserLocation = LatLng(UserLocation.latitude,UserLocation.longitude);
    });

    // Delete old marker
    markers.clear();

    // print location in
    print(CurrentUserLocation);

    // Select new place with marker
    _onAddMarkerButtonPressed(CurrentUserLocation);

    // chnage position to new marker
    _goToNewMarker(CurrentUserLocation);

    setState(() {

      SelectedLocation = CurrentUserLocation;

    });

    print(UserLocation == null ? 'Unknown' : UserLocation.latitude.toString() + ', ' + UserLocation.longitude.toString());
  }

  // List for markers on the map
  final Set<Marker> markers = Set();

  // Controller for the map
  Completer<GoogleMapController> _controller = Completer();

  // Controller for the map
  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  // Type of the map
  MapType _currentMapType = MapType.normal;

  // Get location from the map, add marker and change position;
  _mapTapped(LatLng location) {

    // Delete old marker
    markers.clear();

    // print location in
    print(location);

    // Select new place with marker
    _onAddMarkerButtonPressed(location);

    // chnage position to new marker
    _goToNewMarker(location);

    setState(() {
      SelectedLocation = location;
    });

    Future.delayed(
        Duration(seconds: 2),
            (){
          Navigator.pop(context);
        }
    );

  }

  // Add marker in the map
  _onAddMarkerButtonPressed(LatLng location){
    setState(() {
      markers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            position: location,
//            infoWindow: InfoWindow(
//              title: ,
//              snippet: ,
//            )
            icon: BitmapDescriptor.defaultMarker,
          )
      );
    });

  }

  // Change position to new marker
  Future<void> _goToNewMarker(LatLng location) async{

    CameraPosition NewMarker = CameraPosition(
        target: location,
        zoom: 17.0
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(NewMarker));
  }

  // Add Floating button to the map
  Widget button(Function function, IconData icon , String HeroTag){
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: otherMessageBackground
      ),
      child: RawMaterialButton(
        shape: CircleBorder(),
        elevation: 0.0,
        child: Icon(icon, color: Colors.white,),
        onPressed: function,
      ),
    );
  }

  // change the type of map.
  _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  // Search for my location
  Future<void> _onMoveToMyLocation() async{

    CameraPosition MyLocation = CameraPosition(
        target: LatLng(_UserLocation == null ? 24.7249316 : _UserLocation.latitude, _UserLocation == null ? 47.1027223 : _UserLocation.longitude),
        zoom: 17.0
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(MyLocation));
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        GoogleMap(
          onTap: _mapTapped,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: CurrentUserLocation == null ? LatLng(24.7249316,47.1027223) : CurrentUserLocation,
            zoom: CurrentUserLocation == null ? 5 : 17.0,
          ),
          mapType: _currentMapType,
          markers: markers,
        ),


        //Floating button on the map
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                button(_onMapTypeButtonPressed, Icons.map, "btn1"),
                SizedBox(height: 10,),
                button(_onMoveToMyLocation, Icons.location_searching, "btn2"),
              ],
            ),
          ),
        ),

      ],
    );
  }
}
