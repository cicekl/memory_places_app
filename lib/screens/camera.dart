import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget{

const CameraScreen ({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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
          ), //TODO: open camera action
        ),
      ),
    );
  }
}