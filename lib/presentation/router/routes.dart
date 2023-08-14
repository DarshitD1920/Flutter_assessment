import 'package:flutter/material.dart';
import 'package:flutter_assignment/application/exceptions/route_exception.dart';
import 'package:flutter_assignment/presentation/screens/employee_list/employee_list.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  static const String employeeList = 'employee list';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case employeeList:
        return PageTransition(
            child: const EmployeeListScreen(),
            type: PageTransitionType.leftToRight);
      default:
        throw const RouteException('Route not found!');
    }
  }
}
