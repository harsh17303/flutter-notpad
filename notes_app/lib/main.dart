import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/view/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false, // Disable the debug banner
        title: 'Flutter Login and Signup',
        theme: ThemeData.light(),
        themeMode: ThemeMode.light,
        darkTheme: ThemeData.dark(),
        // ThemeData(
        //   primarySwatch: Colors.blue,
        //   brightness: Brightness.dark,
        // ),
        home: SplashPage());
  }
}
