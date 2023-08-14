import 'package:flutter/material.dart';
import 'package:flutter_assignment/application/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConstTextField extends StatefulWidget {
  const ConstTextField(
      {super.key,
      required this.controller,
      required this.icon,
      required this.hintText,
      this.suffixIcon,
      this.readOnly = false,
      required this.validator,
      this.onTap});
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final Widget? suffixIcon;
  final Function()? onTap;
  final bool readOnly;
  final String? Function(String?) validator;

  @override
  State<ConstTextField> createState() => _ConstTextFieldState();
}

class _ConstTextFieldState extends State<ConstTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        onTap: widget.onTap,
        validator: widget.validator,
        style: Const.medium.copyWith(fontSize: 12.sp),
        readOnly: widget.readOnly,
        controller: widget.controller,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: Colors.blue),
            suffixIcon: widget.suffixIcon ?? const SizedBox.shrink(),
            filled: true,
            contentPadding: const EdgeInsets.all(10),
            fillColor: Colors.white,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0XFFE5E5E5)),
            ),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0XFFE5E5E5)),
                borderRadius: BorderRadius.circular(4)),
            hintText: widget.hintText,
            hintStyle:
                Const.medium.copyWith(color: Const.kTextFieldTextColour)),
      ),
    );
  }
}
