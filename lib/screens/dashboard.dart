import 'package:flutter/material.dart';
import 'package:memory_places_app/screens/add_place.dart';
import 'package:memory_places_app/screens/login.dart';
import 'package:memory_places_app/services/auth_service.dart';
import 'package:memory_places_app/widgets/category_chip.dart';
import 'package:memory_places_app/widgets/place_card.dart';

class DashboardScreen extends StatefulWidget{

const DashboardScreen ({super.key});

@override
  State<StatefulWidget> createState() {
    return _DashboardScreenState();
  }

}



class _DashboardScreenState extends State<DashboardScreen> {

  final _authService = AuthService();

  void _addPlace() async{
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => AddPlaceScreen(),),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(onPressed: () {
            _authService.logout();

             if (!context.mounted) return;

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }, icon: Icon(Icons.exit_to_app, color: Color(0xFF728B25)))
        ],
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Places',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 32,
              fontFamily: 'RobotoSlab',
              fontWeight: FontWeight.w500,),
              ),
            Text('14 memories captured',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF728B25),),),
          ], 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchAnchor(
              builder: (context, controller) {
                return SizedBox(
                  height: 60,
                  child: SearchBar(
                  padding: WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                leading: Icon(Icons.search,
                                color: Color(0xFF728B25),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                  Colors.white
                                ),
                                shadowColor: WidgetStatePropertyAll(Colors.transparent),
                                side: WidgetStatePropertyAll(
                            BorderSide(
                              color:Color(0xFF728B25),
                            )
                                ),
                                shape: WidgetStatePropertyAll(
                                   RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                ),
                                hintText: 'Search your places...',
                                hintStyle: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontFamily: 'RobotoSlab',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF728B25),),),
                                ),
                );
              },
              suggestionsBuilder: (context, controller) {return [];},
            ),
        const SizedBox(height: 15,),
        SizedBox(
        height: 40,
        child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
        CategoryChip(categoryName: 'All', numberOfItems: 14),
        const SizedBox(width: 10),
        CategoryChip(categoryName: 'Coffee', numberOfItems: 5),
        const SizedBox(width: 10),
        CategoryChip(categoryName: 'Parks', numberOfItems: 5),
        const SizedBox(width: 10),
        CategoryChip(categoryName: 'Restaurants', numberOfItems: 4),
          ],
      ),
    ),
    const SizedBox(height: 30,),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Recent memories',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontFamily: 'RobotoSlab',
          fontSize: 23,
        ),),
      Row(
        children: [
          Icon(Icons.map_outlined,
          size: 23,
          color: Color(0xFF728B25),),
          const SizedBox(width: 5,),
          Text('Map View',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Color(0xFF728B25),
            fontSize: 16,
          ),),
        ],
      ),
      ],
    ),
    const SizedBox(height: 20,),
   Expanded(
  child: GridView(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      crossAxisSpacing: 3,
      mainAxisSpacing: 10,
    ),
    children: [
      PlaceCard(),
      PlaceCard(),
      PlaceCard(),
      PlaceCard(),
    ],
  ),
),
    ],    
 ),  
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: (){
          _addPlace();
        },
        backgroundColor: Color(0xFF728B25),
        child: Icon(Icons.add,
        color: Colors.white,
        size: 30,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}