import 'package:flutter/material.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/screens/add_place.dart';
import 'package:memory_places_app/screens/login.dart';
import 'package:memory_places_app/screens/place_details.dart';
import 'package:memory_places_app/screens/statistics.dart';
import 'package:memory_places_app/services/auth_service.dart';
import 'package:memory_places_app/services/place_service.dart';
import 'package:memory_places_app/widgets/category_chip.dart';
import 'package:memory_places_app/widgets/place_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  final _placeService = PlaceService();

  String _searchQuery = '';
  String _selectedCategory = 'All';

  void _addPlace() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => AddPlaceScreen()));

    if (!mounted) return;

    setState(() {});
  }

  Future<void> selectPlace(Place place) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PlaceDetailsScreen(place: place)),
    );

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _authService.logout();

              if (!context.mounted) return;

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: Icon(Icons.exit_to_app, color: Color(0xFF728B25)),
          ),
        ],
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Places',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 32,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w500,
              ),
            ),
            FutureBuilder<List<Place>>(
              future: user == null
                  ? Future.value([])
                  : _placeService.getPlaces(user.uid),
              builder: (context, snapshot) {
                final totalPlaces = snapshot.data?.length ?? 0;

                return Text(
                  '$totalPlaces memories captured',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontFamily: 'RobotoSlab',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF728B25),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: SearchBar(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
                padding: WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 8.0),
                ),
                leading: Icon(Icons.search, color: Color(0xFF728B25)),
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                shadowColor: WidgetStatePropertyAll(Colors.transparent),
                side: WidgetStatePropertyAll(
                  BorderSide(color: Color(0xFF728B25)),
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
                    color: Color(0xFF728B25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Recent memories',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontFamily: 'RobotoSlab',
                    fontSize: 23,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const StatisticsScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 23,
                        color: Color(0xFF728B25),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Statistics',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Color(0xFF728B25),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: user == null
                  ? const Center(child: Text('User not found.'))
                  : FutureBuilder(
                      future: _placeService.getPlaces(user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              'No places yet.',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }

                        final places = snapshot.data!;
                        final categories = places
                            .map((place) => place.category.title)
                            .toSet()
                            .toList();

                        if (_selectedCategory != 'All' &&
                            !categories.contains(_selectedCategory)) {
                          _selectedCategory = 'All';
                        }

                        final filteredPlaces = places.where((place) {
                          final matchesSearch =
                              place.title.toLowerCase().contains(
                                _searchQuery,
                              ) ||
                              place.description.toLowerCase().contains(
                                _searchQuery,
                              ) ||
                              place.location.street.toLowerCase().contains(
                                _searchQuery,
                              );

                          final matchesCategory =
                              _selectedCategory == 'All' ||
                              place.category.title == _selectedCategory;

                          return matchesSearch && matchesCategory;
                        }).toList();

                        return Column(
                          children: [
                            SizedBox(
                              height: 40,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  CategoryChip(
                                    categoryName: 'All',
                                    numberOfItems: places.length,
                                    isSelected: _selectedCategory == 'All',
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = 'All';
                                      });
                                    },
                                  ),

                                  ...categories.map((category) {
                                    final count = places
                                        .where(
                                          (place) =>
                                              place.category.title == category,
                                        )
                                        .length;

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: CategoryChip(
                                        categoryName: category,
                                        numberOfItems: count,
                                        isSelected:
                                            _selectedCategory == category,
                                        onTap: () {
                                          setState(() {
                                            _selectedCategory = category;
                                          });
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            Expanded(
                              child: filteredPlaces.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No results found.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: const Color(0xFF728B25),
                                              fontFamily: 'RobotoSlab',
                                            ),
                                      ),
                                    )
                                  : GridView.builder(
                                      itemCount: filteredPlaces.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.75,
                                            crossAxisSpacing: 3,
                                            mainAxisSpacing: 10,
                                          ),
                                      itemBuilder: (context, index) {
                                        return PlaceCard(
                                          place: filteredPlaces[index],
                                          onSelectPlace: () => selectPlace(
                                            filteredPlaces[index],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          _addPlace();
        },
        backgroundColor: Color(0xFF728B25),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
