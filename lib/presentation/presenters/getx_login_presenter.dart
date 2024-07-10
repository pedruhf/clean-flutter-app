import 'package:get/get.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/ui_error.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email = '';
  String _password = '';

  final Rx<UIError?> _emailError = Rx(null);
  final Rx<UIError?> _passwordError = Rx(null);
  final Rx<UIError?> _mainError = Rx(null);
  final Rx<String?> _navigateTo = Rx(null);
  final _isFormValid = RxBool(false);
  final _isLoading = RxBool(false);

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;
  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  GetxLoginPresenter(
      {required this.validation,
      required this.authentication,
      required this.saveCurrentAccount});

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        _validateField(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _email.isNotEmpty &&
        _password.isNotEmpty &&
        _emailError.value == null &&
        _passwordError.value == null;
  }

  UIError? _validateField({ required String field, required String value }) {
    final error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.invalidField: return UIError.invalidField;
      case ValidationError.requiredField: return UIError.requiredField;
      default: return null;
    }
  }

  @override
  Future<void> auth() async {
    try {
      _isLoading.value = true;
      final account = await authentication
          .auth(AuthenticationParams(email: _email, password: _password));
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch(error) {
        case DomainError.invalidCredentials: _mainError.value = UIError.invalidCredentials;
        default: _mainError.value = UIError.unexpected;
      }
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
