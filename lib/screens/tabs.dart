import 'package:flutter/material.dart';
import 'package:memory_places_app/screens/camera.dart';
import 'package:memory_places_app/screens/dashboard.dart';
import 'package:memory_places_app/screens/map.dart';
import 'package:memory_places_app/screens/settings.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen ({super.key});

@override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }

}

class _TabsScreenState extends State<TabsScreen> {

  int _selectedPageIndex = 0;

 void _selectPage(int index) {
  if (index == 1) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );
    return;
  }

  if (index == 2) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
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
            icon: Icon(Icons.map_outlined,
            color: Color(0xFF728B25),),
            label: 'Map',
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



