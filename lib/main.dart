import 'package:flutter/material.dart';
import 'package:flutter_assignment/infrastructure/bloc/emp_bloc.dart';
import 'package:flutter_assignment/presentation/router/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'infrastructure/hive.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  await Hive.openBox<Employee>('employeeBox');
  runApp(
      BlocProvider(create: (context) => EmployeeBloc(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, widget) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppRouter.employeeList,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
