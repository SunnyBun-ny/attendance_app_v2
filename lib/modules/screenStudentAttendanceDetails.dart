import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/colors.dart';
import '../helpers/fonts.dart';

class ScreenStudentAttendanceDetails extends StatefulWidget {
  final attendanceData;
  final String studentname;
  final String rollNo;
  final int prn;
  const ScreenStudentAttendanceDetails({
    super.key,
    required this.attendanceData,
    required this.studentname,
    required this.rollNo,
    required this.prn,
  });

  @override
  State<ScreenStudentAttendanceDetails> createState() =>
      _ScreenStudentAttendanceDetailsState();
}

class _ScreenStudentAttendanceDetailsState
    extends State<ScreenStudentAttendanceDetails> {
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
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.studentname,
              style: CustomFontStyle.subtitleBold(Colors.white)),
          const SizedBox(
            height: 4,
          ),
          Text(widget.rollNo,
              style: CustomFontStyle.paraSRegular(AppColors.neutralGrey400))
        ]),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neutralGrey400)),
            child: Column(
              children: [
                Container(
                  color: AppColors.neutralGrey600,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text('Date',
                              style: CustomFontStyle.paraMSemi(Colors.white)),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: 1,
                        height: 12,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text('Status',
                              style: CustomFontStyle.paraMSemi(Colors.white)),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: 1,
                        height: 12,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...(widget.attendanceData as List).map((e) {
                          bool status = (e['attendance'] as List)
                              .where((element) => element['prn'] == widget.prn)
                              .first['status'];

                          return _widgetTableRow(
                              DateFormat.yMMMMEEEEd()
                                  .format((e['date'] as Timestamp).toDate()),
                              status);
                        })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _widgetTableRow(String date, bool status) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(date,
                style: CustomFontStyle.paraMSemi(AppColors.neutralGrey500)),
          ),
        ),
        Container(
          color: AppColors.neutralGrey400,
          width: 1,
          height: 12,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                  color: status ? const Color(0xffAFFF7D) : AppColors.alertRed,
                  borderRadius: BorderRadius.circular(4)),
              child: Text(status ? 'Present' : 'Absent',
                  style: CustomFontStyle.paraMSemi(AppColors.neutralGrey900)),
            ),
          ),
        ),
      ],
    );
  }
}
