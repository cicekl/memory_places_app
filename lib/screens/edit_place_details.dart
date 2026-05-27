import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/services/place_service.dart';
import 'package:memory_places_app/services/storage_service.dart';
import 'package:memory_places_app/widgets/input_field.dart';
import 'package:memory_places_app/widgets/location_input.dart';
import 'package:memory_places_app/widgets/primary_button.dart';

final formatter = DateFormat.yMd();

class EditPlaceDetailsScreen extends StatefulWidget {
  const EditPlaceDetailsScreen({super.key, required this.place});

  final Place place;

  @override
  State<EditPlaceDetailsScreen> createState() => _EditPlaceDetailsScreenState();
}

class _EditPlaceDetailsScreenState extends State<EditPlaceDetailsScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _placeService = PlaceService();
  final _storageService = StorageService();
  var _isSaving = false;

  DateTime? _selectedLastVisit;
  File? _selectedImage;

  double? _latitude;
  double? _longitude;
  String _street = '';
  String _city = '';
  String _postalCode = '';
  String _country = '';

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    String? imageUrl = widget.place.imageUrl;

    if (_selectedImage != null) {
      imageUrl = await _storageService.uploadPlaceImage(
        image: _selectedImage!,
        userId: widget.place.userId,
        placeId: widget.place.id,
      );
    }

    final updatedPlace = Place(
      id: widget.place.id,
      title: _titleController.text.trim(),
      description: _notesController.text.trim(),
      imageUrl: imageUrl,
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
      category: widget.place.category,
      totalVisits: widget.place.totalVisits,
    );

    try {
      await _placeService.updatePlace(
        userId: widget.place.userId,
        place: updatedPlace,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not update place.')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

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
                btnText: _isSaving ? 'Saving...' : 'Save changes',
                onPress: _isSaving ? () {} : _saveChanges,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
