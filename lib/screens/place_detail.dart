import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          place.title
        ),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // CircleAvatar(
                //   radius: 70,
                //   child: 
                // ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => MapScreen(location: place.location, isSelecting: false,)
                      )
                    );
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(90))
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(place.location.latitude, place.location.longitude),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(place.location.latitude, place.location.longitude),
                                  child: const Icon(Icons.location_on,color: Colors.red,)
                                ),
                              ]
                            )
                        ]
                      ),
                    ),
                ),

                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                  ),
                  child: Text(
                    place.location.address,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}