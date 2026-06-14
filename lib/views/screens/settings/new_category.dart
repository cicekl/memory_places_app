import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_places_app/models/category.dart';
import 'package:memory_places_app/viewmodels/auth_viewmodel.dart';
import 'package:memory_places_app/viewmodels/category_viewmodel.dart';
import 'package:memory_places_app/views/widgets/category_color.dart';
import 'package:memory_places_app/views/widgets/input_field.dart';

class NewCategoryScreen extends ConsumerStatefulWidget {
  const NewCategoryScreen({super.key});

  @override
  ConsumerState<NewCategoryScreen> createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends ConsumerState<NewCategoryScreen> {
  final _categoryNameController = TextEditingController();

  Color _selectedColor = const Color(0xFF718a2f);

  void _close() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    _categoryNameController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _saveCategory() async {
    final authViewModel = ref.read(authViewModelProvider);
    final categoryViewModel = ref.read(categoryViewModelProvider);

    final userId = authViewModel.userId;

    if (_categoryNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter category name.')),
      );
      return;
    }

    final category = Category(
      title: _categoryNameController.text.trim(),
      color: _selectedColor,
      isDefault: false,
    );

    await categoryViewModel.addCategory(userId!, category);

    if (!mounted) return;

    if (categoryViewModel.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not save category.')));
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    super.dispose();
    _categoryNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = ref.watch(categoryViewModelProvider);

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
              'New Category',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 32,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Create your custom place category',
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              inputText: 'Category name',
              controller: _categoryNameController,
            ),
            const SizedBox(height: 20),
            Text(
              'Choose color',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryColor(
                  text: 'Olive',
                  color: Color(0xFF718a2f),
                  isSelected: _selectedColor == const Color(0xFF718a2f),
                  onTap: () {
                    setState(() {
                      _selectedColor = const Color(0xFF718a2f);
                    });
                  },
                ),
                const SizedBox(width: 10),
                CategoryColor(
                  text: 'Coffee',
                  color: Color(0xFF4A3728),
                  isSelected: _selectedColor == const Color(0xFF4A3728),
                  onTap: () {
                    setState(() {
                      _selectedColor = const Color(0xFF4A3728);
                    });
                  },
                ),
                const SizedBox(width: 10),
                CategoryColor(
                  text: 'Honey',
                  color: Color(0xFFe5b858),
                  isSelected: _selectedColor == const Color(0xFFe5b858),
                  onTap: () {
                    setState(() {
                      _selectedColor = const Color(0xFFe5b858);
                    });
                  },
                ),
                const SizedBox(width: 10),
                CategoryColor(
                  text: 'Rust',
                  color: Color(0xFFc66b4f),
                  isSelected: _selectedColor == const Color(0xFFc66b4f),
                  onTap: () {
                    setState(() {
                      _selectedColor = const Color(0xFFc66b4f);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Preview',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _selectedColor,
                ),
                child: Text(
                  _categoryNameController.text.trim().isEmpty
                      ? 'Category Name'
                      : _categoryNameController.text.trim(),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 16,
                    color: const Color(0xffF5F1E8),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'RobotoSlab',
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160,
                  height: 57,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF5F1E8),
                      side: BorderSide(color: Color(0xFF8A9B61)),
                    ),
                    onPressed: _close,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 57,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8A9B61),
                    ),
                    onPressed: categoryViewModel.loading ? null : _saveCategory,
                    child: Text(
                      categoryViewModel.loading ? 'Saving...' : 'Save category',
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
    );
  }
}
