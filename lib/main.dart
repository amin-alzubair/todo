
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo/layouts/main_layout/main_layout.dart';
import 'package:todo/modeuls/counter/counter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MainLayout() ,
    );
  }
}


