import 'package:flutter/material.dart';

class SelectableCategory extends StatelessWidget{

const SelectableCategory ({super.key,
required this.categoryName,
required this.isSelected,
required this.onTap});

final String categoryName;
final bool isSelected;
final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Container(
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF728B25)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFF728B25),
          )
        ),
        child: Text(categoryName,
         style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontSize: 16,
                  color: isSelected
                    ? const Color(0xFFF5F1E8)
                    : const Color(0xFF4A3728),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'RobotoSlab',
                 ),),
      ),
    );
  }
}