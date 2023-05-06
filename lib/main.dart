import 'package:attendance_app_v2/helpers/shared_prefs.dart';
import 'package:attendance_app_v2/modules/screenClassrooms.dart';
import 'package:attendance_app_v2/modules/screenHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modules/screenLogin.dart';
import 'modules/screenRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      prefs.setBool(SharedPrefs.isLoggedIn, false);
      print('User not Logged in');
    } else {
      prefs.setBool(SharedPrefs.isLoggedIn, true);
      print('User Logged in');
    }
  });

  runApp(AttendanceAppV2(
    isLoggedIn: prefs.get(SharedPrefs.isLoggedIn) as bool,
  ));
}

class AttendanceAppV2 extends StatefulWidget {
  final bool isLoggedIn;
  const AttendanceAppV2({super.key, required this.isLoggedIn});

  @override
  State<AttendanceAppV2> createState() => _AttendanceAppV2State();
}

class _AttendanceAppV2State extends State<AttendanceAppV2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Inter',
          scaffoldBackgroundColor: AppColors.neutralGrey100),
      initialRoute: widget.isLoggedIn ? ScreenHome.route : ScreenLogin.route,
      routes: {
        ScreenLogin.route: (context) => ScreenLogin(),
        ScreenRegister.route: (context) => ScreenRegister(),
        ScreenHome.route: (context) => ScreenHome(),
        ScreenClassrooms.route: (context) => ScreenClassrooms(),
      },
    );
  }
}
