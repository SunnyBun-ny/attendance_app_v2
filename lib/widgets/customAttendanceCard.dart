import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:flutter/material.dart';
import '../widgets/customButtons.dart';
import '../helpers/fonts.dart';
import '../modules/screenHome.dart';

enum Status { notSelected, present, absent }

class CustomAttendanceCard extends StatefulWidget {
  Function(int prn, Status status) studentStatus;
  String name;
  int rollno;
  int prn;

  CustomAttendanceCard(
      {super.key,
      required this.studentStatus,
      required this.name,
      required this.rollno,
      required this.prn});

  @override
  State<CustomAttendanceCard> createState() => _CustomAttendanceCardState();
}

class _CustomAttendanceCardState extends State<CustomAttendanceCard> {
  int state = 0;
  @override
  void initState() {
    widget.studentStatus(widget.prn, Status.notSelected);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.neutralGrey300,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutralGrey500)),
      child: Column(
        children: [
          Row(
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
              Column(
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
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              state != 1
                  ? CustomButtons(
                      onTap: () {
                        setState(() {
                          state = 1;
                        });
                        widget.studentStatus(widget.prn, Status.present);
                      },
                      text: 'Present',
                      color: Colors.green,
                      buttonWidth: ButtonWidth.max,
                    )
                  : Expanded(
                      child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 153, 204, 154),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Present',
                        style: CustomFontStyle.paraMSemi(
                          AppColors.neutralGrey400,
                        ),
                      ),
                    )),
              const SizedBox(
                width: 8,
              ),
              state != 2
                  ? CustomButtons(
                      onTap: () {
                        setState(() {
                          state = 2;
                        });
                        widget.studentStatus(widget.prn, Status.absent);
                      },
                      text: 'Absent',
                      color: AppColors.alertRed,
                      buttonWidth: ButtonWidth.max,
                      enabled: state != 2 ? true : false,
                    )
                  : Expanded(
                      child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 204, 153, 153),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Absent',
                        style: CustomFontStyle.paraMSemi(
                          AppColors.neutralGrey400,
                        ),
                      ),
                    )),
            ],
          )
        ],
      ),
    );
  }
}
