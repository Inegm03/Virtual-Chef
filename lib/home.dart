import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'camera_page.dart';
import 'submit.dart' as recipe;
import 'gallery_page.dart' as gallery;
import 'favorites_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(

      statusBarIconBrightness: Brightness.light,
    ));

    // Initialize ScreenUtil for responsive UI
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.withOpacity(0.6),
        elevation: 0,
      ),
      drawer: Drawer(
        width: 303,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    FirebaseAuth.instance.currentUser!.displayName!,
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  accountEmail: Text(FirebaseAuth.instance.currentUser!.email!,
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.favorite, size: 30, color: Colors.white),
                  title: Text("Favorite", style: TextStyle(fontSize: 26, color: Colors.white)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage()));
                  },
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.logout, size: 30, color: Colors.white),
                  title: Text("Logout", style: TextStyle(fontSize: 26, color: Colors.white)),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: SizedBox(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 812.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/home.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                width: 375.w,
                height: 812.h,
                color: Colors.white70.withOpacity(0.04),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  SizedBox(height: 50.h),
                  _buildElevatedButton(context, "Open camera", CameraPage()),
                  SizedBox(height: 150.h),
                  _buildElevatedButton(context, "Upload from gallery", gallery.GalleryPage()),
                  SizedBox(height: 190.h),
                  _buildElevatedButton(context, "Write your ingredients", recipe.RecipePage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context, String text, Widget page) {
    return ElevatedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Text(
        text,
        style: GoogleFonts.pacifico(fontSize: 20.sp, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        minimumSize: Size(278.w, 77.h),
      ),
    );
  }
}
