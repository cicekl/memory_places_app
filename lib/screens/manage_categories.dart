import 'package:flutter/material.dart';
import 'package:memory_places_app/screens/new_category.dart';
import 'package:memory_places_app/widgets/category_tile.dart';
import 'package:memory_places_app/widgets/primary_button.dart';

class ManageCategoriesScreen extends StatelessWidget{

  const ManageCategoriesScreen ({super.key});

  void _openNewCategory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NewCategoryScreen(),),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      toolbarHeight: 130,
      leadingWidth: 45,
      title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Manage categories',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 32,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w500,),
                ),
              Text('Customize your place types',
              maxLines: 2,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Default categories',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Color(0xFF728B25),
                    fontSize: 16,
                  ),
                  ),
              const SizedBox(height: 10,),
              CategoryTile(
                categoryName: 'Coffee', 
                description: 'Built-in category', 
                color: Color(0xFF4A3728),),
              const SizedBox(height: 10,),
              CategoryTile(
                categoryName: 'Parks', 
                description: 'Built-in category', 
                color: Color(0xFF718a2f),),
              const SizedBox(height: 10,),
              CategoryTile(
                categoryName: 'Date', 
                description: 'Built-in category', 
                color: Color(0xFFc66b4f),),
              const SizedBox(height: 10,),
              CategoryTile(
                categoryName: 'Restaurants', 
                description: 'Built-in category', 
                color: Color(0xFFe5b858),),
              const SizedBox(height: 20,),
              Text('Custom categories',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Color(0xFF728B25),
                    fontSize: 16,
                  ),
                  ), 
              const SizedBox(height: 10,),
              SizedBox(
                height: 170,
                child: ListView(
                  children: [
                  CategoryTile(
                  categoryName: 'Bookstores', 
                  description: 'Custom category', 
                  color: Color(0xFF4A3728),),
                  const SizedBox(height: 10,),
                  CategoryTile(
                  categoryName: 'Art galleries', 
                  description: 'Custom category', 
                  color: Color(0xFFc66b4f),),
                  const SizedBox(height: 10,),
                  CategoryTile(
                  categoryName: 'Views', 
                  description: 'Custom category', 
                  color: Color(0xFF718a2f),),
                  const SizedBox(height: 10,),
                  ],
                ),
              ), 
            const SizedBox(height: 20,),
            PrimaryButton(btnText: 'Add category', onPress: () => _openNewCategory(context),),
           const SizedBox(height: 20,),    
            ],
          ),
        ),
      ),
    );
  }
}