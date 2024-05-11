abstract class LoginPresenter {
  Stream<String> get emailErrorSteam;

  void validateEmail(String email);
  void validatePassword(String password);
}
