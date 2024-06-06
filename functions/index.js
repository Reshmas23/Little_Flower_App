/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
// eslint-disable-next-line no-unused-vars
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const fetch = require("node-fetch");
const {format} = require("date-fns");
admin.initializeApp();
const db = admin.firestore();
const dateConvert = (dateTime) => format(dateTime, "dd-MM-yyyy");
const timeConvert = (dateTime) => format(dateTime, "hh:mm:a");


const sendPushMessage = async (token, body, title) => {
  try {
    const response = await fetch("https://fcm.googleapis.com/fcm/send", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        // eslint-disable-next-line max-len
        "Authorization": "key=AAAAT5j1j9A:APA91bEDY97KTVTB5CH_4YTnLZEol4Z5fxF0fmO654V7YJO6dL9TV_PyIfv64-pVDx477rONsIl8d63VjxT793_Tj4zuGg32JTy_wUNQ4OhGNbr0KOS2i4z7JaG-ZtENTBpYnEGh-ZLg",
      },
      body: JSON.stringify({
        priority: "high",
        data: {
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          status: "done",
          body: body,
          title: title,
        },
        notification: {
          title: title,
          body: body,
          android_channel_id: "high_importance_channel",
        },
        to: token,
      }),
    });

    const responseData = await response.json();
    console.log("Push notification response:", responseData);
  } catch (error) {
    console.error("Error sending push notification:", error);
  }
};

// Function to fetch parents data and send notifications
const fetchParents = async (parentID, studentName) => {
  try {
    const parentDoc = await db.collection("SchoolListCollection")
        .doc("MsRK8bvGM7hvpoXAvtbVo3KsB6H2")
        .collection("AllUsersDeviceID")
        .doc(parentID)
        .get();
    const parentData = parentDoc.data();
    await sendPushMessage(
        parentData["devideID"],
        // eslint-disable-next-line max-len
        `Sir/Madam, your child ${studentName} was present on ${dateConvert(new Date())} at ${timeConvert(new Date())} \nസർ/മാഡം,${dateConvert(new Date())} തീയതി ${timeConvert(new Date())}നിങ്ങളുടെ കുട്ടി ഹാജരായി`,
        "Attendance Notification from Little Flower",
    ).then(() => {
      db.collection("Attendance")
          .doc("MsRK8bvGM7hvpoXAvtbVo3KsB6H2")
          .update({CardID: "", AttendanceTaken: "false"});
    });
  } catch (error) {
    console.error("Error fetching parents data:", error);
  }
};

// Function to fetch student data based on card ID
const fetchCardDataStudents = async (cardID) => {
  try {
    const studentsSnapshot = await db.collection("SchoolListCollection")
        .doc("MsRK8bvGM7hvpoXAvtbVo3KsB6H2")
        .collection("AllStudents")
        .get();

    for (const studentDoc of studentsSnapshot.docs) {
      const studentData = studentDoc.data();
      if (studentData["cardID"] === cardID) {
        await fetchParents(studentData["parentId"], studentData["studentName"]);
      }
    }
  } catch (error) {
    console.error("Error fetching card data students:", error);
  }
};

// Firestore trigger to listen for changes in the Attendance document
exports.attendanceListener =
 onDocumentUpdated("Attendance/MsRK8bvGM7hvpoXAvtbVo3KsB6H2", async (event) => {
   try {
     const attendanceDoc = await db.collection("Attendance")
         .doc("MsRK8bvGM7hvpoXAvtbVo3KsB6H2")
         .get();

     const cardIDvalue = attendanceDoc.data()["CardID"];
     if (cardIDvalue!== "") {
       await db.collection("Attendance")
           .doc("MsRK8bvGM7hvpoXAvtbVo3KsB6H2")
           .update({CardID: cardIDvalue});
       await fetchCardDataStudents(cardIDvalue);
     }
   } catch (error) {
     console.error("Error fetching attendance document:", error);
   }
 });
