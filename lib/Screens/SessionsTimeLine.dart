import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ite_project/Services/reportController.dart';
import 'package:ite_project/customs/ReusableCard.dart';
import 'package:ite_project/customs/SubjectSelect.dart';
import 'package:ite_project/models/reportForm.dart';

import 'package:ite_project/models/students.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sweetalert/sweetalert.dart';
import '../constants.dart';
import 'package:ite_project/models/sessionStudents.dart';

List<String> sessions = [];
List<Students> subjectStudents = [];
List<Students> sessionStudents = [];
Map<String, List<Students>> allSessions = {};
List<Students> absenceStudents = [];
String selectedSession = 'null';
var reportPresence = 0.0;
var reportAbsence = 0.0;

class SessionsTimeLine extends StatelessWidget {
  final data = Get.arguments;
  final List<Map<String, dynamic>> _items = [];

  @override
  Widget build(BuildContext context) {
    print('${data[1]} : ${data[0]}');
    String subjectName = data[0];
    sessions = [];
    subjectStudents = [];
    sessionStudents = [];
    absenceStudents = [];
    allSessions = {};
    var _presence = 0.0.obs;
    var _absence = 0.0.obs;

    selectedSession = 'null';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سجل الجلسات',
          style: kDefaultTextStyle.copyWith(fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                Colors.teal,
              ],
            ),
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                Colors.teal,
              ],
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GetSessions((val) async {
                  selectedSession = val;
                  _presence.value = _attendanceCalc();
                  _absence.value = 1 - _presence.value;
                }, subjectName, _items),
                Row(
                  children: [
                    Expanded(
                      child: ReusableCard(
                        cardChild: _buildCardColumn(
                            Obx(
                              () => CircularPercentIndicator(
                                radius: 180.0,
                                lineWidth: 13.0,
                                animation: true,
                                curve: Curves.bounceOut,
                                percent: _absence.value,
                                animationDuration: 3000,
                                center: Obx(
                                  () => Text(
                                    "${(100 * _absence.value).round()}%",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0),
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.red,
                              ),
                            ),
                            'نسبة الغياب',
                            kDefaultTextStyle.copyWith(color: Colors.red)),
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        cardChild: _buildCardColumn(
                          Obx(
                            () => CircularPercentIndicator(
                              radius: 180.0,
                              lineWidth: 13.0,
                              animation: true,
                              percent: _presence.value,
                              curve: Curves.bounceOut,
                              animationDuration: 3000,
                              center: Obx(
                                () => Text(
                                  "${(_presence.value * 100).round()}%",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.green,
                            ),
                          ),
                          'نسبة الحضور',
                          kDefaultTextStyle.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 250,
                  child: ReusableCard(
                    onPress: () async {
                      if (selectedSession != 'null') {
                        SweetAlert.show(context,
                            title: "تأكيد حذف الجلسة",
                            subtitle: "هل تريد حذف الجلسة؟",
                            confirmButtonText: 'نعم',
                            cancelButtonText: 'لا',
                            confirmButtonColor: Color(0xff31776a),
                            cancelButtonColor: Colors.red,
                            style: SweetAlertStyle.confirm,
                            showCancelButton: true, onPress: (bool isConfirm) {
                          if (isConfirm) {
                            // return false to keep dialog
                            deleteSession();
                          }
                          return true;
                        });
                      } else {
                        SweetAlert.show(context,
                            title: "!لم يتم حذف الجلسة",
                            subtitle: "!الرجاء اختيار جلسة اولا",
                            confirmButtonText: 'حسنا',
                            confirmButtonColor: Color(0xff31776a),
                            style: SweetAlertStyle.error);
                      }
                    },
                    cardChild: _buildCardColumn(
                        Icon(
                          Icons.delete_forever,
                          size: 100,
                          color: Colors.red,
                        ),
                        'حذف الجلسة',
                        kDefaultTextStyle.copyWith(color: Colors.red)),
                  ),
                ),
                Expanded(child: Text('')),
                Container(
                    height: 100,
                    width: 250,
                    margin: EdgeInsets.only(top: 30, left: 50, right: 50),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 1,
                          spreadRadius: 0.2,
                          offset: Offset(
                              0.0, 1.0), // shadow direction: bottom right
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.teal,
                          Color(0xff31776a),
                          Colors.teal,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await createReport();
                      },
                      child: Text(
                        'طباعة تقرير',
                        style: kDefaultTextStyle.copyWith(
                            color: Colors.white70, fontSize: 25),
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Widget _buildCardColumn(Widget widget, String text, TextStyle style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget,
        Text(
          text,
          style: style,
        )
      ],
    );
  }

  Future<void> deleteSession() async {
    String subjectName = data[0];
    await FirebaseFirestore.instance
        .doc('subjects/$subjectName/sessions/$selectedSession')
        .delete()
        .then((value) => SweetAlert.show(Get.context,
                title: "!تمت العملية",
                subtitle: "!تم حذف الجلسة بنجاح",
                confirmButtonText: 'حسنا',
                confirmButtonColor: Color(0xff31776a), onPress: (value) {
              Get.back();
              return true;
            }, style: SweetAlertStyle.success))
        .catchError((error) => SweetAlert.show(Get.context,
            title: "!لم يتم حذف الجلسة",
            subtitle: "!الرجاء التاكد من الاتصال بالانترنت",
            confirmButtonText: 'حسنا',
            confirmButtonColor: Color(0xff31776a),
            style: SweetAlertStyle.error));
  }

  double _attendanceCalc({String session}) {
    int allStudents = subjectStudents.length;

    if (session != null) {
      int attendance = allSessions[session].length;

      var percent = ((100 * attendance) / allStudents) / 100;
      print(percent.toPrecision(2));
      return percent.toPrecision(2);
    }

    if (selectedSession != '0') {
      int attendance = allSessions[selectedSession].length;

      var percent = ((100 * attendance) / allStudents) / 100;
      print(percent.toPrecision(2));
      return percent.toPrecision(2);
    } else {
      var totalPresence = 0;
      allSessions.forEach((key, value) {
        totalPresence += value.length;
        print(totalPresence);
      });

      var percent =
          ((100 * (totalPresence / sessions.length)) / allStudents) / 100;
      return percent;
    }
  }

  List<SessionStudents> std(String session) {
    absenceStudents = [];
    bool found = false;

    var x = allSessions[session];
    for (int i = 0; i < subjectStudents.length; i++) {
      for (int j = 0; j < x.length; j++) {
        if (subjectStudents[i].id == x[j].id) {
          found = true;
        }
      }
      if (!found) absenceStudents.add(subjectStudents[i]);
      found = false;
    }

    List<SessionStudents> std = [];
    for (int i = 0; i < absenceStudents.length; i++) {
      std.add(SessionStudents(session, absenceStudents[i], false));
    }

    var presenceStudents = allSessions[session];
    presenceStudents.forEach((element) {
      std.add(SessionStudents(session, element, true));
    });
    return std;
  }

  void showLoading() {
    SweetAlert.show(Get.context,
        title: "!يتم الان انشاء التقرير",
        subtitle: "يرجى الانتظار",
        confirmButtonText: 'حسنا',
        confirmButtonColor: Color(0xff31776a), onPress: (value) {
      Get.back();
      return true;
    }, style: SweetAlertStyle.loading);
  }

  void showSuccess() {
    SweetAlert.show(Get.context,
        title: "!تمت العملية",
        subtitle: "!تم ارسال جميع القيم!",
        confirmButtonText: 'حسنا',
        confirmButtonColor: Color(0xff31776a), onPress: (value) {
      Get.back();
      return false;
    }, style: SweetAlertStyle.success);
  }

  void showError() {
    SweetAlert.show(Get.context,
        title: "خطأ",
        subtitle: "!الرجاء اختيار احدى الجلسات",
        confirmButtonText: 'حسنا',
        confirmButtonColor: Color(0xff31776a), onPress: (value) {
      Get.back();
      return false;
    }, style: SweetAlertStyle.error);
  }

  // Future<void> sessionReport(String session) async {
  //   String subjectName = data[0];
  //   String teacherName = data[1];
  //   reportPresence = _attendanceCalc(session: session);
  //   reportAbsence = 1 - reportPresence;
  //   var z = std(session);
  //   var controller = ReportController((value) {});
  //   for (int i = 0; i < z.length; i++) {
  //     var x = ReportForm(
  //         teacherName,
  //         subjectName,
  //         z[i],
  //         "${(reportPresence * 100).round()}%",
  //         "${(100 * reportAbsence).round()}%");
  //     print('${x.student.student.id}   ${x.student.student.year}');
  //     await controller.submitReport(x);
  //     sleep(Duration(milliseconds: 50));
  //   }
  // }

  Future<void> sessionReport(String session, {int counter, bool clear}) async {
    if (counter == null) counter = 2;
    if (clear == null) clear = true;
    String subjectName = data[0];
    String teacherName = data[1];
    reportPresence = _attendanceCalc(session: session);
    reportAbsence = 1 - reportPresence;
    var z = std(session);
    var controller = ReportController();
    for (int i = 0; i < z.length; i++) {
      var x = ReportForm(
          teacherName,
          subjectName,
          z[i],
          "${(reportPresence * 100).round()}%",
          "${(100 * reportAbsence).round()}%");

      await controller.submitReport(counter++, x, clear: clear);
    }
  }

  Future<void> allSessionsReport() async {
    int _counter = 2;
    var z = std(sessions[0]);
    bool clear = false;
    for (int i = 0; i < sessions.length; i++) {
      if (i == 0) {
        clear = true;
      } else {
        _counter = _counter + z.length;
        clear = false;
      }
      await sessionReport(sessions[i], counter: _counter, clear: clear);
    }
  }

  Future<void> createReport() async {
    if (selectedSession == 'null') {
      showError();
      return;
    }
    showLoading();
    if (selectedSession != '0') {
      await sessionReport(selectedSession);
      showSuccess();
    } else {
      await allSessionsReport();
      showSuccess();
    }
  }
}

class GetSessions extends StatelessWidget {
  final Function onChanged;
  final String subjectName;
  final items;
  GetSessions(this.onChanged, this.subjectName, this.items);

  Future<void> getSessions() async {
    sessions = [];
    await FirebaseFirestore.instance
        .collection('subjects/$subjectName/sessions')
        .orderBy('date', descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        items.add({
          'value': doc["name"],
          'label': doc["name"],
          'icon': Icon(Icons.stop),
          'textStyle': kSelectMenuStyle,
        });
        sessions.add(doc["name"]);
      });
    });
    if (sessions.length > 1)
      items.insert(0, {
        'value': '0',
        'label': 'كل الجلسات',
        'icon': Icon(Icons.stop),
        'textStyle': kSelectMenuStyle,
      });
  }

  Future<void> getSubjectStudents() async {
    subjectStudents = [];
    await FirebaseFirestore.instance
        .collection('subjects/$subjectName/students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        subjectStudents.add(
            Students(id: doc['number'], name: doc['name'], year: doc['year']));
      });
    });
  }

  Future<void> getSessionStudent(String sessionName) async {
    sessionStudents = [];
    await FirebaseFirestore.instance
        .collection('subjects/$subjectName/sessions/$sessionName/students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        sessionStudents.add(
            Students(id: doc['number'], name: doc['name'], year: doc['year']));
      });
    });
  }

  Future<void> getStudentsSessionsMap() async {
    await getSessions();
    allSessions = {};
    for (int i = 0; i < sessions.length; i++) {
      await getSessionStudent(sessions[i]);
      allSessions[sessions[i]] = sessionStudents;
    }
  }

  Future<dynamic> getData() async {
    await getSubjectStudents();
    await getStudentsSessionsMap();
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(subjectName);
        if (snapshot.hasError) {
          return Text(
            'يتم الان التحميل',
            textAlign: TextAlign.center,
            style: kDefaultTextStyle,
          );
        }

        if (!snapshot.hasData) {
          return Text(
            'يتم الان التحميل',
            textAlign: TextAlign.center,
            style: kDefaultTextStyle,
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return SubjectSelect(
            title: 'اختر الجلسة',
            items: snapshot.data,
            onChanged: onChanged,
          );
        }

        return Text(
          "جاري التحميل",
          style: kDefaultTextStyle,
        );
      },
    );
  }
}
