import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_flutter_app/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String> emailErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    when(() => presenter.emailErrorSteam).thenAnswer((_) => emailErrorController.stream);
    final loginPage = MaterialApp(home: LoginPage( presenter: presenter ));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
  });

  testWidgets("should load with correct initial state", (tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
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

    emailErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });
}
