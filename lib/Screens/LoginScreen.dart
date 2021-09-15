import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:ite_project/Screens/MainScreen.dart';
import 'package:ite_project/constants.dart';
import 'package:ite_project/models/Teachers.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

var users = {'Hunter': 'Hunter'};
bool _saving = true;
List<Teachers> teachers = [];
List<String> userData = [];

class LoginScreen extends StatelessWidget {
  String formFieldValidator<String>(String s) {
    return null;
  }

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    teachers.forEach((element) {
      print(element.password);
    });
    return Future.delayed(loginTime).then((_) {
      for (var user in teachers) {
        if (data.name == user.username && data.password == user.password) {
          userData = [user.name, user.username, user.password];
          return null;
        }
      }
      return '!خطأ في اسم المستخدم او كلمة المرور';
    });
  }

  Future<String> nextScreen(LoginData data) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getUsersDetails(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'حدث خطأ ما الرجاء التاكد من الاتصال بالشبكة',
                  textAlign: TextAlign.center,
                  style: kDefaultTextStyle,
                ),
              ),
            ],
          );
        }

        if (!snapshot.hasData) {
          return ModalProgressHUD(
            inAsyncCall: _saving,
            child: Container(
              width: 50,
              height: 50,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _saving = false;
          _autoSignIn();
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  'S.A.M.S',
                  style: kDefaultTextStyle.copyWith(
                      color: Colors.white, fontSize: 25),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white,
                        Colors.teal.shade900,
                      ],
                    ),
                  ),
                ),
                centerTitle: true,
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
                child: FlutterLogin(
                  theme: LoginTheme(
                    primaryColor: Colors.teal,
                    pageColorDark: Colors.teal,
                    pageColorLight: Colors.white,
                    accentColor: Colors.teal,
                    errorColor: Colors.green,
                    textFieldStyle: kDefaultTextStyle.copyWith(fontSize: 13),
                    buttonStyle: kDefaultTextStyle.copyWith(
                        fontSize: 15, color: Colors.white),
                  ),
                  onRecoverPassword: (s) async {
                    return "";
                  },
                  logo: 'assets/images/logo.png',
                  onLogin: _authUser,
                  onSignup: _authUser,
                  emailValidator: formFieldValidator,
                  passwordValidator: formFieldValidator,
                  hideSignUpButton: true,
                  hideForgotPasswordButton: true,
                  onSubmitAnimationCompleted: () {
                    _saveUserInfo(userData[0], userData[1], userData[2]);
                    Get.off(() => MainScreen(), arguments: userData);
                  },
                  messages: LoginMessages(
                      usernameHint: 'اسم المستخدم',
                      passwordHint: 'كلمة المرور',
                      confirmPasswordHint: 'تاكيد',
                      loginButton: 'تسجيل الدخول',
                      flushbarTitleError: '!خطأ'),
                ),
              ));
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'يتم الان التحميل',
              textAlign: TextAlign.center,
              style: kDefaultTextStyle,
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> getUsersDetails() async {
    List<Teachers> teacher = [];
    await FirebaseFirestore.instance
        .collection('teachers')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        teacher.add(Teachers(
            name: doc['name'],
            username: doc['username'],
            password: doc['password']));
      });
    });
    teacher.forEach((element) {
      teachers.add(element);
    });
    return teacher;
  }

  _saveUserInfo(String name, String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  _autoSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    String username = prefs.getString('username');
    String password = prefs.get('password');
    List<String> nameList = [name];
    if (username != null && password != null)
      Get.off(() => MainScreen(), arguments: nameList);
  }
}
