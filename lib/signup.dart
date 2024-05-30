import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  bool obscureText = false;
  bool obscureConfirmText = false;
  bool Flag = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userController = TextEditingController();
  var confirmController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                height: 210.h,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/login.webp"),
                      fit: BoxFit.cover),
                ),
              ),
              const Text(
                "Welcome Back !!",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          Container(
            height: 580.h,
            decoration: BoxDecoration(
              color: Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "User Name",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextFormField(
                      controller: userController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  //! for email
                  const Text(
                    "EMAIL",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Enter your Email',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  //! for password
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "PASSWORD",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: obscureText,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: '***********',
                        hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: obscureText
                              ? const Icon(Icons.remove_red_eye)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "CONFIRM PASSWORD",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextFormField(
                      controller: confirmController,
                      obscureText: obscureConfirmText,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: '***********',
                        hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              obscureConfirmText = !obscureConfirmText;
                            });
                          },
                          child: obscureConfirmText
                              ? const Icon(Icons.remove_red_eye)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  //! for forget password
                  SizedBox(
                    height: 30.h,
                  ),

                  //! for login button
                  SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 161, 156, 156),
                      ),
                      onPressed: () {
                        signup();
                      },
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account ?",
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w400),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  void signup() async {
    try {
      if (passwordController.text.trim() != confirmController.text.trim())
        return;
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      await credential.user?.updateDisplayName(userController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have signup'),
        ),
      );
      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
