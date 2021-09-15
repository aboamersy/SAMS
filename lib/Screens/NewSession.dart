import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ite_project/constants.dart';
import 'package:ite_project/customs/ReusableCard.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:ite_project/customs/StudentsSelect.dart';
import 'package:ite_project/models/students.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ite_project/Services/FirebaseNetworking.dart';
import 'package:sweetalert/sweetalert.dart';

Map<String, dynamic> sessionRecord = {
  'date': FieldValue.serverTimestamp(),
};

class NewSession extends StatelessWidget {
  final data = Get.arguments;
  final List<MultiSelectItem<Students>> _items = [];
  final List<Students> selectedStudents = [];

  String getDate() {
    DateTime now = new DateTime.now();
    DateTime date =
        new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    return date.toString();
  }

  @override
  Widget build(BuildContext context) {
    getStudents();
    var date = getDate();
    date = date.substring(0, 16);

    return Scaffold(
      appBar: AppBar(
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
        leading: Container(),
        centerTitle: true,
        title: Text(
          'جلسة جديدة ',
          style: kDefaultTextStyle.copyWith(fontSize: 25, color: Colors.white),
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
        child: Column(
          children: [
            Expanded(
              flex: 16,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  //Date Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.white54, Colors.white70],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        size: 30,
                        color: Color(0xff343a40),
                      ),
                      title: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '$date',
                            textStyle: kDefaultTextStyle.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                            speed: const Duration(milliseconds: 500),
                          ),
                        ],
                        repeatForever: true,
                        pause: const Duration(milliseconds: 500),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  StudentsSelect(
                      items: _items,
                      onConfirm: (items) {
                        for (var s in items) {
                          var student =
                              Students(id: s.id, name: s.name, year: s.year);
                          selectedStudents.add(student);
                        }
                      }),

                  Expanded(flex: 10, child: Text('')),
                  //Divider

                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableCard(
                            onPress: () => Get.back(),
                            cardChild: _buildCardColumn(
                                Icons.highlight_off, 'الغاء الجلسة'),
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            cardChild:
                                _buildCardColumn(Icons.done, 'انشاء الجلسة'),
                            onPress: () async {
                              if (selectedStudents.length > 0) {
                                try {
                                  await addSession();
                                } catch (e) {
                                  SweetAlert.show(context,
                                      title: "!لم يتم انشاء الجلسة",
                                      subtitle:
                                          "!الرجاء التاكد من الاتصال بالانترنت",
                                      confirmButtonText: 'حسنا',
                                      confirmButtonColor: Color(0xff31776a),
                                      style: SweetAlertStyle.error);
                                  return;
                                }
                                //show success here
                                SweetAlert.show(context,
                                    title: "!تمت العملية",
                                    subtitle: "!تم انشاء الجلسة بنجاح",
                                    confirmButtonText: 'حسنا',
                                    confirmButtonColor: Color(0xff31776a),
                                    onPress: (value) {
                                  Get.back();
                                  return true;
                                }, style: SweetAlertStyle.success);
                              } else {
                                SweetAlert.show(context,
                                    title: "!لم يتم انشاء الجلسة",
                                    subtitle:
                                        "!الرجاء اختيار طالب واحد على الاقل",
                                    confirmButtonText: 'حسنا',
                                    confirmButtonColor: Color(0xff31776a),
                                    style: SweetAlertStyle.error);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value);
        });
  }

  Widget _buildCardColumn(IconData icon, String text) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.teal,
          size: 40,
        ),
        Text(
          text,
          style: kDefaultTextStyle.copyWith(fontSize: 20, color: Colors.teal),
        )
      ],
    );
  }

  Future<void> addSession() async {
    var date = getDate();
    date = date.substring(0, 16);
    sessionRecord['name'] = date;
    FirebaseNetworkings(rootCollection: '$data/sessions')
        .addDocument('$date', sessionRecord);

    if (selectedStudents.length > 0)
      for (var s in selectedStudents) {
        FirebaseNetworkings(rootCollection: '$data/sessions/$date/students')
            .addDocument(s.id, s.studentsMap());
      }
  }

  Future<dynamic> getStudents() async {
    var x = await FirebaseFirestore.instance
        .collection('subjects/$data/students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['name'] != null) {
          _items.add(MultiSelectItem(
              Students(id: doc['number'], name: doc['name'], year: doc['year']),
              doc['name']));
        }
      });
    });
    return x;
  }
}
