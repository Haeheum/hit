import 'package:flutter/material.dart';

import 'app/domain/home/views/home_screen.dart';
import 'core/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      home: const HomeScreen(),
    );
  }
}
