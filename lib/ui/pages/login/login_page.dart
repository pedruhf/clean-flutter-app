import 'package:clean_flutter_app/ui/pages/login/components/email_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/pages/pages.dart';
import '../../components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  const LoginPage({super.key, this.presenter});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter?.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              return showLoading(context);
            }
            return hideLoading(context);
          });

          widget.presenter?.mainErrorStream.listen((error) {
            showErrorMessage(context, error);
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const LoginHeader(),
                const Headline1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          StreamBuilder<String>(
                              stream: widget.presenter?.emailErrorStream,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    icon: Icon(
                                      Icons.email,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    errorText: snapshot.data?.isEmpty == true
                                        ? null
                                        : snapshot.data,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (email) =>
                                      widget.presenter?.validateEmail(email),
                                );
                              }),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 32),
                            child: EmailInput(),
                          ),
                          StreamBuilder<bool>(
                              stream: widget.presenter?.isFormValidStream,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                    onPressed: snapshot.data == true
                                        ? widget.presenter?.auth
                                        : null,
                                    child: Text('Entrar'.toUpperCase()));
                              }),
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
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
