import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4Devs',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}