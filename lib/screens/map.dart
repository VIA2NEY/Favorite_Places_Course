import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:favorite_places/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: '',
    ),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {

  final MapController mapController = MapController();
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
          Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ]
      ),

      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(widget.location.latitude, widget.location.longitude),
          onTap: widget.isSelecting == false ? null :(tapPosition, point) {
            setState(() {
              _pickedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
              markers: [
                _pickedLocation != null ?
                  Marker(
                    point: LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
                    child: const Icon(Icons.location_on,color: Colors.red,)
                  )
                : Marker(
                  point: LatLng(widget.location.latitude, widget.location.longitude),
                  child: const Icon(Icons.location_on,color: Colors.red,)
                ),
              ]
            )
        ]
      ),
      
      // GoogleMap(
      //   initialCameraPosition: CameraPosition(
      //     target: LatLng(
      //       widget.location.latitude,
      //       widget.location.longitude,
      //     ),
      //     zoom: 16,
      //   ),
      //   markers: {
      //     Marker(
      //       markerId: const MarkerId('m1'),
      //       position: LatLng(
      //         widget.location.latitude,
      //         widget.location.longitude,
      //       ),
      //     ),
      //   },
      // ),


    );
  }
}