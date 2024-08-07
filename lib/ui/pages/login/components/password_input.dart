import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';
import '../../../helpers/errors/ui_error.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<UIError?>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Senha',
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.data?.description,
          ),
          obscureText: true,
          onChanged: (password) => presenter.validatePassword(password),
        );
      },
    );
  }
}
