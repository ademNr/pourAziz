// ignore_for_file: unused_local_variable, avoid_print, body_might_complete_normally_nullable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:store/views/page3.dart';
import '../../controller/Getx_controller/variabel.dart';
import '../../controller/commun/awesome_dialoge.dart';
import 'sing.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  TextEditingController mail = TextEditingController();
  TextEditingController passeword = TextEditingController();
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
    /*var inputDecoration = InputDecoration(
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
    );*/
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            width: mwd,
            height: mhd,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('image/bg_login.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
              /* decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  40,
                ),
                color: const Color.fromARGB(255, 225, 221, 221),
                boxShadow: [
                  BoxShadow(
                      color: const Color.fromARGB(255, 206, 205, 197)
                          .withOpacity(1),
                      spreadRadius: 6,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                      blurStyle: BlurStyle.outer // changes position of shadow
                      ),
                ],
              ),
              margin: const EdgeInsets.only(
                top: 250,
              ),*/
              margin: const EdgeInsets.only(left: 30, right: 30),
              width: mwd,
              height: mhd,
              child: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 170,
                          bottom: 60,
                          left: 26,
                        ),
                        child: Text(
                          "Welcome back",
                          style: TextStyle(
                            color: Color.fromARGB(255, 65, 61, 61),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GetBuilder(
                        init: homecontroller(),
                        builder: (controller) => Form(
                          key: formstate,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "please enter your email";
                                    }
                                  },
                                  controller: mail,
                                  onSaved: (value) {
                                    mail.text = value!;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    hintText: 'Enter your email',
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "please enter your password";
                                  }
                                },
                                controller: passeword,
                                obscureText: p,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      p
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color:
                                          const Color.fromARGB(255, 251, 0, 0),
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
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                            onPressed: (() async {
                              var formdata = formstate.currentState;
                              if (formdata!.validate()) {
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: mail.text,
                                          password: passeword.text);
                                  if (FirebaseAuth.instance.currentUser !=
                                      null) {
                                    homecontroller().mail = mail.text;
                                    passeword.text = "";

                                    if (credential.user != null) {
                                      Get.toEnd(() => page3());
                                    }
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    awoseme_dialoge().awoseme_dialoges(
                                      context,
                                      false,
                                      DialogType.warning,
                                      7,
                                      AnimType.scale,
                                      "warning",
                                      "no user found for that email",
                                      TextStyle(
                                          color:
                                              Color.fromARGB(255, 172, 29, 41)),
                                    );
                                  } else if (e.code == 'wrong-password') {
                                    awoseme_dialoge().awoseme_dialoges(
                                      context,
                                      false,
                                      DialogType.error,
                                      7,
                                      AnimType.scale,
                                      "warning",
                                      "password is wrong",
                                      TextStyle(
                                          color:
                                              Color.fromARGB(255, 172, 29, 29)),
                                    );
                                  }
                                }
                              }
                            }),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 31, 82, 6),
                              shadowColor: Colors.grey,
                              elevation: 5,
                              fixedSize: const Size(200, 35),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text("log in")),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => login()),
                                );
                              }
                            },
                            icon: Icon(Icons.mail_outline, size: 50),
                            color: Color.fromARGB(255, 185, 17, 56),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            onPressed: () async {
                              UserCredential cred = await signInWithGoogle();
                              if (cred.user != null) {
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => login()),
                                );
                              }
                            },
                            icon: Icon(Icons.apple, size: 50),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 65, 61, 61),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 30),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const singe()),
                                  );
                                });
                              },
                              child: const Text(
                                "Create a new account",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 65, 61, 61),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))),
                    ],
                  ),
                ],
              )),
        ],
      )),
    );
  }
}
