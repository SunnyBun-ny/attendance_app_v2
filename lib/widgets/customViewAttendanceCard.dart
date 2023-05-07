import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:flutter/material.dart';
import '../widgets/customButtons.dart';
import '../helpers/fonts.dart';
import '../modules/screenHome.dart';

enum Status { notSelected, present, absent }

class CustomViewAttendanceCard extends StatefulWidget {
  double attendancePercent;
  String name;
  int rollno;
  int prn;
  VoidCallback onTapCard;

  CustomViewAttendanceCard(
      {super.key,
      required this.onTapCard,
      required this.attendancePercent,
      required this.name,
      required this.rollno,
      required this.prn});

  @override
  State<CustomViewAttendanceCard> createState() =>
      _CustomViewAttendanceCardState();
}

class _CustomViewAttendanceCardState extends State<CustomViewAttendanceCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTapCard,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.neutralGrey300,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutralGrey500)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/profile_default.jpeg',
              ),
              radius: 25,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(widget.name,
                        style: CustomFontStyle.subtitleMedium(
                            AppColors.neutralGrey700)),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(widget.rollno.toString(),
                        style: CustomFontStyle.paraSRegular(
                            AppColors.neutralGrey700))
                  ]),
            ),
            Text('${widget.attendancePercent}%',
                style: CustomFontStyle.h5Semi(AppColors.neutralGrey700))
          ],
        ),
      ),
    );
  }
}
