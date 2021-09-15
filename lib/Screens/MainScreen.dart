import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ite_project/Screens/LoginScreen.dart';
import 'package:ite_project/Screens/NewSession.dart';
import 'package:ite_project/Screens/SessionsTimeLine.dart';
import 'package:ite_project/customs/ReusableCard.dart';
import 'package:ite_project/customs/SubjectSelect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import '../constants.dart';

final List<Map<String, dynamic>> _items = [];

class MainScreen extends StatelessWidget {
  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    _items.clear();
    final teacherName = data[0];
    String subject = 'null';
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffE1E1E1),
        body: Container(
          margin: EdgeInsets.only(top: 20),
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
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              GetSubjects((val) {
                subject = val;
                print(subject);
              }, teacherName),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 2,
                      child: ReusableCard(
                          cardChild:
                              _buildCardColumn(Icons.add_box, 'جلسة جديدة'),
                          onPress: () {
                            subject != 'null'
                                ? Get.to(() => NewSession(), arguments: subject)
                                : SweetAlert.show(context,
                                    title: "!خطأ",
                                    subtitle: "رجاء قم باختيار مادة اولا",
                                    confirmButtonText: 'حسنا',
                                    confirmButtonColor: Color(0xff31776a),
                                    style: SweetAlertStyle.error);
                          }),
                    ),
                    Flexible(
                      child: ReusableCard(
                        onPress: () {
                          subject != 'null'
                              ? Get.to(() => SessionsTimeLine(),
                                  arguments: [subject, teacherName])
                              : SweetAlert.show(context,
                                  title: "!خطأ",
                                  subtitle: "رجاء قم باختيار مادة اولا",
                                  confirmButtonText: 'حسنا',
                                  confirmButtonColor: Color(0xff31776a),
                                  style: SweetAlertStyle.error);
                        },
                        cardChild:
                            _buildCardColumn(Icons.history, 'سجل الجلسات'),
                      ),
                    ),
                    Container(
                        height: 100,
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
                            //TODO add sign out here !
                            //
                            SweetAlert.show(context,
                                title: "تأكيد تسجيل الخروج",
                                subtitle: "هل تريد تسجيل الخروج؟",
                                confirmButtonText: 'نعم',
                                cancelButtonText: 'لا',
                                confirmButtonColor: Color(0xff31776a),
                                cancelButtonColor: Colors.red,
                                style: SweetAlertStyle.confirm,
                                showCancelButton: true,
                                onPress: (bool isConfirm) {
                              if (isConfirm) {
                                SweetAlert.show(
                                  context,
                                  style: SweetAlertStyle.success,
                                  title: "تم تسجيل الخروج!",
                                  confirmButtonColor: Color(0xff31776a),
                                  confirmButtonText: 'نعم',
                                );
                                // return false to keep dialog

                                _signOut();
                              }
                              return true;
                            });
                          },
                          child: Text(
                            'تسجيل الخروج',
                            style: kDefaultTextStyle.copyWith(
                                fontSize: 30, color: Colors.white70),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildCardColumn(IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Color(0xff31776a),
          size: 100,
        ),
        Text(
          text,
          style: kDefaultTextStyle,
        )
      ],
    );
  }

  _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('username');
    await prefs.remove('password');
    Get.off(() => LoginScreen());
  }
}

class GetSubjects extends StatelessWidget {
  final Function onChanged;
  final String teacherName;
  GetSubjects(this.onChanged, this.teacherName);
  Future<dynamic> getData() async {
    await FirebaseFirestore.instance
        .collection('subjects')
        .where('teacher', isEqualTo: '$teacherName')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['name'] != null) {
          _items.add({
            'value': doc["name"],
            'label': doc["name"],
            'icon': Icon(Icons.stop),
            'textStyle': kSelectMenuStyle,
          });
        }
      });
    });
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
            title: 'اختر المادة',
            items: snapshot.data,
            onChanged: onChanged,
          );
        }

        return Text("loading");
      },
    );
  }
}
