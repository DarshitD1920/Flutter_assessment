import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Const {
  /// Color
  static const Color kBlack = Color(0XFF323238);
  static const Color kBackGround = Color(0XFFF2F2F2);
  static const Color kTextFieldColour = Color(0XFFE5E5E5);
  static const Color kTextFieldTextColour = Color(0XFF949C9E);
  static const Color kLightBlueColour = Color(0XFFEDF8FF);

// Padding
  static const double kPaddingS = 8.0;
  static const double kPaddingM = 16.0;
  static const double kPaddingL = 32.0;

// Spacing
  static const double kSpaceS = 8.0;
  static const double kSpaceM = 16.0;

  ///Large
  static TextStyle large = GoogleFonts.roboto(
    color: Const.kBlack,
    fontWeight: FontWeight.bold,
    fontSize: 30.sp,
  );

  ///Medium
  static TextStyle bold = GoogleFonts.roboto(
    color: Const.kBlack,
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
  );

  /// Small
  static TextStyle medium = GoogleFonts.roboto(
    color: Const.kBlack,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
}

class RichWidget extends StatelessWidget {
  const RichWidget({super.key, this.text, this.style, this.span});
  final TextStyle? style;
  final String? text;
  final List<TextSpan>? span;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(text: text, style: style, children: span),
    );
  }
}

void showError(String error, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(error),
    backgroundColor: Theme.of(context).colorScheme.error,
  ));
}

void showMessage(String message, context, void Function() onPressed) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: const TextStyle(color: Colors.white)),
    backgroundColor: Colors.black,
    action: SnackBarAction(label: 'Undo', onPressed: onPressed),
  ));
}
