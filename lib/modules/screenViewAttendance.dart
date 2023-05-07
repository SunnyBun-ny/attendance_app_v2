import 'package:attendance_app_v2/helpers/screenDetails.dart';
import 'package:attendance_app_v2/modules/screenCreateClassroom.dart';
import 'package:attendance_app_v2/modules/screenViewStudentAtt.dart';
import 'package:attendance_app_v2/widgets/customClassroomCard.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/colors.dart';
import '../helpers/fonts.dart';
import '../helpers/shared_prefs.dart';
import '../widgets/customButtons.dart';

class ScreenViewAttendance extends StatefulWidget {
  static String route = '/view-attendance';
  const ScreenViewAttendance({super.key});

  @override
  State<ScreenViewAttendance> createState() => _ScreenViewAttendanceState();
}

class _ScreenViewAttendanceState extends State<ScreenViewAttendance> {
  late FirebaseFirestore firestore;
  late SharedPreferences prefs;
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        prefs = value;
      });
    });
    firestore = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 62,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appBarGradient,
            ),
          ),
          title: Text(
            'View Attendance',
            style: CustomFontStyle.subtitleBold(Colors.white),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('classrooms')
                .orderBy('time')
                .where('uid', isEqualTo: prefs.getString(SharedPrefs.uid))
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print(snapshot.data);
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: context.width(120)),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Something went wrong!!',
                            style: CustomFontStyle.paraMRegular(
                                AppColors.neutralGrey400),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomButtons(
                            onTap: () {
                              setState.call(() {});
                            },
                            text: 'Retry',
                            suffixIcon: BootstrapIcons.arrow_clockwise,
                            buttonSize: ButtonSize.small,
                            buttonWidth: ButtonWidth.min,
                          )
                        ]),
                  ),
                );
              }

              if (snapshot.hasData) {
                return snapshot.data!.docs.isEmpty
                    ? Center(
                        child: Text(
                          'No Classrooms',
                          style: CustomFontStyle.paraMRegular(
                              AppColors.neutralGrey400),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 4,
                                  left: 4,
                                  right: 4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text('Select Classroom',
                                        style: CustomFontStyle.captionR(
                                            AppColors.neutralGrey400)),
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.neutralGrey300,
                                        thickness: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...snapshot.data!.docs.map((e) {
                                return CustomClassroomCard(
                                    classroomName: (e.data()
                                            as Map<String, dynamic>)['name']
                                        .toString(),
                                    subjectName: (e.data()
                                            as Map<String, dynamic>)['subject']
                                        .toString(),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            ScreenViewStudentAtt(
                                                classroomID: e.id,
                                                classroomData: e.data()
                                                    as Map<String, dynamic>),
                                      ));
                                    });
                              }).toList(),
                            ],
                          ),
                        ),
                      );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
