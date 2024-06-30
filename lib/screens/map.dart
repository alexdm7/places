import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/models/place.dart';

class MapScreen extends StatefulWidget{
  const MapScreen({super.key,
  this.location=const PlaceLocation(latitude: 23.6134868, longitude: 58.5414574, address: ''),
  this.isSelcted=true});
  final PlaceLocation location;
  final bool isSelcted;
  @override
  State<MapScreen> createState() {
     return _MapScreenState();
  }
}
class _MapScreenState extends State<MapScreen>{
  LatLng? _pickedLoction;
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.isSelcted?'pick location':'yor location'),
      actions: [
        if(widget.isSelcted)
          IconButton(onPressed: (){
            Navigator.of(context).pop(_pickedLoction);
          }, icon: Icon(Icons.save)),
      ],

    ),
    body: GoogleMap(
      onTap:!widget.isSelcted  ? null: (postion){
      setState(() {
        _pickedLoction=postion;
      });

      },
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.location.latitude, widget.location.longitude),
        zoom: 13,
      ),
      markers:(_pickedLoction == null&& widget.isSelcted) ? {} : {
        Marker(
            markerId: MarkerId('m1'),
        position:_pickedLoction ?? LatLng(
            widget.location.latitude,
            widget.location.longitude),
        ),


      },

    ),

  );
  }
}