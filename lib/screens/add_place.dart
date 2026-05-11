import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_places_app/widgets/image_input.dart';
import 'dart:io';

import 'package:memory_places_app/widgets/selectable_category.dart';

class AddPlaceScreen extends StatefulWidget{

const AddPlaceScreen ({super.key,
this.initialImage});

final File? initialImage;


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
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  File? _selectedImage;

  void _setImage(File image) {
  setState(() {
    _selectedImage = image;
  });
  }

  Future<void> _pickImage(ImageSource source) async {
  final imagePicker = ImagePicker();

  final pickedImage = await imagePicker.pickImage(
    source: source,
    maxHeight: 600,
  );

  if (pickedImage == null) return;

    _setImage(File(pickedImage.path));
  }

  void _showImageSourceOptions() {
  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Upload photo'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      );
    },
  );
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
            const SizedBox(height: 10,),
           _selectedImage == null ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageInput(
          label: 'Take photo',
          icon: Icons.camera_alt_outlined,
          onTap: () => _pickImage(ImageSource.camera),
        ),
          ImageInput(
          label: 'Upload photo',
          icon: Icons.camera_alt_outlined,
          onTap: () => _pickImage(ImageSource.gallery),
        ),
        ],
      )
    : GestureDetector(
        onTap: _showImageSourceOptions,
        child: Container(
          width: double.infinity,
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF8A9B61),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
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
              const SizedBox(height: 10,),
              SizedBox(
                height: 100,
                child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 4.2,
                children: [
                 SelectableCategory(categoryName: 'Coffee'),
                 SelectableCategory(categoryName: 'Date'),
                 SelectableCategory(categoryName: 'Parks'),
                 SelectableCategory(categoryName: 'Restaurants'),
                 SelectableCategory(categoryName: 'Views'),
                SelectableCategory(categoryName: 'Art galleries'),
                ],
                            ),
              ), 
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