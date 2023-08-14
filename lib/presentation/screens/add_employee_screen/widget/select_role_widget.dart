import 'package:flutter/material.dart';
import 'package:flutter_assignment/application/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectRole extends StatefulWidget {
  SelectRole({super.key, required this.text, required this.controller});
  final List text;
  TextEditingController controller;
  @override
  State<SelectRole> createState() => _SelectRoleState();
}

class _SelectRoleState extends State<SelectRole> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 195,
        child: Padding(
          padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: ListView.separated(
              itemCount: widget.text.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.controller.text = widget.text[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Text(widget.text[index], style: Const.medium),
                    ),
                    SizedBox(height: 10.h),
                    index != 3
                        ? const Divider(
                            color: Color(0XFFE5E5E5),
                            thickness: 1,
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8.h);
              },
            ),
          ),
        ));
  }
}
