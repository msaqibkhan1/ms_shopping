import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ms_shopping/Screen/Home_Screen.dart';
import 'package:ndialog/ndialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  final postRef = FirebaseDatabase.instance.ref().child('Users');
  late double height, width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 350,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/image_search_1602841347222.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(),
            ),
          ),
          buildbottom(true),
          Positioned(
            child: Center(
              child: Container(
                height: 380,
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide: const BorderSide(
                                width: 10,
                                color: Colors.black,
                              )),
                          hintText: 'User Name',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide: const BorderSide(
                                width: 10,
                                color: Colors.black,
                              )),
                          hintText: 'Email',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide: const BorderSide(
                                width: 10,
                                color: Colors.black,
                              )),
                          hintText: 'Password',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide: const BorderSide(
                                width: 10,
                                color: Colors.black,
                              )),
                          hintText: 'Confirm Password',
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        width: 240,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                              text: 'By pressing the Submit you agree to our ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: 'term & Conditions',
                                    style: TextStyle(color: Colors.orange))
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          buildbottom(false),
        ],
      ),
    );
  }

  Positioned buildbottom(bool showShadow) {
    return Positioned(
      right: 0,
      left: 0,
      top: MediaQuery.of(context).size.height * .68,
      child: Center(
        child: Container(
            height: 90,
            width: 90,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15.0,
                    spreadRadius: 5.0,
                  ),
              ],
            ),
            child: !showShadow
                ? InkWell(
                    onTap: () async {
                      String email = emailController.text.trim();
                      String userName = userNameController.text.trim();
                      String password = passwordController.text.trim();
                      String confirmPassword =
                          confirmPasswordController.text.trim();
                      if (email.isEmpty ||
                          userName.isEmpty ||
                          password.isEmpty ||
                          confirmPassword.isEmpty) {
                        Fluttertoast.showToast(msg: 'Please fill the box');
                        return;
                      }
                      if (password.length < 6) {
                        Fluttertoast.showToast(
                            msg: 'At least 6 digit password');
                        return;
                      }
                      if (password != confirmPassword) {
                        Fluttertoast.showToast(msg: 'password not match');
                        return;
                      }

                      // Firebase Auth
                      ProgressDialog progressDialog = ProgressDialog(context,
                          message: const Text("Please wait..."),
                          title: const Text("SignUp..."));
                      progressDialog.show();
                      try {
                        int date = DateTime.now().millisecondsSinceEpoch;

                        FirebaseAuth auth = FirebaseAuth.instance;
                        UserCredential usercredential =
                            await auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        Fluttertoast.showToast(
                            msg: 'Success', backgroundColor: Colors.black);

                        String uid = usercredential.user!.uid;
                        await postRef.child(uid).set({
                          'date': date,
                          'email': email,
                          'uid': uid,
                          'userName': userName,
                        });
                        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>const HomeScreen()));
                      } on FirebaseAuthException catch (e) {
                        Fluttertoast.showToast(msg: e.message!);
                      }
                      progressDialog.dismiss();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                spreadRadius: 1,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 1))
                          ]),
                      child: const Icon(Icons.arrow_forward),
                    ),
                  )
                : const Center()),
      ),
    );
  }
}
