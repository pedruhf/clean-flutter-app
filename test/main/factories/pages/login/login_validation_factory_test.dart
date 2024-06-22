import 'package:test/test.dart';

import 'package:clean_flutter_app/validation/validators/email_validation.dart';
import 'package:clean_flutter_app/validation/validators/required_field_validation.dart';
import 'package:clean_flutter_app/main/factories/factories.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = getLoginValidations();

    expect(validations, [
      const RequiredFieldValidation('email'),
      const EmailValidation('email'),
      const RequiredFieldValidation('password'),
    ]);
  });
}