import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class InputField extends StatelessWidget {
  final TextEditingController fieldController;
  final TextInputType textType;
  final Widget? suffix;
  final TextAlignVertical? textAlignVertical;
  final List<TextInputFormatter>? inputFormatters;

  const InputField(this.fieldController, this.textType,
      {Key? key, this.suffix, this.textAlignVertical, this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          primaryBoxShadow,
        ],
        color: secondaryColor,
      ),
      child: TextFormField(
        inputFormatters: inputFormatters,
        textAlignVertical: textAlignVertical,
        controller: fieldController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          suffixIcon: suffix,
        ),
        keyboardType: textType,
        style: const TextStyle(fontSize: 14),
        validator: (text) {
          if (text != null && (text.length < 10 || text.isEmpty)) {
            return 'Enter a valid mobile number';
          }
        },
      ),
    );
  }
}

class InputPassField extends StatefulWidget {
  final TextEditingController fieldController;
  final TextInputType textType;

  const InputPassField(this.fieldController, this.textType);

  @override
  State<InputPassField> createState() => _InputPassFieldState();
}

class _InputPassFieldState extends State<InputPassField> {
  bool isObscure = true;

  void changePassVisibility() {
    setState(() {
      if (isObscure) {
        isObscure = !isObscure;
      } else {
        isObscure = !isObscure;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            primaryBoxShadow,
          ],
          color: secondaryColor,
        ),
        child: TextFormField(
          controller: widget.fieldController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
            suffixIcon: IconButton(
              icon: isObscure
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: changePassVisibility,
            ),
          ),
          keyboardType: widget.textType,
          obscureText: isObscure,
          style: const TextStyle(fontSize: 16),
        ));
  }
}
