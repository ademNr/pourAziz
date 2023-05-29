// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/commun/text_style.dart';
import 'package:get/get.dart';

import '../../controller/homecontroller.dart';
import '../../model/commun/decoration.dart';
import 'signin_screen.dart';

class RestPassword extends StatefulWidget {
  const RestPassword({Key? key}) : super(key: key);

  @override
  State<RestPassword> createState() => _RestPasswordState();
}

class _RestPasswordState extends State<RestPassword> {
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mwd = MediaQuery.of(context).size.width;
    var mhd = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: mhd,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/bg_login.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 100, left: 20),
                    child: Text(
                      'Reset Your Password',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                          fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Email',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: formstate,
                      child: GetBuilder<homecontroller>(
                        init: homecontroller(),
                        builder: (controller) => Column(
                          children: [
                            TextFormField(
                              controller: email,
                              decoration: decoration_input_txt().deco(
                                  Icon(Icons.email), "Enter your email", 20.0),
                              validator: (value) {
                                if (value!.isEmpty || !isValidEmail(value)) {
                                  return "your email please";
                                }
                              },
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color.fromARGB(255, 252, 252, 252),
                            backgroundColor: Color.fromARGB(255, 47, 176, 58),
                            fixedSize: const Size(200, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            var formdata = formstate.currentState;
                            if (formdata!.validate()) {}
                            /*  await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email)
                                .then((value) => Navigator.of(context).pop());*/
                            print(email);
                          },
                          child: Text(
                            'Send Request',
                            style: TextStyle(fontSize: 17),
                          ))),
                ]),
          ],
        ),
      ),
    );
  }
}
