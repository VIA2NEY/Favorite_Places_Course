import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:favorite_places/models/place.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  void _getCurrentLocation() async{

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
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final long = locationData.longitude;

    // Geocoding for getting the address
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(lat!, long!);
    final String adresse = '${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}.';
    
    print("@@@@@@@@@@@@@@La latitude est de ${locationData.latitude} et la longitude est de ${locationData.longitude} \n Concernant l'addresse $adresse````````````\n");

    if (lat == null || long == null) {
      return;
    }

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat, 
        longitude: long, 
        address: adresse
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
    
  }

  @override
  Widget build(BuildContext context) {

    Widget previewcontent = Text(
      'Aucune position selection',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onBackground
      ),
    );

    if (_pickedLocation != null) {
      previewcontent = FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
                  child: const Icon(Icons.person_pin,color: Colors.red,)
                ),
              ]
            )
        ]
      );
      
    }

    if (_isGettingLocation) {
      previewcontent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2)
            )
          ),
          child: previewcontent,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on), 
              label: const Text('Get Current Location'),
              onPressed: _getCurrentLocation 
            ),

            TextButton.icon(
              icon: const Icon(Icons.map), 
              label: const Text('Select on Map'),
              onPressed: (){} 
            ),
          ],
        )
      ],
    );
  }
}