import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import './components/components.dart';
import '../../components/components.dart';
import '../../../utils/i18n/resources.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/errors/errors.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    void hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              return showLoading(context);
            }
            return hideLoading(context);
          });

          presenter.mainErrorStream.listen((error) {
            if (error == null) return;
            showErrorMessage(context, error.description);
          });

          presenter.navigateToStream.listen((page) {
            if (page == null|| page.isEmpty == true) return;
            Get.offAllNamed(page);
          });

          return GestureDetector(
            onTap: hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const LoginHeader(),
                  const Headline1(text: 'Login'),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: ListenableProvider(
                      create: (_) => presenter,
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            const EmailInput(),
                            const Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 32),
                              child: PasswordInput(),
                            ),
                            const LoginButton(),
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              child: TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.person),
                                label: Text(R.strings.addAccount),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
