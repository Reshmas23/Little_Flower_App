import 'package:adaptive_ui_layout/flutter_responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lepton_school/controllers/push_notification_controller/push_notification_controller.dart';
import 'package:lepton_school/controllers/userCredentials/user_credentials.dart';
import 'package:lepton_school/utils/utils.dart';
import 'package:lepton_school/view/colors/colors.dart';
import 'package:shimmer/shimmer.dart';

class ParentViewAllCategories extends StatelessWidget {
  final Function onTap;
  ParentViewAllCategories({super.key, required this.onTap});

  final PushNotificationController pushNotificationController =
      Get.put(PushNotificationController());


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 230,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 213, 225, 252),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: cblack.withOpacity(0.1)),
                    color: const Color.fromARGB(255, 218, 230, 247),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'QUICK ACTIONS',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 61, 203),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onTap as void Function()?,
                        child: Text(
                          "View all",
                          style: TextStyle(color: cblack.withOpacity(0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                  top: 80,
                  right: 20,
                  left: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'NOTIFICATIONS',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 11, 2, 74),
                              //const Color.fromARGB(255, 48, 88, 86),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 1.h,
                              color: const Color.fromARGB(255, 11, 2, 74)
                                  .withOpacity(0.1),
                              // const Color.fromARGB(255, 48, 88, 86).withOpacity(0.1),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  "Do you want to clear all notifications ?",
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: cblack),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await pushNotificationController
                                          .removeAllNotification();
                                    },
                                    child: const Text(
                                      "yes",
                                      style: TextStyle(color: cblack),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(
                            "Clear All",
                            style: TextStyle(color: cblack.withOpacity(0.8)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 235.h,
                      child: StreamBuilder(
                          stream: server
                              .collection('AllUsersDeviceID')
                              .doc(UserCredentialsController.parentModel?.docid??'')
                              .collection("Notification_Message")
                             . orderBy('dateTime',descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            print(UserCredentialsController.parentModel?.docid??'');
                            if (snapshot.hasData) {
                              return ListView.separated(
                                  // physics:
                                  //     const NeverScrollableScrollPhysics(),
                                  // shrinkWrap: false,
                                  itemBuilder: (context, index) {
                                    final data =
                                        snapshot.data!.docs[index].data();
                                    return InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          shape: const BeveledRectangleBorder(),
                                          context: context,
                                          builder: (context) {
                                            server
                                                .collection('AllUsersDeviceID')
                                                .doc(UserCredentialsController.currentUSerID)
                                                .collection(
                                                    "Notification_Message")
                                                .doc(data['docid'])
                                                .update({'open': true});
                                            return SingleChildScrollView(
                                              child: Container(
                                                width: double.infinity,
                                                color: Color(
                                                    data['whiteshadeColor']),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      color: Color(data[
                                                          'containerColor']),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 20),
                                                      // child: SingleChildScrollView(
                                                      //   scrollDirection: Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              IconData(
                                                                data['icon'],
                                                                fontFamily:
                                                                    'MaterialIcons',
                                                              ),
                                                              size: 25,
                                                              color: Colors.white,
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                data['headerText'],
                                                                // "Holiday", 
                                                                style: const TextStyle(
                                                                    color: cWhite,
                                                                    fontSize: 20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                     // ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 20),
                                                      child: Text(
                                                        data['messageText'],
                                                        // " Tommorow is Holiday Tommorow is Holiday Tommorow is Holiday Tommorow is Holiday",
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: const TextStyle(
                                                          fontSize: 17,
                                                          color: cWhite,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              Color(data['containerColor']),
                                          radius: 25,
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Color(
                                                  data['whiteshadeColor']),
                                              child: Center(
                                                child: Icon(
                                                  IconData(data['icon'],
                                                      fontFamily:
                                                          'MaterialIcons'),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: data['open'] == true
                                            ? Text(
                                                data['headerText'],
                                                // "Holiday",
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 48, 88, 86),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Shimmer.fromColors(
                                                baseColor: Colors.black,
                                                highlightColor: Colors.grey
                                                    .withOpacity(0.1),
                                                child: Text(
                                                  data['headerText'],
                                                  // "Holiday",
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 48, 88, 86),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                        subtitle: Text(
                                          data['messageText'],
                                          // "Tommorow is Holiday",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 48, 88, 86),
                                          ),
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                  "Do you want to remove the notification ?",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "No",
                                                      style: TextStyle(
                                                          color: cblack),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await pushNotificationController
                                                          .removeSingleNotification(
                                                              data['docid']);
                                                    },
                                                    child: const Text(
                                                      "yes",
                                                      style: TextStyle(
                                                          color: cblack),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: cblack.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox();
                                  },
                                  itemCount: snapshot.data!.docs.length);
                            } else if (snapshot.data == null) {
                              return Text(
                                "NO Notifications",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: cblack.withOpacity(0.5)),
                              );
                            } else {
                              return circularProgressIndicatotWidget;
                            }
                          }),
                    )
                  ],
                )),
          ],
        ),

        // child: const Column(
        //   children: [],
        // ),
      ),
    );
  }
}
