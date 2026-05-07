import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget{

const MapScreen ({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
 void _close() {
    Navigator.of(context).pop();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      actions: [
        IconButton(
          onPressed: () {
            _close();
        }, 
        icon: Icon(Icons.close))
      ]
      ),
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Placeholder(
          ), //TODO: map view 
        ),
      ),
    );
  }
}