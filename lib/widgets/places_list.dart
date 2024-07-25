import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/screens/place_detail.dart';
import 'package:flutter/material.dart';

import 'package:places/models/place.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
//create database
Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,lng REAL,address TEXT)');
    },
    version: 1,
  );
  return db;
}

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  ConsumerState<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends ConsumerState<PlacesList> {
  //delete 1 row from sqllite method
  Future<void> _removeItem(Place place) async {
    final db = await _getDatabase();
    await db.delete('user_places', where: 'id = ?', whereArgs: [place.id]);

    setState(() {
      widget.places.remove(place);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.places.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(widget.places[index].id),
        onDismissed: (direction) {
          _removeItem(widget.places[index]);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.places[index].title} deleted successfully')),
          );
        },
        background: Container(color: Colors.black38),
        child: ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(widget.places[index].image),
          ),
          title: Text(
            widget.places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            widget.places[index].location.address,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlaceDetailScreen(place: widget.places[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: PlacesList(places: [])));
