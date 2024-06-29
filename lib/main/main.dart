import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../ui/components/components.dart';
import 'factories/factories.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
        title: '4Devs',
        debugShowCheckedModeBanner: false,
        theme: makeAppTheme(),
        initialRoute: '/login',
        getPages: [
          GetPage(name: '/login', page: makeLoginPage),
          GetPage(
              name: '/surveys',
              page: () => const Scaffold(body: Text('Enquetes'))),
        ]);
  }
}
