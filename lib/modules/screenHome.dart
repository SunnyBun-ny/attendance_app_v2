import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:attendance_app_v2/helpers/fonts.dart';
import 'package:attendance_app_v2/helpers/shared_prefs.dart';
import 'package:attendance_app_v2/modules/screenClassrooms.dart';
import 'package:attendance_app_v2/modules/screenLogin.dart';
import 'package:attendance_app_v2/modules/screenViewAttendance.dart';
import 'package:attendance_app_v2/widgets/customClassroomCard.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataModel {
  static String name = 'Mangesh Pawar';
  static String designation = 'TYBTech Div B';
}

class ScreenHome extends StatefulWidget {
  static String route = '/screen-home';
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 82,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: AppColors.appBarGradient,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/profile_default.jpeg'),
                      radius: 25,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Attendance App',
                              style:
                                  CustomFontStyle.subtitleBold(Colors.white)),
                          const SizedBox(
                            height: 4,
                          ),
                          Text('V2',
                              style: CustomFontStyle.paraSRegular(
                                  AppColors.neutralGrey400))
                        ]),
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.alertRed,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              try {
                FirebaseAuth.instance.signOut().whenComplete(() {
                  prefs.setBool(SharedPrefs.isLoggedIn, false);
                  Navigator.pushNamedAndRemoveUntil(
                      context, ScreenLogin.route, (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out!')));
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error! Try Again.')));
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child:
                Text('Logout', style: CustomFontStyle.captionM(Colors.white)),
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _widgetMenuButtons(
                    'Take', const AssetImage('assets/images/take_att.jpg'), () {
                  Navigator.of(context).pushNamed(ScreenClassrooms.route);
                }),
                const SizedBox(
                  height: 8,
                ),
                _widgetMenuButtons(
                    'View', const AssetImage('assets/images/view_att.jpg'), () {
                  Navigator.of(context).pushNamed(ScreenViewAttendance.route);
                }),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     top: 16,
                //     bottom: 4,
                //     left: 4,
                //     right: 4,
                //   ),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.max,
                //     children: [
                //       Text('Reminder',
                //           style: CustomFontStyle.captionR(
                //               AppColors.neutralGrey400)),
                //       Expanded(
                //         child: Divider(
                //           color: AppColors.neutralGrey300,
                //           thickness: 0.8,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // CustomClassroomCard(
                //   classroomName: 'FYBTech Div B',
                //   subjectName: 'NLP',
                //   onTap: () {},
                //   showButtons: true,
                // )
              ],
            ),
          ))),
    );
  }

  Widget _widgetMenuButtons(String name, AssetImage img, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(
            color: AppColors.blue200,
            width: 1,
          ),
          // boxShadow: const [
          //   BoxShadow(
          //       color: Color.fromARGB(14, 56, 42, 42),
          //       offset: Offset(4, 4),
          //       spreadRadius: 0,
          //       blurRadius: 4)
          // ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: img,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style:
                      CustomFontStyle.subtitleRegular(AppColors.neutralGrey500),
                  softWrap: true,
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Attendance',
                  style:
                      CustomFontStyle.subtitleRegular(AppColors.neutralGrey500),
                  softWrap: true,
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.left,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
