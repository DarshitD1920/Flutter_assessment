import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/application/constants.dart';
import 'package:flutter_assignment/application/string.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalenderWidget extends StatefulWidget {
  CalenderWidget({super.key, required this.controller, this.isStartDat = true});
  TextEditingController controller;
  bool isStartDat;
  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  DateRangePickerController? controller;
  int selectedIndex = 0;
  @override
  void initState() {
    controller = DateRangePickerController();
    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  String currentDate = DateFormat('dd MMM yyyy')
      .format(DateTime.parse(DateTime.now().toString()));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isStartDat
          ? MediaQuery.of(context).size.height * 0.653
          : MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 12, right: 12, bottom: 7),
            child: Row(
              children: [
                Expanded(
                  child: ConstButton(
                      onTap: () {
                        widget.isStartDat
                            ? _onTodayButtonPressed(0)
                            : clearSelectedDate(0);
                      },
                      title: widget.isStartDat ? Strings.today : Strings.noDate,
                      boxColor: selectedIndex == 0
                          ? Colors.blue
                          : Const.kLightBlueColour,
                      titleColor:
                          selectedIndex == 0 ? Colors.white : Colors.blue),
                ),
                SizedBox(width: 10.w),
                Expanded(
                    child: ConstButton(
                        onTap: () {
                          setState(() {});
                          widget.isStartDat
                              ? _onNextMondayButtonPressed(1)
                              : _onTodayButtonPressed(1);
                        },
                        title: widget.isStartDat
                            ? Strings.nextMonday
                            : Strings.today,
                        boxColor: selectedIndex == 1
                            ? Colors.blue
                            : Const.kLightBlueColour,
                        titleColor:
                            selectedIndex == 1 ? Colors.white : Colors.blue))
              ],
            ),
          ),
          SizedBox(height: 10.h),
          widget.isStartDat
              ? Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ConstButton(
                            onTap: () {
                              _onNextTuesdayButtonPressed(2);
                            },
                            title: Strings.nextTuesday,
                            boxColor: selectedIndex == 2
                                ? Colors.blue
                                : Const.kLightBlueColour,
                            titleColor: selectedIndex == 2
                                ? Colors.white
                                : Colors.blue),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ConstButton(
                            onTap: () {
                              _onAfter1WeekButtonPressed(3);
                            },
                            title: Strings.after1Week,
                            boxColor: selectedIndex == 3
                                ? Colors.blue
                                : Const.kLightBlueColour,
                            titleColor: selectedIndex == 3
                                ? Colors.white
                                : Colors.blue),
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          widget.isStartDat ? SizedBox(height: 10.h) : const SizedBox.shrink(),
          SfDateRangePicker(
            controller: controller,
            showNavigationArrow: true,
            initialSelectedDate: DateTime.now(),
            allowViewNavigation: true,
            selectionColor: Colors.blue,
            backgroundColor: Colors.white,
            todayHighlightColor: Colors.blue,
            selectionShape: DateRangePickerSelectionShape.circle,
            selectionMode: DateRangePickerSelectionMode.single,
            onSelectionChanged: _onSelectionChanged,
            onViewChanged: (dateRangePickerViewChangedArgs) {},
          ),
          SizedBox(height: 15.h),
          const Divider(
            thickness: 1,
            color: Const.kTextFieldColour,
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: Colors.blue),
                SizedBox(width: 6.w),
                Text(currentDate,
                    style: Const.medium.copyWith(fontWeight: FontWeight.w500)),
                const Spacer(),
                ActionButton(
                    title: Strings.cancel, onTap: () => Navigator.pop(context)),
                SizedBox(width: 10.w),
                ActionButton(
                    title: Strings.save,
                    onTap: () => Navigator.pop(context),
                    boxColor: Colors.blue,
                    titleColor: Colors.white)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      final currentDateTime = DateFormat('dd MMM yyyy')
          .format(DateTime.parse(args.value.toString()));
      log(currentDateTime);
      if (currentDateTime.isNotEmpty) {
        setState(() {
          currentDate = currentDateTime;
          widget.controller.text = currentDateTime;
        });
      }
    });
  }

  void _onTodayButtonPressed(int index) {
    DateTime now = DateTime.now();
    setState(() {
      selectedIndex = index;
      selectedDate = now;
      controller?.displayDate = now;
      controller?.selectedDate = now;
    });
  }

  void _onNextMondayButtonPressed(int index) {
    DateTime now = DateTime.now();
    DateTime nextMonday;

    if (now.weekday == DateTime.monday) {
      nextMonday =
          getNextDayOfWeek(now.add(const Duration(days: 7)), DateTime.monday);
    } else {
      nextMonday = getNextDayOfWeek(now, DateTime.monday);
    }

    setState(() {
      selectedIndex = index;
      selectedDate = nextMonday;
      controller?.displayDate = nextMonday;
      controller?.selectedDate = nextMonday;
    });
  }

  DateTime getNextDayOfWeek(DateTime dateTime, int dayOfWeek) {
    int daysUntilNextDay = (dayOfWeek - dateTime.weekday + 7) % 7;
    return dateTime.add(Duration(days: daysUntilNextDay));
  }

  void _onNextTuesdayButtonPressed(int index) {
    DateTime now = DateTime.now();
    DateTime nextTuesday = getNextDayOfWeek(now, DateTime.tuesday);

    setState(() {
      selectedIndex = index;

      selectedDate = nextTuesday;
      controller?.displayDate = nextTuesday;
      controller?.selectedDate = nextTuesday;
    });
  }

  void _onAfter1WeekButtonPressed(int index) {
    DateTime now = DateTime.now();
    DateTime nextWeek = now.add(const Duration(days: 7));

    setState(() {
      selectedIndex = index;

      selectedDate = nextWeek;
      controller?.displayDate = nextWeek;
      controller?.selectedDate = nextWeek;
    });
  }

  void clearSelectedDate(int index) {
    setState(() {
      selectedIndex = index;
      selectedDate = DateTime.now();
      controller?.selectedDate = null;
    });
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.title,
    required this.onTap,
    this.boxColor,
    this.titleColor,
  });
  final String title;
  final Function() onTap;
  final Color? boxColor;
  final Color? titleColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 73.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: boxColor ?? Const.kLightBlueColour),
        child: Center(
          child: Text(title,
              style: Const.medium.copyWith(color: titleColor ?? Colors.blue)),
        ),
      ),
    );
  }
}

class ConstButton extends StatelessWidget {
  const ConstButton({
    super.key,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.boxColor,
  });
  final String title;
  final Function() onTap;
  final Color? titleColor;
  final Color? boxColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 36.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: boxColor),
        child: Center(
          child: Text(title, style: Const.medium.copyWith(color: titleColor)),
        ),
      ),
    );
  }
}
