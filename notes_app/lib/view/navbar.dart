import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes_app/SQLite/sqlite.dart';
import 'package:notes_app/view/login_page.dart';
import 'package:notes_app/view/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String? username;

  // String path =
  //     "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp";

  String picPath = "";


  @override
  void initState() {
    super.initState();
    fetchAndDisplayUsername().then((value) {
      fetchProfilePic();
    },);
  }

  Future<void> fetchAndDisplayUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    setState(() {
      username = storedUsername ?? "Username not found";
    });
  }
  
  Future<void> logout(BuildContext context) async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.clear(); // Clear all shared preferences

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  Future<void> fetchProfilePic() async {
    if (username != null) {
      String? profilePicUrl = await dbHelper.fetchProfilePic(username!);
      setState(() {
        picPath = profilePicUrl ?? "";
        print('picPath $picPath');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Container(
                    width: 180.0,
                    height: 180.0,
                    child: CircleAvatar(
                      backgroundImage: picPath.isNotEmpty
                          ? FileImage(File(picPath))
                          : const AssetImage('assets/image/defaultProfile.jpeg') as ImageProvider,
                    ),
                  ),
                ),

              Text(username ?? 'Username not found!', style: TextStyle( color: Colors.deepPurple.shade300, fontSize: 24),),
              SizedBox(height: 20,),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.pink.shade300),
            title: Text(
              "Sign out",
              style: TextStyle(color: Colors.pink.shade300),
            ),
            onTap: () {
              logout(context);
            },
          ),
        ],
      ),
    );
  }
}
