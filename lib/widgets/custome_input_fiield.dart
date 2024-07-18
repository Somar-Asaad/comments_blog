import 'package:flutter/material.dart';

class CostumeInputField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final RegExp regExp;
  final Function(String?) onSave;

  const CostumeInputField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.regExp,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: hintText == 'Email'
            ? TextInputType.emailAddress
            : TextInputType.visiblePassword,
        obscureText: obscureText,
        onSaved: onSave,
        style: Theme.of(context).textTheme.bodySmall,
        validator: (input) {
          if (input != null && !regExp.hasMatch(input)) {
            return 'Please Enter a valid $hintText';
          }
          return null;
        },
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.primaryContainer,
          filled: true,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
