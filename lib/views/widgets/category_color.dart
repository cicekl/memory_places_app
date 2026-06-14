import 'package:flutter/material.dart';

class CategoryColor extends StatelessWidget {
  const CategoryColor({
    super.key,
    required this.text,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 75,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            fontSize: 16,
            color: Color(0xffF5F1E8),
            fontWeight: FontWeight.w400,
            fontFamily: 'RobotoSlab',
          ),
        ),
      ),
    );
  }
}
