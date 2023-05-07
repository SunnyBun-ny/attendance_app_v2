import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:attendance_app_v2/helpers/fonts.dart';
import 'package:attendance_app_v2/modules/screenHome.dart';
import 'package:attendance_app_v2/widgets/customAttendanceCard.dart';
import 'package:attendance_app_v2/widgets/customButtons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/modelAttendanceStatus.dart';

class ScreenTakeAttendance extends StatefulWidget {
  Map<String, dynamic> classroomData;
  String classroomID;
  static String route = '/screen-take-attendannce';
  ScreenTakeAttendance({
    super.key,
    required this.classroomData,
    required this.classroomID,
  });

  @override
  State<ScreenTakeAttendance> createState() => _ScreenTakeAttendanceState();
}

class _ScreenTakeAttendanceState extends State<ScreenTakeAttendance> {
  late FirebaseFirestore firestore;
  List<AttendanceStatus> _listAttendacneStatus = List.empty(growable: true);
  bool _isLoading = false;
  DateTime today = DateTime.now();
  @override
  void initState() {
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
            'Take Attendance',
            style: CustomFontStyle.subtitleBold(Colors.white),
          ),
        ),
        body: FutureBuilder(
            future: firestore
                .collection('attendance')
                .where('classroomId', isEqualTo: widget.classroomID)
                // .where('date',
                //     isGreaterThan: DateTime(today.year, today.month, today.day))
                .where('date',
                    isLessThan: DateTime(
                      today.year,
                      today.month,
                      today.day + 1,
                    ))
                .get(),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: AppColors.blue200,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Date : ',
                                        style: CustomFontStyle.paraSSemi(
                                          AppColors.neutralGrey800,
                                        )),
                                    Text(DateFormat('EEEE, d MMM, yyyy')
                                        .format(DateTime.now()))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Time : ',
                                        style: CustomFontStyle.paraSSemi(
                                          AppColors.neutralGrey800,
                                        )),
                                    Text(DateFormat.jm().format(DateTime.now()))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Classroom : ',
                                        style: CustomFontStyle.paraSSemi(
                                          AppColors.neutralGrey800,
                                        )),
                                    Text(widget.classroomData['name']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Subject : ',
                                        style: CustomFontStyle.paraSSemi(
                                          AppColors.neutralGrey800,
                                        )),
                                    Text(widget.classroomData['subject']),
                                  ],
                                ),
                              ]),
                          CustomButtons(
                            onTap: _onTapDone,
                            text: 'Done',
                            isLoading: _isLoading,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...(widget.classroomData['students'] as List).map(
                            (e) => CustomAttendanceCard(
                              studentStatus: (prn, status) {
                                _listAttendacneStatus.removeWhere(
                                    (element) => element.prnNo == prn);
                                AttendanceStatus att = AttendanceStatus(
                                    prnNo: prn, status: status);
                                _listAttendacneStatus.add(att);
                              },
                              name: e['name'],
                              rollno: (e['rollno'] as int),
                              prn: (e['prnno'] as int),
                            ),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              );
            }),
      ),
    );
  }

  void _onTapDone() {
    bool commit = true;
    for (var x in _listAttendacneStatus) {
      if (x.status == Status.notSelected) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please mark all student\'s attendance')));
        commit = false;
        break;
      }
    }

    if (commit) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> data = {
        'classroomId': widget.classroomID,
        'date': DateTime.now(),
        'attendance': _listAttendacneStatus
            .map((e) => {
                  'prn': e.prnNo,
                  'status': e.status == Status.present ? true : false,
                })
            .toList(),
      };

      firestore.collection('attendance').doc().set(data).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Atttendance Uploaded!')));
        Navigator.of(context).pop();
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error} Please try again!')));
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
