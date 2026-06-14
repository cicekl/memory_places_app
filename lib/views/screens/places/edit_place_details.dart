import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memory_places_app/models/category.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/viewmodels/category_viewmodel.dart';
import 'package:memory_places_app/viewmodels/place_viewmodel.dart';
import 'package:memory_places_app/views/widgets/input_field.dart';
import 'package:memory_places_app/views/widgets/location_input.dart';
import 'package:memory_places_app/views/widgets/primary_button.dart';

final formatter = DateFormat.yMd();

class EditPlaceDetailsScreen extends ConsumerStatefulWidget {
  const EditPlaceDetailsScreen({super.key, required this.place});

  final Place place;

  @override
  ConsumerState<EditPlaceDetailsScreen> createState() =>
      _EditPlaceDetailsScreenState();
}

class _EditPlaceDetailsScreenState
    extends ConsumerState<EditPlaceDetailsScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedLastVisit;
  File? _selectedImage;
  Category? _selectedCategory;
  double? _latitude;
  double? _longitude;
  String _street = '';
  String _city = '';
  String _postalCode = '';
  String _country = '';

  Future<void> _saveChanges() async {
    final placeViewModel = ref.read(placeViewModelProvider);
    final categories = ref.read(categoryViewModelProvider).categories;

    _selectedCategory ??= categories.firstWhere(
      (c) => c.id == widget.place.category.id,
      orElse: () => categories.first,
    );

    final updatedPlace = Place(
      id: widget.place.id,
      title: _titleController.text.trim(),
      description: _notesController.text.trim(),
      imageUrl: widget.place.imageUrl,
      location: PlaceLocation(
        latitude: _latitude ?? widget.place.location.latitude,
        longitude: _longitude ?? widget.place.location.longitude,
        street: _street.isEmpty ? _locationController.text.trim() : _street,
        city: _city,
        postalCode: _postalCode,
        country: _country,
      ),
      lastVisit: _selectedLastVisit ?? widget.place.lastVisit,
      userId: widget.place.userId,
      category: _selectedCategory!,
      totalVisits: widget.place.totalVisits,
      reminderSent: widget.place.reminderSent,
    );

    await placeViewModel.updatePlace(
      widget.place.userId,
      updatedPlace,
      image: _selectedImage,
    );

    if (!mounted) return;

    if (placeViewModel.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not update place.')));
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(categoryViewModelProvider).fetchCategories(widget.place.userId);
    });
    _titleController.text = widget.place.title;
    _locationController.text = widget.place.location.street;
    _notesController.text = widget.place.description;
    _selectedLastVisit = widget.place.lastVisit;
    _latitude = widget.place.location.latitude;
    _longitude = widget.place.location.longitude;
    _street = widget.place.location.street;
    _city = widget.place.location.city;
    _postalCode = widget.place.location.postalCode;
    _country = widget.place.location.country;
  }

  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxHeight: 600,
    );
    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
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

  void _presentLastVisitDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 10, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedLastVisit ?? widget.place.lastVisit,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedLastVisit = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = ref.watch(categoryViewModelProvider);
    final placeViewModel = ref.watch(placeViewModelProvider);
    final hasExistingImage =
        widget.place.imageUrl != null &&
        widget.place.imageUrl!.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        toolbarHeight: 100,
        title: Text(
          'Edit place',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 32,
            fontFamily: 'RobotoSlab',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photo (optional)',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _showImageSourceOptions,
                child: Container(
                  width: double.infinity,
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF8A9B61),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : hasExistingImage
                        ? Image.network(
                            widget.place.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : const Center(child: Text('Tap to add image')),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              InputField(
                inputText: 'Place Name *',
                controller: _titleController,
              ),
              const SizedBox(height: 30),
              LocationInput(
                inputText: 'Location *',
                hint: 'Add location or use current',
                requiredField: true,
                controller: _locationController,
                onLocationSelected:
                    ({
                      required city,
                      required country,
                      required latitude,
                      required longitude,
                      required postalCode,
                      required street,
                    }) {
                      _latitude = latitude;
                      _longitude = longitude;
                      _street = street;
                      _city = city;
                      _postalCode = postalCode;
                      _country = country;
                    },
              ),
              const SizedBox(height: 30),

              Text(
                'Category *',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF8A9B61)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Category>(
                    value:
                        _selectedCategory ??
                        categoryViewModel.categories
                            .where((c) => c.id == widget.place.category.id)
                            .firstOrNull,
                    isExpanded: true,
                    items: categoryViewModel.categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Notes (optional)',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                minLines: 5,
                maxLines: null,
                controller: _notesController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Why is the place special to you?',
                  hintStyle: const TextStyle(color: Color(0xFF728B25)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFF8A9B61)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFF8A9B61),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  border: Border.all(color: const Color(0xFF8A9B61)),
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
              const SizedBox(height: 50),
              PrimaryButton(
                btnText: placeViewModel.loading ? 'Saving...' : 'Save changes',
                onPress: placeViewModel.loading ? () {} : _saveChanges,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
