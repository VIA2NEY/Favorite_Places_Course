import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({
    required this.title, 
    required this.image,
    required this.location,
    String? id
  }) : id = id ?? uuid.v4(); // Retourne le id qu'on peut attribuer une valeur (id qui est dans la classe) ou si il est null genere une valeur


  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}