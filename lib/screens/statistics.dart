import 'package:flutter/material.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/services/auth_service.dart';
import 'package:memory_places_app/services/place_service.dart';
import 'package:memory_places_app/widgets/progress_card.dart';
import 'package:memory_places_app/widgets/statistic_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  void _close() {
    Navigator.of(context).pop();
  }

  final _authService = AuthService();
  final _placeService = PlaceService();

  Color lightenColor(Color color, [double amount = 0.25]) {
    final hsl = HSLColor.fromColor(color);

    final lighter = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return lighter.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        toolbarHeight: 130,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 32,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Your memory places insights',
              maxLines: 2,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF728B25),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _close();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('User not found.'))
          : FutureBuilder<List<Place>>(
              future: _placeService.getPlaces(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final places = snapshot.data ?? [];

                final totalPlaces = places.length;
                final totalPhotos = places
                    .where((place) => place.imageUrl != null)
                    .length;
                final totalVisits = places.fold<int>(
                  0,
                  (sum, place) => sum + place.totalVisits,
                );

                final now = DateTime.now();
                final startOfWeek = now.subtract(
                  Duration(days: now.weekday - 1),
                );

                final thisWeek = places.where((place) {
                  return place.lastVisit.isAfter(startOfWeek);
                }).length;

                final categoryCounts = <String, int>{};

                for (final place in places) {
                  categoryCounts[place.category.title] =
                      (categoryCounts[place.category.title] ?? 0) + 1;
                }

                final sortedCategories = categoryCounts.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

                final favoriteCategory = sortedCategories.isEmpty
                    ? null
                    : sortedCategories.first;

                final favoritePlace = places.firstWhere(
                  (place) => place.category.title == favoriteCategory?.key,
                );

                final favoriteColor = favoritePlace.category.color;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: [
                            StatisticCard(
                              statisticNumber: totalPlaces.toString(),
                              title: 'Total Places',
                              icon: Icons.pin_drop_outlined,
                            ),
                            StatisticCard(
                              statisticNumber: totalPhotos.toString(),
                              title: 'Total Photos',
                              icon: Icons.camera_alt_outlined,
                            ),
                            StatisticCard(
                              statisticNumber: totalVisits.toString(),
                              title: 'Total Visits',
                              icon: Icons.trending_up,
                            ),
                            StatisticCard(
                              statisticNumber: thisWeek.toString(),
                              title: 'This Week',
                              icon: Icons.calendar_today_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Places by Category',
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(color: Color(0xFF728B25), fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: ListView(
                              children: sortedCategories.map((entry) {
                                final category = places
                                    .firstWhere(
                                      (place) =>
                                          place.category.title == entry.key,
                                    )
                                    .category;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: ProgressCard(
                                    categoryName: entry.key,
                                    number: entry.value.toString(),
                                    color: category.color,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Most Popular',
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(color: Color(0xFF728B25), fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                favoriteColor,
                                lightenColor(favoriteColor),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Your favorite category',
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                ),
                                Text(
                                  favoriteCategory?.key ?? 'No category',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                                Text(
                                  favoriteCategory == null
                                      ? 'No places yet'
                                      : '${favoriteCategory.value} places • ${((favoriteCategory.value / totalPlaces) * 100).round()}% of collection',
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
