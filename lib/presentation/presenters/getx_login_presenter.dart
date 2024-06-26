import 'package:clean_flutter_app/ui/pages/pages.dart';
import 'package:get/get.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/authentication.dart';

import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  String _email = '';
  String _password = '';
  final Rx<String?> _emailError = Rx('');
  final Rx<String?> _passwordError = Rx('');
  final Rx<String?> _mainError = Rx('');
  final _isFormValid = RxBool(false);
  final _isLoading = RxBool(false);

  @override
  Stream<String?> get emailErrorStream => _emailError.stream;
  @override
  Stream<String?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<String?> get mainErrorStream => _mainError.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxLoginPresenter(
      {required this.validation, required this.authentication});

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value =
      _email.isNotEmpty &&
      _password.isNotEmpty &&
      _emailError.value == null &&
      _passwordError.value == null;
  }

  @override
  Future<void> auth() async {
    _isLoading.value = true;
    try {
      await authentication.auth(AuthenticationParams(email: _email, password: _password));
    } on DomainError catch (error) {
      _mainError.value = error.description;
    }
    _isLoading.value = false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
