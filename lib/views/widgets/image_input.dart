import 'package:flutter/material.dart';

class ImageInput extends StatelessWidget {
  const ImageInput({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF8A9B61),
          width: 1.5,
        ),
      ),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
        ),
        icon: Icon(icon),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}