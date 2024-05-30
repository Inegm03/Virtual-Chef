import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool obscureText = false; // eye
  bool Flag = false;  // checkbox
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

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
                    height: 15.h,
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
                        hintText: 'Enter your Password',
                        border: InputBorder.none,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: obscureText
                              ? const Icon(Icons.remove_red_eye) //true
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  //! for forget password
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        // hold state Checked box
                        value: Flag,

                        // invoke when user interact with checkedbox
                        onChanged: (val) {
                          // Called to update data
                          //  Rebuild Widget New State
                          setState(() {
                            // update var in new val
                            Flag = val!;
                          });
                        },

                        side: BorderSide(color: Colors.black87),
                        activeColor: Colors
                            .green, // Change the color when the checkbox is checked
                        checkColor:
                            Colors.white, // Change the color of the checkmark
                      ),
                      Text(
                        "remember me",
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w400),
                      ),
                      Spacer(),
                      Text(
                        "forget password ?",
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
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
                        login();
                      },
                      child: Text(
                        "LOGIN",
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
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "or signup with",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  InkWell(
                    //clickable
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: Image.asset("assets/images/google logo.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
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
                          "SIGN UP",
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

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        // You can retrieve the user's Google information as follows
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithCredential(credential);
        // FirebaseAuth.instance.currentUser?.updateDisplayName(displayName)
        // to Naigate in HomePage Screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        // Use this information to authenticate with your backend
        print("Google User Name: ${googleSignInAccount.displayName}");
        // Here, you can also navigate the user to another screen or perform other actions
        await googleSignIn.signOut();
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  void login() async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have login'),
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
