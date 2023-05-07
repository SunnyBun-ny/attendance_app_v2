import 'package:attendance_app_v2/helpers/screenDetails.dart';
import 'package:attendance_app_v2/modules/screenStudentAttendanceDetails.dart';
import 'package:attendance_app_v2/widgets/CustomViewAttendanceCard.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/colors.dart';
import '../helpers/fonts.dart';
import '../widgets/customButtons.dart';

class ScreenViewStudentAtt extends StatefulWidget {
  Map<String, dynamic> classroomData;
  String classroomID;
  ScreenViewStudentAtt(
      {super.key, required this.classroomData, required this.classroomID});

  @override
  State<ScreenViewStudentAtt> createState() => _ScreenViewStudentAttState();
}

class _ScreenViewStudentAttState extends State<ScreenViewStudentAtt> {
  late FirebaseFirestore fireStore;

  @override
  void initState() {
    fireStore = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: AppColors.appBarGradient,
              ),
            ),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.classroomData['name'],
                  style: CustomFontStyle.subtitleBold(Colors.white)),
              const SizedBox(
                height: 4,
              ),
              Text(widget.classroomData['subject'],
                  style: CustomFontStyle.paraSRegular(AppColors.neutralGrey400))
            ]),
          ),
          body: FutureBuilder(
            future: fireStore
                .collection('attendance')
                .where('classroomId', isEqualTo: widget.classroomID)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No records available!!!',
                      style: CustomFontStyle.paraMRegular(
                          AppColors.neutralGrey500),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...(widget.classroomData['students'] as List).map(
                        (e) {
                          int lecturesAttended = 0;
                          int totalLectures = snapshot.data!.docs.length;
                          for (var x in snapshot.data!.docs) {
                            for (var y in x['attendance']) {
                              if (e['prnno'] == y['prn'] && y['status']) {
                                ++lecturesAttended;
                              }
                            }
                          }

                          double totalAttendance =
                              lecturesAttended / totalLectures * 100;
                          return CustomViewAttendanceCard(
                            onTapCard: () {
                              _onTapCard(
                                  data: snapshot.data!.docs,
                                  studentName: e['name'],
                                  rollNo: e['rollno'],
                                  prn: e['prnno']);
                            },
                            attendancePercent:
                                totalAttendance.truncateToDouble(),
                            name: e['name'],
                            rollno: (e['rollno'] as int),
                            prn: (e['prnno'] as int),
                          );
                        },
                      )
                    ],
                  ),
                );
              }
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

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }

  void _onTapCard(
      {required String studentName,
      required int rollNo,
      required int prn,
      required var data}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ScreenStudentAttendanceDetails(
              prn: prn,
              studentname: studentName,
              rollNo: rollNo.toString(),
              attendanceData: data,
            )));
  }
}
