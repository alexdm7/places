import 'package:places/screens/place_detail.dart';
import 'package:flutter/material.dart';

import 'package:places/models/place.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.places.length,
      itemBuilder: (ctx, index) => ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(widget.places[index].image),
        ),
        title: Text(
          widget.places[index].title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        subtitle: Text(widget.places[index].location.address,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PlaceDetailScreen(place: widget.places[index]),
            ),
          );
        },
        
      ),
    );
  }
}
