import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4Dev'),),
      body: const Center(child: CircularProgressIndicator(),),
    );
  }
}

void main() {
  Future<void> loadPage(WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const SplashPage()),
        ],
      )
    );
  }

  testWidgets('should present spinner on page load', (WidgetTester widgetTester) async {
    await loadPage(widgetTester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
