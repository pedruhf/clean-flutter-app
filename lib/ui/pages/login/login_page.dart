import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  const LoginPage({super.key, this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const LoginHeader(),
            const Headline1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: <Widget>[
                    StreamBuilder<String>(
                        stream: presenter?.emailErrorSteam,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              errorText: snapshot.data,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (email) =>
                                presenter?.validateEmail(email),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Senha',
                            icon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColorLight,
                            )),
                        obscureText: true,
                        onChanged: (password) =>
                            presenter?.validatePassword(password),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: null, child: Text('Entrar'.toUpperCase())),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person),
                        label: const Text('Criar conta'),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
