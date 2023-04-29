import 'package:doctor_home_ui/pages/bottomnav.dart';

import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Home Ui',
      home: BottomNav(),
    );
  }
}
