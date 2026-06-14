import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/viewmodels/place_viewmodel.dart';
import 'package:memory_places_app/views/screens/places/edit_place_details.dart';
import 'package:memory_places_app/views/widgets/primary_button.dart';

class PlaceDetailsScreen extends ConsumerStatefulWidget {
  const PlaceDetailsScreen({super.key, required this.place});

  final Place place;

  @override
  ConsumerState<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends ConsumerState<PlaceDetailsScreen> {
  late Place _place;

  @override
  void initState() {
    super.initState();
    _place = widget.place;
  }

  Future<void> _markVisited() async {
    await ref
        .read(placeViewModelProvider)
        .markPlaceVisited(_place.userId, _place.id);

    setState(() {
      _place = Place(
        id: _place.id,
        title: _place.title,
        description: _place.description,
        imageUrl: _place.imageUrl,
        location: _place.location,
        lastVisit: DateTime.now(),
        userId: _place.userId,
        category: _place.category,
        totalVisits: _place.totalVisits + 1,
        reminderSent: false,
      );
    });
  }

  Future<void> _deletePlace() async {
    if (!mounted) return;
    Navigator.of(context).pop(true);
    await ref
        .read(placeViewModelProvider)
        .deletePlace(_place.userId, _place.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  _place.imageUrl ??
                      'https://i.pinimg.com/736x/89/be/69/89be69d7de3f535a30266794f19028bc.jpg',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.black.withValues(alpha: 0.1),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(135, 78, 72, 72),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _place.title,
                            style: Theme.of(context).textTheme.headlineMedium!
                                .copyWith(
                                  color: Color(0xFFF5F1E8),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.label_important_outline,
                                color: Color(0xFFF5F1E8),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _place.category.title,
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                      color: Color(0xFFF5F1E8),
                                      fontSize: 15,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Color(0xFF728B25),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 365,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Color(0xffE6E7DA),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Icon(
                              Icons.pin_drop_outlined,
                              color: Color(0xFF728B25),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _place.location.street,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium!.copyWith(),
                                ),
                                Text(
                                  '${_place.location.postalCode} ${_place.location.city}',
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF728B25),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'My Notes',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Color(0xFF728B25),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 365,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          _place.description.isEmpty
                              ? 'No notes added.'
                              : _place.description,
                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontSize: 15, fontFamily: 'RobotoSlab'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Visits',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Color(0xFF728B25),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 170,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _place.totalVisits.toString(),
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(
                                    color: Color(0xff4A3728),
                                    fontSize: 18,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total visits',
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(
                                    color: Color(0xFF728B25),
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 170,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.yMd().format(_place.lastVisit),
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(
                                    color: Color(0xff4A3728),
                                    fontSize: 18,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Last visit',
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(
                                    color: Color(0xFF728B25),
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  PrimaryButton(btnText: 'Mark Visited', onPress: _markVisited),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 280,
                        height: 57,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    EditPlaceDetailsScreen(place: _place),
                              ),
                            );

                            if (!context.mounted) return;

                            if (result == true) {
                              Navigator.of(context).pop(true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_location_alt),
                              const SizedBox(width: 8),
                              Text(
                                'Edit place',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF8A9B61),
                            width: 1.2,
                          ),
                        ),
                        child: IconButton(
                          onPressed: _deletePlace,
                          icon: const Icon(
                            Icons.delete_outline_outlined,
                            size: 25,
                            color: Color(0xFF8A9B61),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
