import 'package:flutter/material.dart';

class AddPlaceScreen extends StatefulWidget{

const AddPlaceScreen ({super.key});


@override
  State<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }

}

class _AddPlaceScreenState extends State<AddPlaceScreen> {

  void _close() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        toolbarHeight: 100,
        title: Text('Add New Place',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 32,
              fontFamily: 'RobotoSlab',
              fontWeight: FontWeight.w500,),
              ),
      actions: [
        IconButton(
          onPressed: () {
            _close();
        }, 
        icon: Icon(Icons.close))
      ],),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text('Photo (optional)', 
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 23,
            ),),
           //TODO: take photo i choose photo kartice
           const SizedBox(height: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Place Name *',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 23,),
              ),
                SizedBox(height: 10),
                TextFormField(
                  decoration:  InputDecoration(
                    hintText: 'e.g. Campus Caffe',
                    hintStyle: TextStyle(
                      color: Color(0xFF728B25),
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xFF4A3728),
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(0xFF8A9B61)),
                    ),
                
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF8A9B61), width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return 'This field is required.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                  },
                ),
              ],
            ),
            const SizedBox(height: 30,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 23,),
              ),
                SizedBox(height: 10),
                TextFormField(
                  decoration:  InputDecoration(
                    hintText: 'Add location or use current',
                    hintStyle: TextStyle(
                      color: Color(0xFF728B25),
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xFF4A3728),
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(0xFF8A9B61)),
                    ),
                
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF8A9B61), width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return 'This field is required.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                  },
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Row(
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
                const SizedBox(height: 30,),
                Text('Category *',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 23,),
              ),
               //TODO categories
                const SizedBox(height: 30,),
                Text('Notes (optional)',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 23,),
              ),
           SizedBox(height: 10),
                TextFormField(
                  minLines: 5,
                  maxLines: null,
                  decoration:  InputDecoration(
                    hintText: 'Why is the place special to you?',
                    hintStyle: TextStyle(
                      color: Color(0xFF728B25),
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xFF4A3728),
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(0xFF8A9B61)),
                    ),
                
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF8A9B61), width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return 'This field is required.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                  },
                ),
            const SizedBox(height: 30,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160,
                  height: 57,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF5F1E8),
                      side: BorderSide(
                        color: Color(0xFF8A9B61),
                      )
                    ),
                    onPressed: (){}, 
                    child: Text('Cancel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    ),
                    ),
                ),
                SizedBox(
                  width: 160,
                  height: 57,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8A9B61),
                    ),
                    onPressed: (){}, 
                    child: Text('Save place',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFF5F1E8),
                      fontWeight: FontWeight.w400,
                    ),
                    ),
                ),
                ),
              ],
             ), 
             const SizedBox(height: 15),      
            ],
        ),
        ),
      )
    );
  }
}