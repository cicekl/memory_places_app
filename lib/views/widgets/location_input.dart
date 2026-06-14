import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

class LocationInput extends StatefulWidget{

  const LocationInput ({super.key,
  required this.inputText,
  this.hint,
  required this.controller,
  required this.requiredField,
  required this.onLocationSelected,
  });

  final String inputText;
  final String? hint;
  final TextEditingController? controller;
  final bool requiredField;
  final void Function({
  required double latitude,
  required double longitude,
  required String street,
  required String city,
  required String postalCode,
  required String country,
}) onLocationSelected;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  var _isGettingLocation = false;

  void _getCurrentLocation() async{

      loc.Location location = loc.Location();

      bool serviceEnabled;
      loc.PermissionStatus permissionGranted;
      loc.LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          return;
        }
      }

       setState(() {
    _isGettingLocation = true;
    });

      locationData = await location.getLocation();

      final lat = locationData.latitude;
      final lng = locationData.longitude;

      if (lat == null || lng == null) {
        return;
      }

      final placemarks = await placemarkFromCoordinates(lat, lng);

      if(placemarks.isEmpty) {
         widget.controller?.text = '$lat, $lng';
         return;
      }

    final place = placemarks.first;

   widget.onLocationSelected(
  latitude: lat,
  longitude: lng,
  street: place.street ?? '',
  city: place.locality ?? '',
  postalCode: place.postalCode ?? '',
  country: place.country ?? '',
);

    final address = [
      place.street,
      place.locality,
      place.postalCode,
      place.country,
    ].where((part) => part != null && part.trim().isNotEmpty).join(', ');

    widget.controller?.text = address;

    setState(() {
    _isGettingLocation = false;
  });
    }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.inputText,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: 'RobotoSlab',
                fontSize: 18,
              ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: _isGettingLocation ? 'Getting address...' : widget.hint,
            hintStyle: const TextStyle(
              color: Color(0xFF728B25),
            ),
            labelStyle: const TextStyle(
              color: Color(0xFF4A3728),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color(0xFF8A9B61),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color(0xFF8A9B61),
                width: 2,
              ),
            ),
          ),
          keyboardType: TextInputType.text,
          autocorrect: false,
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (widget.requiredField && (value == null || value.trim().isEmpty)) {
              return 'This field is required.';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        SizedBox(
           width: double.infinity,
          child: InkWell(
            onTap: _getCurrentLocation,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            child: Row(
            children: [
              Icon(Icons.location_pin,
              size: 23,
              color: Color(0xFF728B25),),
              const SizedBox(width: 5,),
              Text('Use Current Location',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Color(0xFF728B25),
                fontSize: 16,
              ),),
            ],
          ),
          ),
        ),
      ],
    );
  }
}