import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class welcome extends StatelessWidget {
  const welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              width: double.infinity,
              height: double.infinity,
              "assets/images/welcome.jpg",
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 280.h,
              left: 65.w,
              child: Image.asset(
                "assets/images/chef 2.png",
                width: 220.w,
                height: 220.h,
              ),
            ),
            Positioned(
              left: 25.w,
              bottom: 80.h,
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        color: Colors.black.withOpacity(.7)),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    child: Container(
                      width: 210.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        color: Colors.black.withOpacity(.7),
                      ),
                      child: Center(
                          child: Text(
                        "Let's start".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
