import 'package:flutter/material.dart';
import 'package:memory_places_app/models/category.dart';
import 'package:memory_places_app/screens/new_category.dart';
import 'package:memory_places_app/services/auth_service.dart';
import 'package:memory_places_app/services/category_service.dart';
import 'package:memory_places_app/services/place_service.dart';
import 'package:memory_places_app/widgets/category_tile.dart';
import 'package:memory_places_app/widgets/primary_button.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  void _openNewCategory(BuildContext context) async {
    final categoryAdded = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const NewCategoryScreen()));

    if (categoryAdded == true) {
      _loadCustomCategories();
    }
  }

  final _categoryService = CategoryService();
  final _authService = AuthService();
  final _placeService = PlaceService();

  List<Category> _customCategories = [];
  var _isLoading = true;

  Future<void> _loadCustomCategories() async {
    final user = _authService.currentUser;

    if (user == null) return;

    final categories = await _categoryService.getUserCategories(user.uid);

    if (!mounted) return;

    setState(() {
      _customCategories = categories;
      _isLoading = false;
    });
  }

  Future<void> _deleteCategory(String categoryId) async {
    final user = _authService.currentUser;

    if (user == null) return;

    await _placeService.deletePlacesByCategory(
      userId: user.uid,
      categoryId: categoryId,
    );

    await _categoryService.deleteUserCategory(
      userId: user.uid,
      categoryId: categoryId,
    );

    if (!mounted) return;

    setState(() {
      _customCategories.removeWhere((category) => category.id == categoryId);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCustomCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        toolbarHeight: 130,
        leadingWidth: 45,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage categories',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 32,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Customize your place types',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Default categories',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Color(0xFF728B25),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              CategoryTile(
                categoryName: 'Coffee',
                description: 'Built-in category',
                color: Color(0xFF4A3728),
              ),
              const SizedBox(height: 10),
              CategoryTile(
                categoryName: 'Parks',
                description: 'Built-in category',
                color: Color(0xFF718a2f),
              ),
              const SizedBox(height: 10),
              CategoryTile(
                categoryName: 'Date',
                description: 'Built-in category',
                color: Color(0xFFc66b4f),
              ),
              const SizedBox(height: 10),
              CategoryTile(
                categoryName: 'Restaurants',
                description: 'Built-in category',
                color: Color(0xFFe5b858),
              ),
              const SizedBox(height: 20),
              Text(
                'Custom categories',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Color(0xFF728B25),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _customCategories.isEmpty
                  ? const Text('No custom categories yet.')
                  : SizedBox(
                      height: 170,
                      child: ListView.separated(
                        itemCount: _customCategories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final category = _customCategories[index];

                          return Dismissible(
                            key: ValueKey(category.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onDismissed: (_) {
                              _deleteCategory(category.id);
                            },
                            child: CategoryTile(
                              categoryName: category.title,
                              description: 'Custom category',
                              color: category.color,
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 20),
              PrimaryButton(
                btnText: 'Add category',
                onPress: () => _openNewCategory(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
