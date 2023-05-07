import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:attendance_app_v2/helpers/fonts.dart';
import 'package:attendance_app_v2/widgets/customButtons.dart';
import 'package:flutter/material.dart';

class CustomClassroomCard extends StatelessWidget {
  String classroomName;
  String subjectName;
  VoidCallback onTap;
  bool showButtons;
  bool showStatus;
  VoidCallback? onTapSkip;
  VoidCallback? onTapTakeAttendance;
  double bottomMargin;
  CustomClassroomCard({
    super.key,
    required this.classroomName,
    required this.subjectName,
    required this.onTap,
    this.showButtons = false,
    this.onTapSkip,
    this.onTapTakeAttendance,
    this.bottomMargin = 8,
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: bottomMargin),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.blue300,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(36, 56, 42, 42),
                  offset: Offset(4, 4),
                  spreadRadius: 0,
                  blurRadius: 4)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(classroomName,
                        style: CustomFontStyle.paraMSemi(
                            AppColors.neutralGrey700)),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(subjectName,
                        style: CustomFontStyle.paraSRegular(
                          AppColors.neutralGrey500,
                        ))
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            showStatus
                ? Expanded(
                    child: Container(
                    child: Text(
                      'Attendance Taken',
                      strutStyle:
                          CustomFontStyle.paraMSemi(AppColors.neutralGrey500),
                    ),
                  ))
                : const SizedBox.shrink(),
            showButtons
                ? Expanded(
                    child: Column(
                      children: [
                        CustomButtons(
                          onTap: onTapSkip ?? () {},
                          text: 'Take Attendance',
                          buttonSize: ButtonSize.small,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        CustomButtons(
                          onTap: onTapTakeAttendance ?? () {},
                          text: 'Skip',
                          buttonVarient: ButtonVarient.outlined,
                          buttonSize: ButtonSize.small,
                        )
                      ],
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
