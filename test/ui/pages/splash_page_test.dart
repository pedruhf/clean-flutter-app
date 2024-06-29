import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({super.key, required this.presenter });

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();

    return Scaffold(
      appBar: AppBar(title: const Text('4Dev'),),
      body: const Center(child: CircularProgressIndicator(),),
    );
  }
}

abstract class SplashPresenter {
  Future<void> loadCurrentAccount();
}

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  late SplashPresenterSpy presenter;

  Future<void> loadPage(WidgetTester widgetTester) async {
    presenter = SplashPresenterSpy();
    when(() => presenter.loadCurrentAccount()).thenAnswer((_) => Future.value());

    await widgetTester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => SplashPage(presenter: presenter)),
        ],
      )
    );
  }

  testWidgets('should present spinner on page load', (WidgetTester widgetTester) async {
    await loadPage(widgetTester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should call loadCurrentAccount on page load', (WidgetTester widgetTester) async {
    await loadPage(widgetTester);

    verify(() => presenter.loadCurrentAccount()).called(1);
  });
}
