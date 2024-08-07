
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:io';
import 'package:sqflite/sqflite.dart'as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:places/models/place.dart';

//create Database method
Future<Database> _getDatabase() async{
  var tableName='user_places';
  final dbPath=await sql.getDatabasesPath();
  final db= await sql.openDatabase(path.join(dbPath,'places.db'),onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE $tableName(id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,lng REAL,address TEXT)');
  },
    version: 1,
  );
  return db;

}
class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);
//create loadedPlaces method
Future <void> loadedPlaces()async{
  final db=await _getDatabase();
 final data=await db.query('user_places');
 final places=  data.map((row) =>
  Place(
    id: row['id']as String,
      title: row['title']as String,
      image: File(row['image']as String),
      location: PlaceLocation(
        latitude:row['lat']as double ,
        longitude:row['lng']as double  ,
        address:row['address']as String  ,
      ),
  ) ,).toList();
 state=places;
}
//create insert method
  void addPlace(String title, File image,PlaceLocation location)async {
    final appDir=await syspaths.getApplicationDocumentsDirectory();
    final fileName= path.basename(image.path);
   final copyedImage= await image.copy('${appDir.path}/$fileName');
    final newPlace = Place(title: title, image: copyedImage, location: location);
    final db=await _getDatabase();

    db.insert('user_places', {
      'id':newPlace.id,
      'title':newPlace.title,
      'image':newPlace.image.path,
      'lat':newPlace.location.latitude,
      'lng':newPlace.location.longitude,
      'address':newPlace.location.address,

    });

    state = [newPlace, ...state];
  }
}



final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
