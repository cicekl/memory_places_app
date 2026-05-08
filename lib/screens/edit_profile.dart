import 'package:flutter/material.dart';
import 'package:memory_places_app/widgets/input_field.dart';
import 'package:memory_places_app/widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget{

const EditProfileScreen ({super.key});

@override
  State<EditProfileScreen> createState() {
    return _EditProfileScreenState();
  }


}

class _EditProfileScreenState extends State<EditProfileScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      toolbarHeight: 130,
      leadingWidth: 45,
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit profile',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 32,
              fontFamily: 'RobotoSlab',
              fontWeight: FontWeight.w500,),
              ),
            Text('Update your information',
            maxLines: 2,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF728B25),),),
          ], 
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InputField(inputText: 'Full name'),
            const SizedBox(height: 20,),
            InputField(inputText: 'Email'),
            const SizedBox(height: 20,),
            InputField(inputText: 'Current password'),
            const SizedBox(height: 30,),
            InputField(inputText: 'New password'),
            const SizedBox(height: 50,),
            PrimaryButton(btnText: 'Save changes', onPress: (){}),
          ],
        ),
      ),
    );
  }
}