import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/place.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';


Future<Database>_getDatabase() async{
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'), 
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)'
      );
    },
    version: 1
  );

  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {

  UserPlacesNotifier() : super (const []);

  Future<void> loadPlaces() async{
    final db = await _getDatabase();
    final data = await db.query('user_places');

    final places = data.map(
      (dbitem) {
        return Place(
          id: dbitem['id'] as String,
          title: dbitem['title'] as String, 
          image: File(dbitem['image'] as String) , 
          location: PlaceLocation(
            latitude: dbitem['lat'] as double, 
            longitude: dbitem['lng'] as double, 
            address: dbitem['address'] as String
          ),
        );
      }
    ).toList();

    state = places;
  }

  void addPlace (String title, File image, PlaceLocation location) async{

    // For Local storage 
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace = Place(title: title, image: copiedImage, location: location);

    final db = await _getDatabase();
    db.insert(
      'user_places', 
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': newPlace.location.latitude,
        'lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      }
    );

    state = [
      newPlace,
      ...state
    ];
  }
}


final userPlacesNotifier = StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier()
);
