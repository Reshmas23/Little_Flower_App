// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lepton_school/controllers/userCredentials/user_credentials.dart';
import 'package:lepton_school/utils/utils.dart';
import 'package:lepton_school/view/home/all_class_test_show/all_class_list_show.dart';
import 'package:lepton_school/view/home/bus_route_page/all_bus_list.dart';
import 'package:lepton_school/view/home/events/event_list.dart';
import 'package:lepton_school/view/home/student_home/time_table/ss.dart';
import 'package:lepton_school/view/pages/exam_results/for_users/select_examlevel_uses.dart';

import '../../../pages/Homework/view_home_work.dart';
import '../../../pages/Meetings/Tabs/school_level_meetings_tab.dart';
import '../../../pages/Notice/notice_list.dart';
import '../../../pages/Subject/subject_display.dart';
import '../../../pages/attendence_book/attendence_book_status_month.dart';
import '../../../pages/chat/student_section/student_chat_screen.dart';
import '../../../pages/teacher_list/teacher_list.dart';
import '../../all_class_test_monthly_show/all_class_list_monthly_show.dart';
import '../../exam_Notification/users_exam_list_view/user_exam_acc.dart';

class StudentAccessories extends StatefulWidget {
  const StudentAccessories({
    super.key,
  });

  @override
  State<StudentAccessories> createState() => _StudentAccessoriesState();
}

class _StudentAccessoriesState extends State<StudentAccessories> {
  @override
  Widget build(BuildContext context) {
    log(
      UserCredentialsController.studentModel!.docid,
    );
    final screenNavigation = [
      AttendenceBookScreenSelectMonth(
          schoolId: UserCredentialsController.schoolId!,
          batchId: UserCredentialsController.batchId!,
          classID: UserCredentialsController.classId!), //Attendence

      const TimeTable(), //Time table

      const StudentChatScreen(), // Chats

      const ViewHomeWorks(), // Home Works

      const StudentSubjectScreen(), //Subjects

      const TeacherSubjectWiseList(navValue: 'student'), //Teachers

      const UserExmNotifications(), //Exam

      UsersSelectExamLevelScreen(
          classID: UserCredentialsController.classId!,
          studentId:
              UserCredentialsController.studentModel!.docid), ////// exam result
      NoticePage(), //Notice
      const EventList(), //Events
      // ProgressReportListViewScreen(
      //     schoolId: UserCredentialsController.schoolId!,
      //     classID: UserCredentialsController.classId!,
      //     studentId: FirebaseAuth.instance.currentUser!.uid,
      //     batchId: UserCredentialsController.batchId!), //Progress Report

      SchoolLevelMeetingPage(), //Meetings
      BusRouteListPage(),
      AllClassTestPage(
        pageNameFrom: "student",
      ), //class test page
      AllClassTestMonthlyPage(
        pageNameFrom: "student",
      ),
      // HostelHomePage(),
    ];
    int columnCount = 2;
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    return Expanded(
        child: AnimationLimiter(
      child: GridView.count(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.all(_w / 60),
        crossAxisCount: columnCount,
        children: List.generate(
          _acc_images.length,
          (int index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 300),
              columnCount: columnCount,
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 900),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return  screenNavigation[index];
                  },));
                       // Get.off(() => screenNavigation[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        height: _h / 100,
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            top: _w / 30, left: _w / 30, right: _w / 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height: 75,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(_acc_images[index]),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              translateString(_acc_text[index]),
                              style: GoogleFonts.montserrat(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}

List<String> _acc_text = [
  'Attendance'.tr,
  'Time Table'.tr,
  'Chats'.tr,
  'HomeWorks'.tr,
  'Subjects'.tr,
  'Teachers'.tr,
  'Exams'.tr,
  'Exam Results'.tr,
  'Notices'.tr,
  'Events'.tr,
  // 'Progress Report'.tr,
  'Meetings'.tr,
  'Bus Route'.tr,
  'Class Test'.tr,
  'Monthly Class Test'.tr,
  // 'Hostel',
];
var _acc_images = [
  'assets/images/attendance.png',
  'assets/images/library.png',
  'assets/images/chat.png',
  'assets/images/homework.png',
  'assets/images/subjects.png',
  'assets/images/teachers.png',
  'assets/images/exam.png',
  'assets/images/exmresult1.png',
  'assets/images/notices.png',
  'assets/images/activity.png',
  // 'assets/images/progressreport.png',
  'assets/images/meetings.png',
  'assets/images/bus.png',
  'assets/images/examtest.png',
  'assets/images/test.png',
  // 'assets/images/hostel.png',
];
