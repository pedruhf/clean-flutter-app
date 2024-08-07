import 'dart:async';

import 'package:clean_flutter_app/ui/helpers/errors/ui_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_flutter_app/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  void mockAuth() => when(() => auth()).thenAnswer((_) => Future(() {}));
}

void main() {
  late LoginPresenterSpy presenter;
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> mainErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<String> navigateToController;

  void initStreams() {
    emailErrorController = StreamController<UIError?>();
    passwordErrorController = StreamController<UIError?>();
    mainErrorController = StreamController<UIError?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    navigateToController = StreamController<String>();
  }

  void mockStreams() {
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    presenter.mockAuth();
    initStreams();
    mockStreams();

    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(presenter: presenter)),
        GetPage(
            name: '/fake_page',
            page: () => const Scaffold(
                  body: Text('fake page'),
                )),
      ],
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets("should load with correct initial state", (tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets("should call validate with correct values", (tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));
  });

  testWidgets("should presents error if email is invalid", (tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);
  });

  testWidgets("should presents error if email is empty", (tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets("should presents no error if email is valid", (tester) async {
    await loadPage(tester);

    emailErrorController.add(null);
    await tester.pump();

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets("should presents error if password is empty", (tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets("should presents no error if password is valid", (tester) async {
    await loadPage(tester);

    passwordErrorController.add(null);
    await tester.pump();

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);
  });

  testWidgets("should enable button if form is valid", (tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets("should disable button if form is invalid", (tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets("should call authentication on form submit", (tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    verify(() => presenter.auth()).called(1);
  });

  testWidgets("should presents loading", (tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("should hide loading", (tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets("should presents error message if auth fails", (tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais inválidas'), findsOneWidget);
  });

  testWidgets("should presents error message if auth throws", (tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.unexpected);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em instantes'), findsOneWidget);
  });
  
  testWidgets("should change page on success", (tester) async {
    await loadPage(tester);

    navigateToController.add('/fake_page');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/fake_page');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('should not change page', (tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();

    expect(Get.currentRoute, '/login');
    expect(find.text('fake page'), findsNWidgets(0));
  });
}
