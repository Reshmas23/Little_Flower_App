import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lepton_school/model/parent_model/parent_model.dart';
import 'package:lepton_school/view/pages/splash_screen/splash_screen.dart';

import '../../helper/shared_pref_helper.dart';
import '../../utils/utils.dart';
import '../userCredentials/user_credentials.dart';

class ParentLoginController extends GetxController {
  RxBool isLoading = RxBool(false);
  TextEditingController emailIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    try {
      isLoading.value = true;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailIdController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) async {
        log('parent auth success.............');
        //fetching parent data from firebase
        final DocumentSnapshot<Map<String, dynamic>> parentData =
            await FirebaseFirestore.instance
                .collection('SchoolListCollection')
                .doc(UserCredentialsController.schoolId)
                .collection(UserCredentialsController.batchId ?? "")
                .doc(UserCredentialsController.batchId)
                .collection('classes')
                .doc(UserCredentialsController.classId)
                .collection('Parents')
                .doc(value.user?.uid)
                .get();
        log(parentData.data().toString());

        if (parentData.data() != null) {
          UserCredentialsController.parentModel = ParentModel.fromMap(
            parentData.data()!,
          );
        }
        if (UserCredentialsController.parentModel?.userRole == "parent") {
          //assigining shared preference user role for app close
          await SharedPreferencesHelper.setString(
              SharedPreferencesHelper.currenUserKey, value.user!.uid);
          await SharedPreferencesHelper.setString(
                  SharedPreferencesHelper.userRoleKey, 'parent')
              .then((value) => Get.off(() => const SplashScreen()));
          // if (context.mounted) {
          //   ParentPasswordSaver.parentPassword = passwordController.text.trim();
          //   ParentPasswordSaver.parentemailID = emailIdController.text.trim();

          //   Navigator.pushAndRemoveUntil(context,
          //       MaterialPageRoute(builder: (context) {
          //     return const ParentMainHomeScreen();
          //   }), (route) => false);
          // }
          isLoading.value = false;
        } else {
          showToast(
            msg: "Access denied since you are not a parent",
          );
          isLoading.value = false;
        }
      }).catchError((error) {
        if (error is FirebaseAuthException) {
          isLoading.value = false;
          handleFirebaseError(error);
        }
      });
    } catch (e) {
      isLoading.value = false;
      showToast(msg: "Sign in failed");
    }
  }
}
