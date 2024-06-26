import 'package:adaptive_ui_layout/flutter_responsive_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lepton_school/controllers/userCredentials/user_credentials.dart';
import 'package:lepton_school/view/colors/colors.dart';
import 'package:lepton_school/view/constant/sizes/sizes.dart';
import 'package:lepton_school/view/widgets/appbar_color/appbar_clr.dart';
import 'package:lepton_school/view/widgets/fonts/google_poppins.dart';

import '../../../controllers/general_instructions/general_instructions_controller.dart';

class GeneralInstruction extends StatelessWidget {
  GeneralInstruction({
    super.key,
  });

  final GeneralInstructionsController generalInstructionsController =
      Get.put(GeneralInstructionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const AppBarColorWidget(),
        foregroundColor: cWhite,
        //backgroundColor: adminePrimayColor,
        title: GooglePoppinsWidgets(
            text: "General Instructions".tr, fontsize: 20.h),
      ),
      body: StreamBuilder(
          stream:FirebaseFirestore.instance
          .collection('SchoolListCollection')
                            .doc(UserCredentialsController.schoolId)
                            .collection(UserCredentialsController.batchId!)
                            .doc(UserCredentialsController.batchId!)
                            .collection('Admin_general_instructions')
                            .snapshots(),
          // generalInstructionsController.getInstruction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          // ignore: prefer_is_empty
                          if (snapshot.data!.docs.length == 0) {
                            return Center(
                                child: Text(
                              'No General_instructions',
                              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
                            ));
                          }
                          return 
                    ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Container(
                            height: 200,
                            color: Colors.lightBlue[900],
                            child: Stack(children: [
                              Opacity(
                                  opacity: 0.5,
                                  child: ClipPath(
                                    clipper: WaveClipper(),
                                    child: Container(
                                      color: Colors.white,
                                      height: 150,
                                    ),
                                  )),
                              ClipPath(
                                clipper: WaveClipper(),
                                child: Container(
                                  color: Colors.blueGrey,
                                  height: 130,
                                  alignment: Alignment.bottomCenter,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  maxRadius: 40,
                                ),
                              ),
                              Obx(() => Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        generalInstructionsController
                                            .schoolName.value,
                                        style: GoogleFonts.adamina(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  )),
                            ]),
                          ),
                          kHeight40,
                          Center(
                              child: Text(
                            "General Instructions",
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                decoration: TextDecoration.underline),
                          )),
                          kHeight20,
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 20),
                            child: SingleChildScrollView(
                              child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        const SizedBox(width: 10),
                                        Row(children: [
                                          Icon(
                                            Icons.circle,
                                            size: 8.h,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.h),
                                              child: Text(
                                                snapshot.data!.docs[index]['instruction'],
                                                   // .instruction,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18),
                                                softWrap: true,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return kHeight20;
                                  },
                                  itemCount:  snapshot.data!.docs.length),
                            ),
                          ),
                          kHeight20,
                          Container(
                            width: double.infinity,
                            color: adminePrimayColor,
                            child: const Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(" "),
                                )),
                          )
                        ],
                      );
          }
                      ),
       //   }),
    );
  }
}

class InstructionTextWidget extends StatelessWidget {
  const InstructionTextWidget({
    super.key,
    required this.text,
    required this.count,
  });
  final String text;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Flexible(
        child: Text(
          "$count.  $text",
          style: GoogleFonts.openSans(fontSize: 18),
          softWrap: true,
        ),
      ),
    ]);
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    {
      debugPrint(size.width.toString());
      var path = Path();
      path.lineTo(0, size.height);
      var firstStart = Offset(size.width / 5, size.height);
      //first point
      var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
      //second point
      path.quadraticBezierTo(
          firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
      var secondStart =
          Offset(size.width - (size.width / 3.24), size.height - 105);
      //third
      var secondEnd = Offset(size.width, size.height - 10);
      //fourth
      path.quadraticBezierTo(
          secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
      //
      path.lineTo(size.width, 0);
      path.close();
      return path;
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
