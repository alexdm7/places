import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:places/models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:places/widgets/image_input.dart';
import 'package:places/providers/user_places.dart';
import 'package:places/widgets/location_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selctedImage;
  PlaceLocation? _selecteLocation;

  void _savePlace() {
    final enteredTitle = _titleController.text;


    if (enteredTitle.isEmpty || _selctedImage == null|| _selecteLocation==null) {
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, _selctedImage!,_selecteLocation!);
   //  final url=Uri.https('places-b02a0-default-rtdb.firebaseio.com','places_list.json');
   //  http.post(url,headers: {
   //    'Content-Type':'application/json'
   //  },body: json.encode({
   //    'title':enteredTitle,
   // //  'image':_selctedImage,
   //    'address':_selecteLocation?.address,
   //    'longitude':_selecteLocation?.longitude,
   //    'latitude':_selecteLocation?.latitude,
   //  }));

    Navigator.of(context).pop();

  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 10),
            ImageInput(
              onPickImage: (image) {
                _selctedImage = image;
              },
            ),
            const SizedBox(height: 10),
            LocationInput(
              onSelecteLocation:(location){
                _selecteLocation=location;
              },),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
