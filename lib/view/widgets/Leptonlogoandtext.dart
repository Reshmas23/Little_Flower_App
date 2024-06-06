// ignore_for_file: camel_case_types, file_names

import 'package:adaptive_ui_layout/flutter_responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:lepton_school/info/info.dart';
import 'package:lepton_school/view/colors/colors.dart';
import 'package:lepton_school/view/widgets/container_image.dart';
import 'package:lepton_school/view/widgets/fonts/google_poppins.dart';

class leptonDujoWidget extends StatelessWidget {
  const leptonDujoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ContainerImage(
            height: 60.h,
            width: 60.w,
            imagePath: 'assets/images/leptonlogo.png'),
        GooglePoppinsWidgets(
          text: nameOfInstitution,
          fontsize: 15,
          color: cred,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
