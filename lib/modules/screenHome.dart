import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:attendance_app_v2/helpers/fonts.dart';
import 'package:attendance_app_v2/widgets/customClassroomCard.dart';
import 'package:flutter/material.dart';

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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color.fromARGB(255, 52, 64, 84),
                      Color(0xff475467)
                    ]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 25,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DataModel.name,
                              style:
                                  CustomFontStyle.subtitleBold(Colors.white)),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(DataModel.designation,
                              style: CustomFontStyle.paraSRegular(
                                  AppColors.neutralGrey400))
                        ]),
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _widgetMenuButtons('Take',
                    const AssetImage('assets/images/take_att.jpg'), () {}),
                const SizedBox(
                  height: 8,
                ),
                _widgetMenuButtons('View',
                    const AssetImage('assets/images/view_att.jpg'), () {}),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 4,
                    left: 4,
                    right: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Reminder',
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
                CustomClassroomCard(
                  classroomName: 'FYBTech Div B',
                  subjectName: 'NLP',
                  onTap: () {},
                  showButtons: true,
                )
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
