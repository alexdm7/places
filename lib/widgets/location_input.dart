

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

import 'package:places/models/place.dart';
import 'package:places/screens/map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key,required this.onSelecteLocation});
  final void Function(PlaceLocation location)onSelecteLocation;
  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  String get locationImage{
    if(_pickedLocation==null){
      return '';
    }
    final lat=_pickedLocation!.latitude;
    final lng=_pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyBmp4UPrqAOf_4WP2-SeQLkyqEWQnBnEqg';
  }
  void _savePlace(double latitude,double longitude)async{
    final url=Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyBmp4UPrqAOf_4WP2-SeQLkyqEWQnBnEqg');
    final response=await http.get(url);
    final resData=json.decode(response.body);
    final address=resData['results'][0]['formatted_address'];
    setState(() {
      _pickedLocation=PlaceLocation(latitude: latitude, longitude: longitude, address: address);
      _isGittingLocationl = false;
    });

    widget.onSelecteLocation(_pickedLocation!);

  }
  var _isGittingLocationl = false;
  void _getCrrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGittingLocationl = true;

    });

    locationData = await location.getLocation();
    print(locationData.latitude);
    print(locationData.longitude);
    final lat=locationData.latitude;
    final lng=locationData.longitude;
    if(lat == null || lng == null){
      return;
    }
  _savePlace(lat, lng);
  }
  void _selecteOnMap()async{
   final pickedLocation=await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(builder: (ctx) => MapScreen(),)
    );
   if(pickedLocation==null){
     return;
   }
   _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget priveiwContent = Text(
      'no location',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if(_pickedLocation != null){
      priveiwContent=Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (_isGittingLocationl) {
      priveiwContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          height: 170,
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          )),
          child: priveiwContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCrrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('get crrunt location'),
            ),
            TextButton.icon(
              onPressed: _selecteOnMap,
              icon: Icon(Icons.map),
              label: Text('get  map'),
            ),
          ],
        )
      ],
    );
  }
}
