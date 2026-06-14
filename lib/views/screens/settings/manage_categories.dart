import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_places_app/viewmodels/auth_viewmodel.dart';
import 'package:memory_places_app/viewmodels/category_viewmodel.dart';
import 'package:memory_places_app/views/screens/settings/new_category.dart';
import 'package:memory_places_app/views/widgets/category_tile.dart';
import 'package:memory_places_app/views/widgets/primary_button.dart';

class ManageCategoriesScreen extends ConsumerStatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  ConsumerState<ManageCategoriesScreen> createState() =>
      _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState
    extends ConsumerState<ManageCategoriesScreen> {
  void _openNewCategory() async {
    final categoryAdded = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const NewCategoryScreen()));

    if (categoryAdded == true) {
      final authViewModel = ref.read(authViewModelProvider);
      final categoryViewModel = ref.read(categoryViewModelProvider);

      final userId = authViewModel.userId;

      if (userId != null) {
        categoryViewModel.fetchCategories(userId);
      }
    }
  }

  Future<void> _deleteCategory(String categoryId) async {
    final authViewModel = ref.read(authViewModelProvider);
    final categoryViewModel = ref.read(categoryViewModelProvider);

    final userId = authViewModel.userId;

    if (userId == null) return;

    await categoryViewModel.deleteCategory(userId, categoryId);
  }

  @override
  void initState() {
    super.initState();

    Future(() {
      final authViewModel = ref.read(authViewModelProvider);
      final categoryViewModel = ref.read(categoryViewModelProvider);

      final userId = authViewModel.userId;

      if (userId != null) {
        categoryViewModel.fetchCategories(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = ref.watch(categoryViewModelProvider);
    final customCategories = categoryViewModel.categories
        .where((c) => !c.isDefault)
        .toList();
    final defaultCategories = categoryViewModel.categories
        .where((c) => c.isDefault)
        .toList();

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
              if (categoryViewModel.loading)
                const Center(child: CircularProgressIndicator())
              else
                ...defaultCategories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CategoryTile(
                      categoryName: category.title,
                      description: 'Built-in category',
                      color: category.color,
                    ),
                  ),
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
              categoryViewModel.loading
                  ? const Center(child: CircularProgressIndicator())
                  : customCategories.isEmpty
                  ? const Text('No custom categories yet.')
                  : SizedBox(
                      height: 170,
                      child: ListView.separated(
                        itemCount: customCategories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final category = customCategories[index];
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
                            onDismissed: (_) => _deleteCategory(category.id),
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
                onPress: () => _openNewCategory(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
