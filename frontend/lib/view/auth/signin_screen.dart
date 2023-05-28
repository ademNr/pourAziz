// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../controller/homecontroller.dart';
import '../../model/commun/decoration.dart';
import '../../model/commun/text_style.dart';

bool isValidEmail(String email) {
  final RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return regExp.hasMatch(email);
}

// ignore: camel_case_types
class singe extends StatefulWidget {
  const singe({super.key});

  @override
  State<singe> createState() => _singeState();
}

bool x = false;
bool p = true;

// ignore: camel_case_types
class _singeState extends State<singe> {
  // ignore: unnecessary_new
  TextEditingController username = new TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passeword = TextEditingController();
  TextEditingController phone = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    var mwd = MediaQuery.of(context).size.width;
    var mhd = MediaQuery.of(context).size.height;
    var inputDecoration = InputDecoration(
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(
          p ? Icons.visibility : Icons.visibility_off,
          color: const Color.fromARGB(255, 251, 0, 0),
        ),
        onPressed: () {
          setState(() {
            p = !p;
          });
        },
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      hintText: 'Enter your password',
    );
    return Scaffold(
        body: Stack(
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
        Center(
            child: Container(
          width: 350,
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 300),
                      child: textstyle().textStyle("Create Account",
                          Color.fromARGB(255, 0, 0, 0), 30, FontWeight.bold)),
                  Form(
                      key: formstate,
                      child: GetBuilder<homecontroller>(
                        init: homecontroller(),
                        builder: (controller) => Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: username,
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value.length < 3 ||
                                    value.length > 7) {
                                  return "your name please";
                                }
                              },
                              decoration: decoration_input_txt().deco(
                                  Icon(Icons.person), "Enter your name", 20.0),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
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
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              maxLength: 8,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                if (value.length == 8) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              validator: (value) {
                                if (value?.length != 8) {
                                  return "le num incorect";
                                }

                                return null;
                              },
                              decoration: decoration_input_txt().deco(
                                  Icon(Icons.phone), "Enter your phone", 20.0),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: passeword,
                              obscureText: p,
                              decoration: inputDecoration,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value.length < 6 ||
                                    !RegExp(
                                      r'\d',
                                    ).hasMatch(value) ||
                                    !RegExp(r'[A-Z]').hasMatch(value)) {
                                  return "incorrect password";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )),
                  GetBuilder<homecontroller>(
                    builder: (controller) => Container(
                      margin: const EdgeInsets.only(top: 20, right: 5, left: 5),
                      child: ElevatedButton(
                        onPressed: (() async {
                          var formdata = formstate.currentState;
                          if (formdata!.validate()) {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email.text,
                                password: passeword.text,
                              );
                              CollectionReference usersRef = FirebaseFirestore
                                  .instance
                                  .collection('users');
                              usersRef.doc(email.text).set({
                                'name': username.text,
                                'email': email.text,
                                'phone': phone.text,
                                'password': passeword.text,
                              });

                              if (credential.user != null) {
                                // ignore: use_build_context_synchronously
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                AwesomeDialog(
                                  context: context,
                                  autoHide: const Duration(seconds: 3),
                                  dialogType: DialogType.error,
                                  headerAnimationLoop: false,
                                  animType: AnimType.scale,
                                  title: 'Warning',
                                  desc: 'password is too weak',
                                  buttonsTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 172, 29, 29)),
                                  showCloseIcon: true,
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    const Color(0xffA5A5A5);
                                  },
                                ).show();
                              } else if (e.code == 'email-already-in-use') {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  headerAnimationLoop: false,
                                  animType: AnimType.scale,
                                  title: 'Warning',
                                  desc: 'mail already in use',
                                  buttonsTextStyle:
                                      const TextStyle(color: Colors.black),
                                  showCloseIcon: true,
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    const Color(0xffA5A5A5);
                                  },
                                ).show();
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 64, 209, 41),
                          backgroundColor:
                              const Color.fromARGB(255, 176, 47, 47),
                          fixedSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: mwd * 0.3,
                      ),
                      IconButton(
                        onPressed: () async {
                          UserCredential cred = await signInWithGoogle();
                          if (cred.user != null) {
                            // ignore: use_build_context_synchronously
                          }
                        },
                        icon: Icon(Icons.mail_outline, size: 50),
                        color: Color.fromARGB(255, 192, 56, 56),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () async {
                          UserCredential cred = await signInWithGoogle();
                          if (cred.user != null) {
                            // ignore: use_build_context_synchronously
                          }
                        },
                        icon: Icon(Icons.apple, size: 50),
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("already have an account ?"),
                  ),
                ],
              ),
            ],
          ),
        ))
      ],
    ));
  }
}
