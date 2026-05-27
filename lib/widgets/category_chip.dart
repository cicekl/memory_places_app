import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.categoryName,
    required this.numberOfItems,
    required this.onTap,
    required this.isSelected,
  });

  final String categoryName;
  final int numberOfItems;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF728B25) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF8A9B61)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(categoryName),
            const SizedBox(width: 8),
            Container(
              alignment: Alignment.center,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              constraints: const BoxConstraints(minWidth: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFF5F1E8),
              ),
              child: Text(numberOfItems.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
