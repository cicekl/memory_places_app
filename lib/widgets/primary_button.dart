import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {

const PrimaryButton ({super.key, required this.btnText, required this.onPress});

final String btnText;
final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 368,
      height: 57,
      child: ElevatedButton(
        onPressed: onPress, 
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(btnText,
        style: TextStyle(
          fontSize: 16,
        ),
        ),
        ),
    );
  }
}