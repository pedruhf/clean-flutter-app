import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';

import 'package:clean_flutter_app/ui/pages/pages.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  late SplashPresenterSpy presenter;
  late StreamController<String> navigateToController;

  Future<void> loadPage(WidgetTester widgetTester) async {
    presenter = SplashPresenterSpy();
    when(() => presenter.checkAccount())
        .thenAnswer((_) => Future.value());
    navigateToController = StreamController<String>();
    when(() => presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);

    await widgetTester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashPage(presenter: presenter)),
        GetPage(
            name: '/any_route',
            page: () => const Scaffold(
                  body: Text('fake page'),
                )),
      ],
    ));
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets('should present spinner on page load',
      (WidgetTester widgetTester) async {
    await loadPage(widgetTester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should call checkAccount on page load',
      (WidgetTester widgetTester) async {
    await loadPage(widgetTester);

    verify(() => presenter.checkAccount()).called(1);
  });

  testWidgets('should change page', (WidgetTester widgetTester) async {
    await loadPage(widgetTester);

    navigateToController.add('any_route');
    await widgetTester.pumpAndSettle();

    expect(Get.currentRoute, 'any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('should not change page', (WidgetTester widgetTester) async {
    await loadPage(widgetTester);

    navigateToController.add('');
    await widgetTester.pump();

    expect(Get.currentRoute, '/');
    expect(find.text('fake page'), findsNWidgets(0));
  });
}
