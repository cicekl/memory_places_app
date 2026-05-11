import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_places_app/screens/add_place.dart';
import 'package:memory_places_app/screens/dashboard.dart';
import 'package:memory_places_app/screens/statistics.dart';
import 'package:memory_places_app/screens/settings.dart';
import 'dart:io';

class TabsScreen extends StatefulWidget {
  const TabsScreen ({super.key});

@override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }

}

class _TabsScreenState extends State<TabsScreen> {

  Future<void> _openCameraAndAddPlace() async {
  final imagePicker = ImagePicker();

  final pickedImage = await imagePicker.pickImage(
    source: ImageSource.camera,
    maxHeight: 600,
  );

  if (pickedImage == null) return;

  if (!mounted) return;

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => AddPlaceScreen(
        initialImage: File(pickedImage.path),
      ),
    ),
  );
}


  int _selectedPageIndex = 0;

 void _selectPage(int index) {
  if (index == 1) {
    _openCameraAndAddPlace();
    return;
  }

  if (index == 2) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const StatisticsScreen(),
      ),
    );
    return;
  }

  if (index == 3) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
    return;
  }

  setState(() {
    _selectedPageIndex = index;
  });
}

  @override
  Widget build(BuildContext context) {

    Widget activePage = const DashboardScreen();

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          color: Color(0xFF728B25),
        ),
        onTap: (index) {
          _selectPage(index);
        },
        currentIndex: _selectedPageIndex,
        items: const [
            BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp,
            color: Color(0xFF728B25),),
            label: 'Places',
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined,
            color: Color(0xFF728B25),),
            label: 'Camera',
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.trending_up,
            color: Color(0xFF728B25),),
            label: 'Statistics',
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.settings_sharp,
            color: Color(0xFF728B25),),
            label: 'Settings',
            ),
        ],)
    );   
  }
}



