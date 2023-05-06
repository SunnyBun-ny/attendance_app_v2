import 'package:attendance_app_v2/helpers/fonts.dart';
import 'package:attendance_app_v2/helpers/screenDetails.dart';
import 'package:attendance_app_v2/widgets/customButtons.dart';
import 'package:attendance_app_v2/widgets/customClassroomCard.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helpers/colors.dart';

class ScreenClassrooms extends StatefulWidget {
  static String route = '/screen-classroom';
  const ScreenClassrooms({super.key});

  @override
  State<ScreenClassrooms> createState() => _ScreenClassroomsState();
}

class _ScreenClassroomsState extends State<ScreenClassrooms> {
  late FirebaseFirestore firestore;
  @override
  void initState() {
    firestore = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Icon(
            BootstrapIcons.plus,
            size: 30,
          ),
        ),
        appBar: AppBar(
          toolbarHeight: 62,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appBarGradient,
            ),
          ),
          title: Text(
            'Classrooms',
            style: CustomFontStyle.subtitleBold(Colors.white),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: firestore.collection('classrooms').orderBy('time').get(),
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
                return SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: snapshot.data!.docs.isEmpty
                      ? Center(
                          child: Text(
                            'No Classrooms',
                            style: CustomFontStyle.paraMRegular(
                                AppColors.neutralGrey400),
                          ),
                        )
                      : Column(
                          children: snapshot.data!.docs.map((e) {
                          print(snapshot.data!.docs.first.data());
                          return CustomClassroomCard(
                              classroomName:
                                  (e.data() as Map<String, dynamic>)['name']
                                      .toString(),
                              subjectName:
                                  (e.data() as Map<String, dynamic>)['subject']
                                      .toString(),
                              onTap: () {});
                        }).toList()),
                ));
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}

class DocumentSnapshot {}
