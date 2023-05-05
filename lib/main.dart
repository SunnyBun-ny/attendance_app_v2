import 'package:attendance_app_v2/modules/login_and_register/screenLogin.dart';
import 'package:attendance_app_v2/modules/login_and_register/screenRegister.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AttendanceAppV2());
}

class AttendanceAppV2 extends StatefulWidget {
  const AttendanceAppV2({super.key});

  @override
  State<AttendanceAppV2> createState() => _AttendanceAppV2State();
}

class _AttendanceAppV2State extends State<AttendanceAppV2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      initialRoute: ScreenLogin.route,
      routes: {
        ScreenLogin.route: (context) => ScreenLogin(),
        ScreenRegister.route: (context) => ScreenRegister()
      },
    );
  }
}
