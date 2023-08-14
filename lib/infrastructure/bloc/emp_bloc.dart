import 'package:flutter/material.dart';
import 'package:flutter_assignment/infrastructure/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class EmployeeBloc extends Cubit<List<Employee>> {
  EmployeeBloc() : super([]);

  Future<void> fetchEmployees() async {
    final employeeBox = await Hive.openBox<Employee>('employeeBox');
    emit(employeeBox.values.toList());
  }

  Future<void> addEmployee(Employee employee) async {
    final employeeBox = await Hive.openBox<Employee>('employeeBox');
    await employeeBox.add(employee);
    fetchEmployees();
  }

  Future<void> updateEmployee(int index, Employee updatedEmployee) async {
    final employeeBox = await Hive.openBox<Employee>('employeeBox');
    await employeeBox.putAt(index, updatedEmployee);
    fetchEmployees();
  }

  Future<void> deleteEmployee(int index) async {
    final employeeBox = await Hive.openBox<Employee>('employeeBox');
    await employeeBox.deleteAt(index);
    fetchEmployees();
  }

  void editEmployee(
      String empName,
      String newSelectedRole,
      String newStartDate,
      String newEndDate,
      final void Function(void Function()) refresh,
      BuildContext context) async {
    final myBox = Hive.box<Employee>('employeeBox');
    final index = myBox.values
        .toList()
        .indexWhere((employee) => employee.empName == empName);

    if (index != -1) {
      final updatedEmployee =
          Employee(empName, newSelectedRole, newStartDate, newEndDate);
      await myBox.putAt(index, updatedEmployee);
      // refresh(() {});
      refresh(() {});
    }
    Navigator.pop(context, true);
  }
}
