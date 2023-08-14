import 'package:flutter/material.dart';
import 'package:flutter_assignment/application/constants.dart';
import 'package:flutter_assignment/application/string.dart';
import 'package:flutter_assignment/infrastructure/hive.dart';
import 'package:flutter_assignment/presentation/screens/add_employee_screen/add_employee_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  Employee? _deletedEmployee;
  int? _deletedEmployeeIndex;
  List<Employee> getEmployees() {
    final myBox = Hive.box<Employee>('employeeBox');
    return myBox.values.toList();
  }

  bool isEndDateExpired(String endDate) {
    final currentDate = DateTime.now();
    final parsedEndDate = DateFormat('dd MMM yyyy').parse(endDate);
    return currentDate.isAfter(parsedEndDate);
  }

  List<Employee> getCurrentEmployees() {
    final allEmployees = getEmployees();
    return allEmployees.where((employee) {
      return !isEndDateExpired(employee.endDate);
    }).toList();
  }

  List<Employee> getPreviousEmployees() {
    final allEmployees = getEmployees();
    return allEmployees.where((employee) {
      return isEndDateExpired(employee.endDate);
    }).toList();
  }

  void undoDelete() async {
    if (_deletedEmployee != null && _deletedEmployeeIndex != null) {
      final myBox = Hive.box<Employee>('employeeBox');
      await myBox.add(_deletedEmployee!);
      setState(() {});
      _deletedEmployee = null;
      _deletedEmployeeIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: getEmployees().isNotEmpty
          ? Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Const.kTextFieldColour),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(Strings.swipeToDelete,
                    style: Const.bold.copyWith(color: const Color(0XFF949C9E))),
              ),
            )
          : const SizedBox.shrink(),
      backgroundColor: Const.kBackGround,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEmployeeScreen(refresh: setState)));
        },
        child: const Icon(Icons.add, size: 25),
      ),
      appBar: AppBar(
        title: Text(
          Strings.empList,
          style: Const.bold.copyWith(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: getEmployees().isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getCurrentEmployees().isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: Const.kTextFieldColour),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(Strings.currentEmp,
                                  style:
                                      Const.bold.copyWith(color: Colors.blue)),
                            ),
                          )
                        : const SizedBox.shrink(),
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowIndicator();
                        return false;
                      },
                      child: ListView.separated(
                        itemCount: getCurrentEmployees().length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final employeeList = getCurrentEmployees();
                          final employee = employeeList[index];
                          return SwipeActionCell(
                            key: ValueKey(employee.empName),
                            trailingActions: <SwipeAction>[
                              SwipeAction(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onTap: (CompletionHandler handler) async {
                                  await handler(true);
                                  final myBox =
                                      Hive.box<Employee>('employeeBox');
                                  _deletedEmployee = myBox.getAt(index);
                                  _deletedEmployeeIndex = index;
                                  await myBox.deleteAt(index);
                                  showMessage(
                                      "Employee data has been deleted", context,
                                      () async {
                                    undoDelete();
                                  });
                                  setState(() {});
                                },
                                color: Colors.red,
                              ),
                            ],
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEmployeeScreen(
                                    isEdit: true,
                                    refresh: setState,
                                    index: index,
                                    empName: employee.empName,
                                    selectedRole: employee.selectedRole,
                                    todayDate: employee.startDate,
                                    endDate: employee.endDate,
                                  ),
                                ),
                              ),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        employee.empName,
                                        style: Const.bold,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        employee.selectedRole,
                                        style: Const.medium.copyWith(
                                            color: const Color(0XFF949C9E)),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        employee.startDate,
                                        style: Const.medium.copyWith(
                                          color: const Color(0XFF949C9E),
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.white,
                            child: const Divider(
                              color: Const.kTextFieldColour,
                              thickness: 0.7,
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration:
                          const BoxDecoration(color: Const.kTextFieldColour),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("Previous employees",
                            style: Const.bold.copyWith(color: Colors.blue)),
                      ),
                    ),
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowIndicator();
                        return false;
                      },
                      child: ListView.separated(
                        itemCount: getPreviousEmployees().length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final employeeList = getPreviousEmployees();
                          final employee = employeeList[index];
                          return Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    employee.empName,
                                    style: Const.bold,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    employee.selectedRole,
                                    style: Const.medium.copyWith(
                                        color: const Color(0XFF949C9E)),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "From ${employee.endDate}",
                                    style: Const.medium.copyWith(
                                        color: const Color(0XFF949C9E),
                                        fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.white,
                            child: const Divider(
                              color: Const.kTextFieldColour,
                              thickness: 0.7,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Strings.empStateImage,
                          height: 200.h, width: 261.w),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    Strings.emptyState,
                    style: Const.bold.copyWith(color: Const.kBlack),
                  )
                ],
              ),
      )),
    );
  }
}
