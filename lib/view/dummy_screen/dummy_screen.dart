import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lepton_school/controllers/attendence_controller/attendence_controller.dart';

class DummyScreen extends StatelessWidget {
   DummyScreen({super.key});
  final AttendanceController attendanceController =
      Get.put(AttendanceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(onPressed: ()async{
              attendanceController.sendPushMessage(
        'cF7-hHFwSZmJ0gPoqDY1yN:APA91bGTKcvdHSvehu0ia_l5XfAXcs_58YNGgGZU62QhvysNuwHBlo0n_VghPyEeRLiyinO2PmSAwFo4PvwspWDdJuXh2eXopXCkL2W2j1pKOayOmx6Dbb_4QzK3d64IkG4cIuG9J5kj',
        "body",
        "title");
        }, icon:const Icon(Icons.abc)),
      ),
    );
  }
}