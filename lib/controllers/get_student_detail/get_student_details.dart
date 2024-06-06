import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lepton_school/controllers/userCredentials/user_credentials.dart';

class StudentController extends GetxController {
  RxString studentName = ''.obs;
  Future<void> getTeacherClassRoll(String studentId) async {
    var vari = await FirebaseFirestore.instance
        .collection("SchoolListCollection")
        .doc(UserCredentialsController.schoolId)
        .collection("AllStudents")
        .doc(studentId)
        .get();
    studentName.value = vari.data()?['studentName'];
  }
}
