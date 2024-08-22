import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:notes_app/SQLite/sqlite.dart';
import 'package:notes_app/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String picPath = "";
  final DatabaseHelper dbHelper = DatabaseHelper();
  String? username;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    fetchAndDisplayUsername().then((value) {
      fetchProfilePic();
    },);

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

  Future<void> fetchAndDisplayUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    setState(() {
      username = storedUsername ?? "Username not found";
    });
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Save the image file path to the database
      if (username != null) {
        await dbHelper.updateProfilePic(username!, _imageFile!.path);
        setState(() {
          picPath = _imageFile!.path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  radius: 78,
                  child: CircleAvatar(
                    backgroundImage: picPath.isNotEmpty
                        ? FileImage(File(picPath))
                        : AssetImage('assets/image/defaultProfile.jpeg') as ImageProvider,
                    radius: 76,
                  ),
                ),
                const SizedBox(height: 30),
                ListTile(
                  leading: IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
                  title: Text(
                    username ?? "Loading...",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade200,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: const Text(
                    'username',
                    // style: TextStyle(color: Colors.white54),
                  ),
                ),
                const Divider(
                  // color: Colors.white54,
                  indent: 18.0,
                  endIndent: 18.0,
                  height: 10.0,
                ),
                ListTile(
                  leading: IconButton(onPressed: _pickImage, icon: const Icon(Icons.edit)),
                  title: Text(
                    "Edit Profile Pic",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade200,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: const Text(
                    'profile picture',
                    // style: TextStyle(color: Colors.white54),
                  ),
                ),
                const Divider(
                  // color: Colors.white54,
                  indent: 18.0,
                  endIndent: 18.0,
                  height: 10.0,
                ),
                ListTile(
                  leading: IconButton(onPressed: (){
                    Get.bottomSheet(
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight: Radius.circular(30)),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.light_mode, color: Colors.white,),
                              title: Text('Light Mode', style: TextStyle(color: Colors.white),),
                              onTap: (){
                                Get.changeTheme(ThemeData.light());
                                Get.back();
                              } ,
                            ),
                            ListTile(
                              leading: Icon(Icons.dark_mode, color: Colors.white),
                              title: Text('Dark Mode', style: TextStyle(color: Colors.white)),
                              onTap: (){
                                Get.changeTheme(ThemeData.dark());
                                Get.back();
                              } ,
                            )
                          ],
                        ),
                      )
                    );
                  }, icon: const Icon(Icons.settings)),
                  title: Text(
                    "Theme",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade200,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: const Text(
                    'Light, dark theme',
                    // style: TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    logout(context);
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
