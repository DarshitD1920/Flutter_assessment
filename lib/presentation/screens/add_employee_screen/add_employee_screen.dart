import 'package:flutter/material.dart';
import 'package:flutter_assignment/application/constants.dart';
import 'package:flutter_assignment/application/string.dart';
import 'package:flutter_assignment/infrastructure/hive.dart';
import 'package:flutter_assignment/presentation/screens/add_employee_screen/widget/calender_widget.dart';
import 'package:flutter_assignment/presentation/screens/add_employee_screen/widget/const_textfield.dart';
import 'package:flutter_assignment/presentation/screens/add_employee_screen/widget/select_role_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen(
      {super.key,
      this.isEdit = false,
      this.empName,
      this.selectedRole,
      required this.refresh,
      this.todayDate,
      this.endDate,
      this.index});
  final bool isEdit;
  final String? empName;
  final String? selectedRole;
  final String? todayDate;
  final String? endDate;
  final int? index;
  final void Function(void Function()) refresh;

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController empName = TextEditingController();
  final TextEditingController selectRole = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void updateEmployeeList() {
    setState(() {});
  }

  List text = [
    Strings.productDesigner,
    Strings.flutterDev,
    Strings.qaTester,
    Strings.productOwner,
  ];
  void editEmployee(
      {required String oldEmpName,
      required String newEmpName,
      required String newSelectedRole,
      required String newStartDate,
      required String newEndDate}) async {
    final myBox = Hive.box<Employee>('employeeBox');
    final index = myBox.values
        .toList()
        .indexWhere((employee) => employee.empName == oldEmpName);

    if (index != -1) {
      final updatedEmployee = Employee(
        newEmpName,
        newSelectedRole,
        newStartDate,
        newEndDate,
      );

      if (oldEmpName == newEmpName) {
        await myBox.putAt(index, updatedEmployee);
      } else {
        await myBox.deleteAt(index);
        await myBox.add(updatedEmployee);
      }

      setState(() {});
      widget.refresh(() {});
    }

    Navigator.pop(context, true);
  }

  void addEmployee() async {
    if (empName.text.isNotEmpty &&
        selectRole.text.isNotEmpty &&
        startDate.text.isNotEmpty &&
        endDate.text.isNotEmpty) {
      final myBox = Hive.box<Employee>('employeeBox');
      final newEmployee = Employee(
        empName.text,
        selectRole.text,
        startDate.text,
        endDate.text,
      );
      await myBox.add(newEmployee);
      empName.clear();
      selectRole.clear();
      startDate.clear();
      endDate.clear();
      setState(() {});
      widget.refresh(() {});
      Navigator.pop(context, true);
    } else {
      showError("Please fill required filled", context);
    }
  }

  @override
  void initState() {
    if (widget.isEdit) {
      setState(() {
        empName.text = widget.empName ?? "";
        selectRole.text = widget.selectedRole ?? "";
        startDate.text = widget.todayDate ?? "";
        endDate.text = widget.endDate ?? "";
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomButton(
        onPressed: () async {
          if (widget.isEdit) {
            editEmployee(
              oldEmpName: widget.empName ?? "",
              newEmpName: empName.text,
              newSelectedRole: selectRole.text,
              newStartDate: startDate.text,
              newEndDate: endDate.text,
            );
          } else {
            addEmployee();
          }
          updateEmployeeList();
        },
      ),
      appBar: AppBar(
        title: Text(
          !widget.isEdit ? Strings.empDetails : Strings.edit,
          style: Const.bold.copyWith(color: Colors.white),
        ),
        actions: [
          widget.isEdit
              ? IconButton(
                  onPressed: () async {
                    final myBox = Hive.box<Employee>('employeeBox');
                    await myBox.deleteAt(widget.index ?? 0);
                    Navigator.pop(context, true);
                    setState(() {});
                    widget.refresh(() {});
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                )
              : Container()
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10.h),
              ConstTextField(
                  controller: empName,
                  icon: Icons.person,
                  hintText: Strings.empName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return Strings.emptyEmp;
                    }
                    return null;
                  }),
              SizedBox(height: 20.h),
              ConstTextField(
                  readOnly: true,
                  controller: selectRole,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return Strings.emptyRole;
                    }
                    return null;
                  },
                  onTap: () async {
                    await showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16)),
                        ),
                        backgroundColor: Colors.white,
                        builder: (BuildContext context) {
                          return SelectRole(text: text, controller: selectRole);
                        });
                  },
                  suffixIcon: const Icon(Icons.arrow_drop_down,
                      color: Colors.blue, size: 28),
                  icon: Icons.business_center_rounded,
                  hintText: Strings.selectRole),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ConstTextField(
                        controller: startDate,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings.emptyStartDate;
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    insetPadding: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    contentPadding: const EdgeInsets.all(0.0),
                                    content:
                                        CalenderWidget(controller: startDate),
                                  ));
                        },
                        icon: Icons.date_range_rounded,
                        hintText: Strings.today),
                  ),
                  SizedBox(width: 8.w),
                  const Icon(Icons.arrow_forward, color: Colors.blue),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ConstTextField(
                        controller: endDate,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings.emptyEndDate;
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    insetPadding: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    contentPadding: const EdgeInsets.all(0.0),
                                    content: CalenderWidget(
                                        controller: endDate, isStartDat: false),
                                  ));
                        },
                        icon: Icons.date_range_rounded,
                        hintText: Strings.noDate),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({super.key, this.onPressed});
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0XFFE5E5E5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Const.kLightBlueColour),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.blue),
              )),
          SizedBox(width: 10.w),
          ElevatedButton(onPressed: onPressed, child: const Text("Save")),
          SizedBox(width: 10.w)
        ],
      ),
    );
  }
}
