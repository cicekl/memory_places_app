import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memory_places_app/models/category.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/services/auth_service.dart';
import 'package:memory_places_app/services/place_service.dart';
import 'package:memory_places_app/services/storage_service.dart';
import 'package:memory_places_app/widgets/image_input.dart';
import 'package:memory_places_app/widgets/input_field.dart';
import 'package:memory_places_app/widgets/location_input.dart';
import 'dart:io';
import 'package:memory_places_app/widgets/selectable_category.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

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

  final _placeService = PlaceService();
  final _authService = AuthService();
  final _storageService = StorageService();
  double? _latitude;
  double? _longitude;
  String _street = '';
  String _city = '';
  String _postalCode = '';
  String _country = '';

  var _isSaving = false;

  Future<void> _savePlace() async {
    final user = _authService.currentUser;

    if(user == null) return;

    if(_placeNameController.text.trim().isEmpty ||
    _locationController.text.trim().isEmpty ||
    _selectedCategoryName == null ||
    _selectedLastVisit == null) {
       ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all required fields.'),
      ),
    );
    return;
    }

  setState(() {
      _isSaving = true;
    });

  final placeId = uuid.v4();
  String? imageUrl;

  if (_selectedImage != null) {
  imageUrl = await _storageService.uploadPlaceImage(
    image: _selectedImage!,
    userId: user.uid,
    placeId: placeId,
  );
}

    try {
    final place = Place(
      id: placeId,
      title:  _placeNameController.text.trim(), 
      description: _notesController.text.trim(), 
      imageUrl: imageUrl,
      location: PlaceLocation(
        latitude: _latitude ?? 0, 
        longitude: _longitude ?? 0, 
        city: _city, 
        country: _country, 
        postalCode: _postalCode, 
        street: _street.isEmpty ? _locationController.text.trim() : _street,
        ), 
      lastVisit: _selectedLastVisit!, 
      userId: user.uid, 
      category: Category(
        title: _selectedCategoryName!, 
        color:const Color(0xFF728B25), 
        isDefault: true),
      totalVisits: 1);

    

    await _placeService.addPlace(place);

     if (!mounted) return;

    Navigator.of(context).pop();

  } catch (error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not save place. Please try again.'),
      ),
    );
  } finally {
    if(mounted) {
      setState(() {
        _isSaving = false;
      });
    }
  }
}

  @override
  void dispose() {
    _locationController.dispose();
    _placeNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  DateTime? _selectedLastVisit;
  String? _selectedCategoryName;
  final _locationController = TextEditingController();
  final _placeNameController = TextEditingController();
final _notesController = TextEditingController();

  void _close() {
    Navigator.of(context).pop();
  }

void _presentLastVisitDatePicker() async {
  final now = DateTime.now();
  final firstDate = DateTime(now.year - 10, now.month, now.day);

  final pickedDate = await showDatePicker(
    context: context,
    initialDate: _selectedLastVisit ?? now,
    firstDate: firstDate,
    lastDate: now,
  );

  if (pickedDate == null) {
    return;
  }

  setState(() {
    _selectedLastVisit = pickedDate;
  });
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
              fontSize: 18,
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
            InputField(inputText: 'Place Name *', 
            hint: 'e.g. Campus Caffe', 
            controller: _placeNameController,),
            const SizedBox(height: 30,),
            LocationInput(
              inputText: 'Location *',
              hint: 'Add location or use current',
              requiredField: true,
              controller: _locationController,
              onLocationSelected: ({required city, required country, required latitude, required longitude, required postalCode, required street}) {
                _latitude = latitude;
                _longitude = longitude;
                _street = street;
                _city = city;
                _postalCode = postalCode;
                _country = country;
              },
            ),
                const SizedBox(height: 30,),
                Text('Category *',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 18,),
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
                 SelectableCategory(
                  categoryName: 'Coffee',
                  isSelected: _selectedCategoryName == 'Coffee',
                  onTap: () {
                    setState(() {
                      _selectedCategoryName = 'Coffee';
                    });
                  },
                ),
                 SelectableCategory(
                  categoryName: 'Date',
                  isSelected: _selectedCategoryName == 'Date',
                  onTap: () {
                    setState(() {
                      _selectedCategoryName = 'Date';
                    });
                  },
                ),
                SelectableCategory(
                  categoryName: 'Parks',
                  isSelected: _selectedCategoryName == 'Parks',
                  onTap: () {
                    setState(() {
                      _selectedCategoryName = 'Parks';
                    });
                  },
                ),
                SelectableCategory(
                  categoryName: 'Restaurants',
                  isSelected: _selectedCategoryName == 'Restaurants',
                  onTap: () {
                    setState(() {
                      _selectedCategoryName = 'Restaurants';
                    });
                  },
                ),
                ],
                            ),
              ), 
                const SizedBox(height: 30,),
                Text('Notes (optional)',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 18,),
              ),
           SizedBox(height: 10),
                TextFormField(
                  minLines: 5,
                  maxLines: null,
                  decoration:  InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                  controller: _notesController,
                  onSaved: (newValue) {
                  },
                ),
            const SizedBox(height: 20,),
        Text(
          'Last Visit *',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: 'RobotoSlab',
                fontSize: 18,
              ),
        ),
        const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF8A9B61),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedLastVisit == null
                          ? 'No date selected'
                          : formatter.format(_selectedLastVisit!),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(0xFF4A3728),
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: _presentLastVisitDatePicker,
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF728B25),
                    ),
                  ),
                ],
              ),
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
                    onPressed: _isSaving ? null : _savePlace, 
                    child: Text(_isSaving ? 'Saving...' : 'Save place',
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
        ], 
        ),
      )
    ),
    );
  }
}