import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_academy/config/InputField.dart';
import 'package:expert_academy/config/const.dart';
import 'package:expert_academy/models/userModel.dart';
import 'package:expert_academy/provider/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../config/primaryButton.dart';

class Signin_Page extends StatefulWidget {
  const Signin_Page({Key? key}) : super(key: key);

  @override
  State<Signin_Page> createState() => _Signin_PageState();
}

class _Signin_PageState extends State<Signin_Page> {
  String? errorMessage;
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();

  // Sign in
  Future<void> signin() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  // Sign up
  Future<void> signup() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final user = UserModel(
      id: docUser.id,
      email: _controllerEmail.text,
      name: _controllerUsername.text,
      score: 0,
    );
    final json = user.toJson();

    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      await docUser.set(json);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _submitButton() {
    return PrimaryButton(
      tap: isLogin ? signin : signup,
      title: isLogin ? 'تسجيل الدخول' : 'انشاء حساب',
      color: MyColors().mainColor,
      textColor: MyColors().headTextColor,
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin ? 'لا تمتلك حساب؟ انشاء حساب' : 'تمتلك حساب؟ تسجيل الدخول',
        style: MyStyles.smallTextStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Title
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                "أهلا بك في Expert Academy!",
                style: MyStyles.headTextStyle,
              ),
            ),

            // Input fields
            Container(
              margin: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLogin
                      ? Container()
                      : Column(
                          children: [
                            InputField(
                              controller: _controllerUsername,
                              title: "اسم المستخدم",
                              isPassword: false,
                              icon: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                  InputField(
                    controller: _controllerEmail,
                    title: "البريد الالكتروني",
                    isPassword: false,
                    icon: const Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    controller: _controllerPassword,
                    title: "كلمة المرور",
                    isPassword: true,
                    icon: const Icon(
                      Icons.password,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Signin Button
            Column(
              children: [
                _submitButton(),
                _loginOrRegisterButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
