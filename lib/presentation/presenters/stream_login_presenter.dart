import 'dart:async';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/authentication.dart';

import '../protocols/protocols.dart';

class LoginState {
  String email = '';
  String password = '';
  String? emailError;
  String? passwordError;
  bool isLoading = false;
  String? mainError;

  bool get isFormValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      emailError == null &&
      passwordError == null;
}

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String?> get emailErrorStream =>
      _controller.isClosed ? Stream.value(null) : _controller.stream.map((state) => state.emailError).distinct();
  Stream<String?> get passwordErrorStream =>
      _controller.isClosed ? Stream.value(null) : _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream =>
      _controller.isClosed ? Stream.value(false) : _controller.stream.map((state) => state.isFormValid).distinct();
  Stream<bool> get isLoadingStream =>
      _controller.isClosed ? Stream.value(false) : _controller.stream.map((state) => state.isLoading).distinct();
  Stream<String?> get mainErrorStream =>
      _controller.isClosed ? Stream.value(null) : _controller.stream.map((state) => state.mainError).distinct();

  StreamLoginPresenter(
      {required this.validation, required this.authentication});

  void _update() {
    if(_controller.isClosed) return;
    _controller.add(_state);
  }

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    _update();
  }

  Future<void>? auth() async {
    _state.isLoading = true;
    _update();
    try {
      await authentication.auth(AuthenticationParams(email: _state.email, password: _state.password));
    } on DomainError catch (error) {
      _state.mainError = error.description;
    }
    _state.isLoading = false;
    _update();
  }

  void dispose() {
    _controller.close();
  }
}
