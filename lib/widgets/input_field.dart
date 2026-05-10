import 'package:flutter/material.dart';

class InputField extends StatelessWidget{

  InputField ({super.key, required this.inputText, this.hint});

  String? hint;
  String inputText;



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(inputText,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 18,),
              ),
        SizedBox(height: 10),
        TextFormField(
                      decoration:  InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Color(0xFF728B25),
                        ),
                        labelStyle: TextStyle(
                          color: Color(0xFF4A3728),
                          ),
                          enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Color(0xFF8A9B61)),
                        ),
                    
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Color(0xFF8A9B61), width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if(value == null || value.trim().isEmpty) {
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                      },
                    ),
      ],
    );
  }
}