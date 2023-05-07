import 'dart:io';
import 'package:attendance_app_v2/helpers/shared_prefs.dart';
import 'package:attendance_app_v2/model/modelStudent.dart';
import 'package:attendance_app_v2/widgets/customButtons.dart';
import 'package:attendance_app_v2/widgets/customTextFields.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' as ex;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/colors.dart';
import '../helpers/fonts.dart';

class ScreenCreateClassroom extends StatefulWidget {
  static String route = '/screen-create-classroom';
  const ScreenCreateClassroom({super.key});

  @override
  State<ScreenCreateClassroom> createState() => _ScreenCreateClassroomState();
}

class _ScreenCreateClassroomState extends State<ScreenCreateClassroom> {
  late TextEditingController _controllerClassroomName;
  late TextEditingController _controllerSubjectName;
  PlatformFile? file;
  List<Student> _listOfStudents = List.empty(growable: true);
  String? _errorClassName;
  String? _errorSubjectName;
  bool _isLoading = false;
  bool _enabledClassroomName = true;
  bool _enabledSubjectName = true;

  bool _excelAdded = false;

  late FirebaseFirestore firestore;

  @override
  void initState() {
    _controllerClassroomName = TextEditingController();
    _controllerSubjectName = TextEditingController();
    firestore = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  void dispose() {
    _controllerClassroomName.dispose();
    _controllerSubjectName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
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
              'Create Classroom',
              style: CustomFontStyle.subtitleBold(Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomTextfields(
                  controller: _controllerClassroomName,
                  labelText: 'Classroom Name',
                  hintText: 'Enter classroom name',
                  errorText: _errorClassName,
                  enabled: _enabledClassroomName,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextfields(
                  controller: _controllerSubjectName,
                  labelText: 'Subject Name',
                  errorText: _errorSubjectName,
                  hintText: 'Enter subject name',
                  enabled: _enabledSubjectName,
                ),
                const SizedBox(
                  height: 16,
                ),
                !_excelAdded
                    ? Column(children: [
                        CustomButtons(
                          onTap: _onTapAddExcelSheet,
                          text: 'Add Excel Sheet',
                          suffixIcon: BootstrapIcons.link_45deg,
                          buttonSize: ButtonSize.small,
                          isLoading: _isLoading,
                        ),
                        Container(
                          margin: const EdgeInsets.all(12),
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Adding a Excel Sheet'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset('assets/images/excel_ss.PNG'),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('First Column = Student Name',
                                              style: CustomFontStyle.paraSSemi(
                                                  Colors.black)),
                                          Text('Second Column = Roll No',
                                              style: CustomFontStyle.paraSSemi(
                                                  Colors.black)),
                                          Text('Third Column = PRN No',
                                              style: CustomFontStyle.paraSSemi(
                                                  Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  BootstrapIcons.info_circle,
                                  size: 12,
                                  color: AppColors.neutralGrey600,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'More Info',
                                  style: CustomFontStyle.paraSRegular(
                                    AppColors.neutralGrey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ])
                    : Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selected File : ',
                                        style: CustomFontStyle.paraSSemi(
                                            AppColors.neutralGrey900),
                                      ),
                                      Text(
                                        file!.name,
                                        style: CustomFontStyle.paraSRegular(
                                            AppColors.neutralGrey900),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          file = null;
                                          _excelAdded = false;
                                          _listOfStudents =
                                              List.empty(growable: true);
                                        });
                                      },
                                      icon: Icon(BootstrapIcons.x_circle_fill,
                                          color: AppColors.alertRed, size: 30))
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: AppColors.neutralGrey400)),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: AppColors.neutralGrey600,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: Text('Name',
                                                    style: CustomFontStyle
                                                        .paraMSemi(
                                                            Colors.white)),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              width: 1,
                                              height: 12,
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: Text('Roll No',
                                                    style: CustomFontStyle
                                                        .paraMSemi(
                                                            Colors.white)),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              width: 1,
                                              height: 12,
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: Text('PRN No',
                                                    style: CustomFontStyle
                                                        .paraMSemi(
                                                            Colors.white)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ..._listOfStudents.map((e) =>
                                                  _widgetTableRow(e.name,
                                                      e.rollNo, e.prnNO))
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            CustomButtons(
                              onTap: _onTapCreateClassroom,
                              text: 'Create Classroom',
                              isLoading: _isLoading,
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapAddExcelSheet() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

    if (result != null) {
      file = result.files.first;
    } else {
      // User canceled the picker
    }

    var bytes = File(file!.path as String).readAsBytesSync();
    var excel = ex.Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        Student student = Student(
            name: row.elementAt(0)!.value.toString(),
            rollNo: row.elementAt(1)!.value,
            prnNO: row.elementAt(2)!.value);

        _listOfStudents.add(student);
      }
    }
    setState(() {
      _excelAdded = true;
    });
  }

  Widget _widgetTableRow(String name, int rollNo, int prnNo) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(name,
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
            child: Text(rollNo.toString(),
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
            child: Text(prnNo.toString(),
                style: CustomFontStyle.paraMSemi(AppColors.neutralGrey500)),
          ),
        )
      ],
    );
  }

  void _onTapCreateClassroom() async {
    if (_controllerClassroomName.text.trim().isEmpty) {
      setState(() {
        _errorClassName = 'Please enter classroom name';
      });
    } else if (_controllerSubjectName.text.trim().isEmpty) {
      setState(() {
        _errorSubjectName = 'Please enter subject name';
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _errorClassName = null;
        _errorSubjectName = null;
        _enabledClassroomName = false;
        _enabledSubjectName = false;
        _isLoading = true;
      });

      firestore.collection('classrooms').add({
        'name': _controllerClassroomName.text.trim(),
        'subject': _controllerSubjectName.text.trim(),
        'time': DateTime.now(),
        'uid': prefs.getString(SharedPrefs.uid),
        'students': _listOfStudents
            .map((e) => {
                  'name': e.name.toString(),
                  'rollno': e.rollNo,
                  'prnno': e.prnNO,
                })
            .toList()
      }).then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Classroom created!!')));
        Navigator.pop(context, () {
          setState(() {});
        });
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
        setState(() {
          _enabledClassroomName = true;
          _enabledSubjectName = true;
          _isLoading = false;
        });
      });
    }
  }
}
