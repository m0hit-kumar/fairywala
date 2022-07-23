import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class Button extends StatelessWidget {
  final String name;
  final Function userMethod;

  Button(this.name, this.userMethod);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => userMethod(),
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        alignment: Alignment.center,
        height: 45.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            primaryBoxShadow,
          ],
          color: primaryColor,
        ),
        child: Text(
          name,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
