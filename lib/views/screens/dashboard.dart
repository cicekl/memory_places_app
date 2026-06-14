import 'package:flutter/material.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/viewmodels/auth_viewmodel.dart';
import 'package:memory_places_app/viewmodels/notification_viewmodel.dart';
import 'package:memory_places_app/viewmodels/place_viewmodel.dart';
import 'package:memory_places_app/views/screens/places/add_place.dart';
import 'package:memory_places_app/views/screens/places/place_details.dart';
import 'package:memory_places_app/views/screens/statistics/statistics.dart';
import 'package:memory_places_app/views/widgets/category_chip.dart';
import 'package:memory_places_app/views/widgets/notification_card.dart';
import 'package:memory_places_app/views/widgets/place_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future(() {
      final placeViewModel = ref.read(placeViewModelProvider);
      final notificationViewModel = ref.read(notificationViewModelProvider);
      final authViewModel = ref.read(authViewModelProvider);

      final userId = authViewModel.userId;

      if (userId != null) {
        placeViewModel.fetchPlaces(userId);
        notificationViewModel.fetchNotifications(userId);
      }
    });
  }

  String _formatNotificationTime(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} h ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    return '${difference.inDays} days ago';
  }

  void _addPlace() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()));

    if (!mounted) return;

    final authViewModel = ref.read(authViewModelProvider);
    final placeViewModel = ref.read(placeViewModelProvider);

    final userId = authViewModel.userId;

    if (userId != null) {
      await placeViewModel.fetchPlaces(userId);
    }
  }

  Future<void> selectPlace(Place place) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PlaceDetailsScreen(place: place)),
    );

    if (!mounted) return;

    final authViewModel = ref.read(authViewModelProvider);
    final placeViewModel = ref.read(placeViewModelProvider);

    final userId = authViewModel.userId;

    if (userId != null) {
      await placeViewModel.fetchPlaces(userId);
    }
  }

  void _openNotifications() async {
    final authViewModel = ref.read(authViewModelProvider);
    final notificationViewModel = ref.read(notificationViewModelProvider);

    final userId = authViewModel.userId;
    if (userId == null) return;

    await notificationViewModel.fetchNotifications(userId);
    await notificationViewModel.markAllAsRead(userId);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final notifications = ref
                .watch(notificationViewModelProvider)
                .notifications;

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.55,
              minChildSize: 0.35,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Notifications',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontFamily: 'RobotoSlab',
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: notifications.isEmpty
                            ? const Center(child: Text('No notifications yet.'))
                            : ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final notification = notifications[index];

                                  return NotificationCard(
                                    title: notification.title,
                                    description: notification.description,
                                    time: _formatNotificationTime(
                                      notification.createdAt,
                                    ),
                                    type: notification.type,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeViewModel = ref.watch(placeViewModelProvider);
    final notificationViewModel = ref.watch(notificationViewModelProvider);
    final authViewModel = ref.watch(authViewModelProvider);
    final userId = authViewModel.userId;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        actions: [
          if (userId != null)
            StreamBuilder<int>(
              stream: notificationViewModel.unreadCount(userId),
              builder: (context, snapshot) {
                final unreadCount = snapshot.data ?? 0;

                return IconButton(
                  onPressed: _openNotifications,
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications, color: Color(0xFF728B25)),
                      if (unreadCount > 0)
                        Positioned(
                          right: -1,
                          top: -1,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC96A4A),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
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
            Text(
              '${placeViewModel.filteredPlaces.length} memories captured',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF728B25),
              ),
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
                  placeViewModel.setSearchQuery(value.trim().toLowerCase());
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
            if (placeViewModel.loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (placeViewModel.filteredPlaces.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No places yet.', style: TextStyle(fontSize: 18)),
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          CategoryChip(
                            categoryName: 'All',
                            numberOfItems: placeViewModel.allPlaces.length,
                            isSelected:
                                placeViewModel.selectedCategoryId == null,
                            onTap: () {
                              placeViewModel.setSelectedCategory(null);
                            },
                          ),
                          ...placeViewModel.allPlaces
                              .map((p) => p.category)
                              .toSet()
                              .map((category) {
                                final count = placeViewModel.allPlaces
                                    .where((p) => p.category.id == category.id)
                                    .length;
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: CategoryChip(
                                    categoryName: category.title,
                                    numberOfItems: count,
                                    isSelected:
                                        placeViewModel.selectedCategoryId ==
                                        category.id,
                                    onTap: () {
                                      placeViewModel.setSelectedCategory(
                                        category.id,
                                      );
                                    },
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: placeViewModel.filteredPlaces.isEmpty
                          ? Center(
                              child: Text(
                                'No results found.',
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      color: const Color(0xFF728B25),
                                      fontFamily: 'RobotoSlab',
                                    ),
                              ),
                            )
                          : GridView.builder(
                              itemCount: placeViewModel.filteredPlaces.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 10,
                                  ),
                              itemBuilder: (context, index) {
                                return PlaceCard(
                                  place: placeViewModel.filteredPlaces[index],
                                  onSelectPlace: () => selectPlace(
                                    placeViewModel.filteredPlaces[index],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
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
